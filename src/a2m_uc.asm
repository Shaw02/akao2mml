;************************************************************************
;*									*
;*		逆ＭＭＬ部						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		音符出力					|
;---------------------------------------------------------------|
;	処理							|
;		音符・オクターブを計算して出力			|
;	引数							|
;		al	Note Number				|
;---------------------------------------------------------------|
.const
c_output_note_N		dw	offset c_output_note_C
			dw	offset c_output_note_Ds
			dw	offset c_output_note_D
			dw	offset c_output_note_Es
			dw	offset c_output_note_E
			dw	offset c_output_note_F
			dw	offset c_output_note_Gs
			dw	offset c_output_note_G
			dw	offset c_output_note_As
			dw	offset c_output_note_A
			dw	offset c_output_note_B
			dw	offset c_output_note_H
c_output_note_C		db	'c$'
c_output_note_Ds	db	'c+$'
c_output_note_D		db	'd$'
c_output_note_Es	db	'd+$'
c_output_note_E		db	'e$'
c_output_note_F		db	'f$'
c_output_note_Gs	db	'f+$'
c_output_note_G		db	'g$'
c_output_note_As	db	'g+$'
c_output_note_A		db	'a$'
c_output_note_B		db	'a+$'
c_output_note_H		db	'b$'


.code
c_output_note	proc	near
	pusha

	xor	ah,ah			;ax ← Note
	mov	dl,12			;
	div	dl			;ah ← octave
	xchg	al,ah			;al ← note

	push	ax
	mov	dl,'o'
	mov	ah,02h
	int	21h
	pop	ax

	push	ax
	dec	ah			
	call	hex2asc8
	mov	ah,09h
	int	21h			;オクターブ値
	pop	ax

	xor	ah,ah			;ax←Note Number
	shl	ax,1
	mov	bx,ax
	mov	dx,cs:[c_output_note_N + bx]
	mov	ah,09h
	int	21h			;音符の出力

c_output_note_End:
	popa
	ret
c_output_note	endp
;---------------------------------------------------------------|
;		音長出力					|
;---------------------------------------------------------------|
;	処理							|
;		音長（〜〜分音符）と、				|
;		それに、付点が何個付くかを計算する。		|
;	引数							|
;		ax	音長					|
;	コメント						|
;		昔書いたこのアルゴリズムだが、			|
;		最近見たら、何やってるのか解らなかったぜ。	|
;		ちゃんと、コメント書いておいた。		|
;		＆Ｃ言語ライクに書き直した			|
;---------------------------------------------------------------|
timebase	equ	48
c_output_length	proc	near

	local	c_output_length_Now:word

	pusha

	mov	c_output_length_Now,ax
	xor	cx,cx			;まず、付点個数＝０

	.if	(ax!=0)

		.while	(cx<14)
			mov	bx,0001h		;
			.if	(cx>0)			;　　　　　　　　　(2^付点の数)
				shl	bx,cl		;ax = 音長 × ───────────
			.endif				;　　　　　　　　(2^(付点の数+1)-1)
			mul	bx			;　　　↑　↑　↑　↑　↑
			shl	bx,1			;付点を取っ払った場合の音長を計算している。
			dec	bx			;
			div	bx			;

			.if	(dx==0)			;割り算で、余りがあったら、駄目
				mov	bx,ax		;
				xor	dx,dx		;
				xor	ax,ax		;
				mov	al,timebase	;
				shl	ax,2		;
				div	bx		; (timebase×4)÷音長
				.if	(dx==0)		;割り算で、余りがあったら、駄目
					.break
				.endif
			.endif

			mov	ax,c_output_length_Now
			inc	cx			;

		.endw				;付点の数増やしてやり直し。

		.if	(cx==14)		;
			xor	cx,cx		;bx reset
			push	ax		;（Stepで指定する。）
			mov	dl,'%'		;呼ぶ場合は、BX=0とする事
			mov	ah,02h		;
			int	21h		;
			pop	ax		;
		.endif

	.endif

	call	hex2asc16		;
	mov	ah,09h			;
	int	21h			;

	.while	(cx>0)			;付点表示
		mov	dl,'.'		;
		mov	ah,02h		;
		int	21h		;
		dec	cx		;
	.endw

c_output_length_End:			;
	popa				;
	ret				;
c_output_length	endp
;---------------------------------------------------------------|
;		無限ループ解析					|
;---------------------------------------------------------------|
;	処理							|
;		無限ループアドレスを検索する。			|
;	引数							|
;		bx	チャンネルの開始アドレス		|
;---------------------------------------------------------------|
.const
UCMOLS_LOOP_msg1	DB	'/*Loop=0x$'
UCMOLS_LOOP_msg2	DB	'*/$'
UCMOLS_LOOP_msg3	DB	'条件ジャンプが複雑すぎ$'
UCMOLS_LOOP_msg4	DB	'リピートが可笑しい$'

.data?
UCMOLS_LOOP_PTY		equ	8
UCMOLS_LOOP_ADDRESS	DW	UCMOLS_LOOP_PTY	dup(?)
UCMOLS_LOOP_Count	dw	?

.code
UCMO_LOOP_SEARCH	proc	near	uses ax bx cx dx di

	local	ptStart:WORD		;チャンネルの開始アドレス
	local	tempBX:WORD		;条件ジャンプ先の保存
	local	iCount:WORD		;0xFE07のカウント用

;	デバッグ用
	lea	dx,[UCMOLS_LOOP_msg1]
	mov	ah,09h
	int	21h

	;ループアドレスリセット
	push	es
	xor	ax,ax			;ax←0 変数クリア用
	mov	cx,UCMOLS_LOOP_PTY	;回数セット
	lea	di,[UCMOLS_LOOP_ADDRESS]
	push	cs			
	pop	es			;es:di ← アドレス
  rep	stosw				;一括セット
	pop	es

	mov	cs:[UC_LoopCountData],ax	;リピート処理用

	mov	cs:[UCMOLS_LOOP_Count],ax	;無限ループ用
	mov	tempBX,ax			;
	mov	iCount,1			;iCountは1


  .repeat		;0xFE07 コマンドに関連するリピートとする

    .repeat		;0xFE06 コマンドをつかった、強制ジャンプによるリピート

	MOV	AX,BX				;
	MOV	ptStart,AX		;先頭アドレス保存

      .repeat		;EoCが来るまでのリピート

	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み　曲
	LEA	DX,[UCMO_COMMAND_SIZE]	;
	ADD	DX,AX			;
	MOV	AH,AL			;AH←コマンド
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;データ読み込み　解析情報
	XCHG	BX,DX			;

ifdef	SPC	;------------------------
	;ループ命令の解析	;-------
	.if	(ah==comRepeatStart)
		inc	bx		;コマンドの分だけ進ませる
		call	Loop_StartEx
		.continue
	.elseif	(ah==comRepeatExit)
		inc	bx		;コマンドの分だけ進ませる
		call	Loop_ExitEx
		.continue
	.elseif	(ah==comRepeatEnd)
		inc	bx		;コマンドの分だけ進ませる
		call	Loop_EndEx
		.continue
	.endif
	;-------------------------------
endif	;--------------------------------

	.if	((al==0)||(al==9))	;音符・EoCだった場合の処理
ifdef	PS1	;------------------------
		.if	(ah<0F0h)	;
			mov	al,1	;
		.else
			mov	al,2	;
		.endif
else	;SPC	;------------------------
		mov	al,1	;
endif	;--------------------------------
	.endif

	.if	(al==6)
ifdef	SubCommand	;----------------
		xor	ax,ax
		MOV	al,byte ptr ES:[BX + 1]	;
		.if	(al==06h)
			MOV	DX,BX		;DX←FE06hコマンドのアドレス
			ADD	BX,2		;
			MOV	AX,ES:[BX]	;
			TEST	AX,AX		;
			JZ	UCMOL_EE	;If AX=0 Then Return
			add	ax,MUSIC_ADDRESSa	;FF8以外は+2
			add	bx,ax		;BX←ループ先アドレス
			mov	ax,bx		;AX←BX
			.break
		.elseif	(al==07h)
			.if	(tempBX!=0)	;条件ジャンプ先が登録されている？
				;デバッグ用
				lea	dx,[UCMOLS_LOOP_msg3]
				mov	ah,09h
				int	21h
			.endif
			inc	iCount		;
			add	bx,3		;
			mov	ax,es:[bx]	;
 ifndef	lastAkao	;------------------------
			add	ax,2		;FF8以外は
 endif	;--------------------------------
			add	ax,bx		;
			mov	tempBX,ax	;条件ジャンプ先
 ifdef	lastAkao	;------------------------
			add	bx,2		;FF8は、最後にカウント
 endif	;--------------------------------

; ifdef	lastAkao	;------------------------
;		.elseif	((al==04h)||(al==05h)||(al==1Dh)||(al==1Eh)||(al==1Fh))
; else	;--------------------------------
;		.elseif	((al==05h)||(al==1Dh)||(al==1Eh)||(al==1Fh))
; endif	;--------------------------------
;			add	bx,2
; ifdef	lastAkao	;------------------------
;		.elseif	((al==10h)||(al==14h)||(al==1Ch))
; else	;--------------------------------
;		.elseif	((al==10h)||(al==1Ch))
; endif	;--------------------------------
;			add	bx,3
;		.elseif	((al==01h)||(al==03h)||(al==09h))
;			add	bx,5
		.else
;			add	bx,4
			push	di
			mov	di,ax
			mov	al,byte ptr cs:[SubComSize + di]
			add	bx,ax
			pop	di
		.endif
else	;SPC	-------------------------
		.if	(tempBX!=0)
			;デバッグ用
			lea	dx,[UCMOLS_LOOP_msg3]
			mov	ah,09h
			int	21h
		.endif
		inc	iCount			;
		add	bx,1			;
		mov	ax,es:[bx]		;
		add	bx,2			;次のコマンド
  ifdef	PS1	;------------------------
		add	ax,bx
  else	;SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;ax←戻り先絶対アドレス
  endif	;--------------------------------
		mov	tempBX,ax		;条件ジャンプ先保存
endif	;--------------------------------

	.elseif	(al==7)
		jmp	UCMOL_EE		;終了

	.elseif	(al==8)
		mov	dx,bx			;
		ADD	BX,1			;
		MOV	AX,ES:[BX]		;
		TEST	AX,AX			;
		JZ	UCMOL_EE		;If AX=0 Then Return
ifdef	PS1	;------------------------
		add	ax,MUSIC_ADDRESSa
		add	ax,bx			;ax←戻り先絶対アドレス
else	;SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;ax←戻り先絶対アドレス
endif	;--------------------------------
		mov	bx,ax			;BX←AX
		.break
	.else
		MOV	AH,0		;
		ADD	BX,AX		;

	.endif

      .until	0	;このリピートは、".break"で抜ける。



	;強制ジャンプだったら、そのジャンプ先でまた繰り返す。
    .until	((ptStart<=ax)&&(dx>=ax))



	mov	ax,cs:[UCMOLS_LOOP_Count]	;
	shl	ax,1				;
	push	ax				;bx←入れる所
	MOV	ax,bx				;ax←無限ループ先
	pop	bx				;無限ループアドレスの登録
	MOV	CS:[UCMOLS_LOOP_ADDRESS + bx],ax

	;デバッグ用出力
	call	dat2hex16	;
	MOV	AH,09H		;
	INT	21H		;
	mov	dl,','		;
	mov	ah,02h		;
	int	21h		;

	mov	bx,tempBX			;次の開始点
	mov	tempBX,0			;一応クリア

	inc	cs:[UCMOLS_LOOP_Count]		;無限ループ数　＋＋
	dec	iCount				;0xFE07用
  .until	(iCount==0)

UCMOL_EE:					;無限ループ無し！
	;デバッグ用
	lea	dx,[UCMOLS_LOOP_msg2]
	mov	ah,09h
	int	21h

	RET
UCMO_LOOP_SEARCH	endp
;---------------------------------------------------------------|
;		コマンド変換					|
;---------------------------------------------------------------|
;	処理							|
;		１コマンドだけ、MMLにデコードして出力する	|
;	引数							|
;		ds	＝csである事				|
;		es:bx	コマンドのポインタ			|
;	返値							|
;		es:bx	次のコマンドのポインタ			|
;	破壊							|
;		ほぼ全てのレジスタ				|
;---------------------------------------------------------------|
;逆ＭＭＬ変換情報のあるアドレス
;実体は、タイトル毎の定義ファイル。
.const
UC_DATA_ADDRESS	DW	OFFSET UC_D00	;コマンド00h
		DW	OFFSET UC_D01
		DW	OFFSET UC_D02
		DW	OFFSET UC_D03
		DW	OFFSET UC_D04
		DW	OFFSET UC_D05
		DW	OFFSET UC_D06
		DW	OFFSET UC_D07
		DW	OFFSET UC_D08
		DW	OFFSET UC_D09
		DW	OFFSET UC_D0A
		DW	OFFSET UC_D0B
		DW	OFFSET UC_D0C
		DW	OFFSET UC_D0D
		DW	OFFSET UC_D0E
		DW	OFFSET UC_D0F
		DW	OFFSET UC_D10
		DW	OFFSET UC_D11
		DW	OFFSET UC_D12
		DW	OFFSET UC_D13
		DW	OFFSET UC_D14
		DW	OFFSET UC_D15
		DW	OFFSET UC_D16
		DW	OFFSET UC_D17
		DW	OFFSET UC_D18
		DW	OFFSET UC_D19
		DW	OFFSET UC_D1A
		DW	OFFSET UC_D1B
		DW	OFFSET UC_D1C
		DW	OFFSET UC_D1D
		DW	OFFSET UC_D1E
		DW	OFFSET UC_D1F
		DW	OFFSET UC_D20
		DW	OFFSET UC_D21
		DW	OFFSET UC_D22
		DW	OFFSET UC_D23
		DW	OFFSET UC_D24
		DW	OFFSET UC_D25
		DW	OFFSET UC_D26
		DW	OFFSET UC_D27
		DW	OFFSET UC_D28
		DW	OFFSET UC_D29
		DW	OFFSET UC_D2A
		DW	OFFSET UC_D2B
		DW	OFFSET UC_D2C
		DW	OFFSET UC_D2D
		DW	OFFSET UC_D2E
		DW	OFFSET UC_D2F
		DW	OFFSET UC_D30
		DW	OFFSET UC_D31
		DW	OFFSET UC_D32
		DW	OFFSET UC_D33
		DW	OFFSET UC_D34
		DW	OFFSET UC_D35
		DW	OFFSET UC_D36
		DW	OFFSET UC_D37
		DW	OFFSET UC_D38
		DW	OFFSET UC_D39
		DW	OFFSET UC_D3A
		DW	OFFSET UC_D3B
		DW	OFFSET UC_D3C
		DW	OFFSET UC_D3D
		DW	OFFSET UC_D3E
		DW	OFFSET UC_D3F
		DW	OFFSET UC_D40
		DW	OFFSET UC_D41
		DW	OFFSET UC_D42
		DW	OFFSET UC_D43
		DW	OFFSET UC_D44
		DW	OFFSET UC_D45
		DW	OFFSET UC_D46
		DW	OFFSET UC_D47
		DW	OFFSET UC_D48
		DW	OFFSET UC_D49
		DW	OFFSET UC_D4A
		DW	OFFSET UC_D4B
		DW	OFFSET UC_D4C
		DW	OFFSET UC_D4D
		DW	OFFSET UC_D4E
		DW	OFFSET UC_D4F
		DW	OFFSET UC_D50
		DW	OFFSET UC_D51
		DW	OFFSET UC_D52
		DW	OFFSET UC_D53
		DW	OFFSET UC_D54
		DW	OFFSET UC_D55
		DW	OFFSET UC_D56
		DW	OFFSET UC_D57
		DW	OFFSET UC_D58
		DW	OFFSET UC_D59
		DW	OFFSET UC_D5A
		DW	OFFSET UC_D5B
		DW	OFFSET UC_D5C
		DW	OFFSET UC_D5D
		DW	OFFSET UC_D5E
		DW	OFFSET UC_D5F
		DW	OFFSET UC_D60
		DW	OFFSET UC_D61
		DW	OFFSET UC_D62
		DW	OFFSET UC_D63
		DW	OFFSET UC_D64
		DW	OFFSET UC_D65
		DW	OFFSET UC_D66
		DW	OFFSET UC_D67
		DW	OFFSET UC_D68
		DW	OFFSET UC_D69
		DW	OFFSET UC_D6A
		DW	OFFSET UC_D6B
		DW	OFFSET UC_D6C
		DW	OFFSET UC_D6D
		DW	OFFSET UC_D6E
		DW	OFFSET UC_D6F
		DW	OFFSET UC_D70
		DW	OFFSET UC_D71
		DW	OFFSET UC_D72
		DW	OFFSET UC_D73
		DW	OFFSET UC_D74
		DW	OFFSET UC_D75
		DW	OFFSET UC_D76
		DW	OFFSET UC_D77
		DW	OFFSET UC_D78
		DW	OFFSET UC_D79
		DW	OFFSET UC_D7A
		DW	OFFSET UC_D7B
		DW	OFFSET UC_D7C
		DW	OFFSET UC_D7D
		DW	OFFSET UC_D7E
		DW	OFFSET UC_D7F
		DW	OFFSET UC_D80
		DW	OFFSET UC_D81
		DW	OFFSET UC_D82
		DW	OFFSET UC_D83
		DW	OFFSET UC_D84
		DW	OFFSET UC_D85
		DW	OFFSET UC_D86
		DW	OFFSET UC_D87
		DW	OFFSET UC_D88
		DW	OFFSET UC_D89
		DW	OFFSET UC_D8A
		DW	OFFSET UC_D8B
		DW	OFFSET UC_D8C
		DW	OFFSET UC_D8D
		DW	OFFSET UC_D8E
		DW	OFFSET UC_D8F
		DW	OFFSET UC_D90
		DW	OFFSET UC_D91
		DW	OFFSET UC_D92
		DW	OFFSET UC_D93
		DW	OFFSET UC_D94
		DW	OFFSET UC_D95
		DW	OFFSET UC_D96
		DW	OFFSET UC_D97
		DW	OFFSET UC_D98
		DW	OFFSET UC_D99
		DW	OFFSET UC_D9A
		DW	OFFSET UC_D9B
		DW	OFFSET UC_D9C
		DW	OFFSET UC_D9D
		DW	OFFSET UC_D9E
		DW	OFFSET UC_D9F
		DW	OFFSET UC_DA0
		DW	OFFSET UC_DA1
		DW	OFFSET UC_DA2
		DW	OFFSET UC_DA3
		DW	OFFSET UC_DA4
		DW	OFFSET UC_DA5
		DW	OFFSET UC_DA6
		DW	OFFSET UC_DA7
		DW	OFFSET UC_DA8
		DW	OFFSET UC_DA9
		DW	OFFSET UC_DAA
		DW	OFFSET UC_DAB
		DW	OFFSET UC_DAC
		DW	OFFSET UC_DAD
		DW	OFFSET UC_DAE
		DW	OFFSET UC_DAF
		DW	OFFSET UC_DB0
		DW	OFFSET UC_DB1
		DW	OFFSET UC_DB2
		DW	OFFSET UC_DB3
		DW	OFFSET UC_DB4
		DW	OFFSET UC_DB5
		DW	OFFSET UC_DB6
		DW	OFFSET UC_DB7
		DW	OFFSET UC_DB8
		DW	OFFSET UC_DB9
		DW	OFFSET UC_DBA
		DW	OFFSET UC_DBB
		DW	OFFSET UC_DBC
		DW	OFFSET UC_DBD
		DW	OFFSET UC_DBE
		DW	OFFSET UC_DBF
		DW	OFFSET UC_DC0
		DW	OFFSET UC_DC1
		DW	OFFSET UC_DC2
		DW	OFFSET UC_DC3
		DW	OFFSET UC_DC4
		DW	OFFSET UC_DC5
		DW	OFFSET UC_DC6
		DW	OFFSET UC_DC7
		DW	OFFSET UC_DC8
		DW	OFFSET UC_DC9
		DW	OFFSET UC_DCA
		DW	OFFSET UC_DCB
		DW	OFFSET UC_DCC
		DW	OFFSET UC_DCD
		DW	OFFSET UC_DCE
		DW	OFFSET UC_DCF
		DW	OFFSET UC_DD0
		DW	OFFSET UC_DD1
		DW	OFFSET UC_DD2
		DW	OFFSET UC_DD3
		DW	OFFSET UC_DD4
		DW	OFFSET UC_DD5
		DW	OFFSET UC_DD6
		DW	OFFSET UC_DD7
		DW	OFFSET UC_DD8
		DW	OFFSET UC_DD9
		DW	OFFSET UC_DDA
		DW	OFFSET UC_DDB
		DW	OFFSET UC_DDC
		DW	OFFSET UC_DDD
		DW	OFFSET UC_DDE
		DW	OFFSET UC_DDF
		DW	OFFSET UC_DE0
		DW	OFFSET UC_DE1
		DW	OFFSET UC_DE2
		DW	OFFSET UC_DE3
		DW	OFFSET UC_DE4
		DW	OFFSET UC_DE5
		DW	OFFSET UC_DE6
		DW	OFFSET UC_DE7
		DW	OFFSET UC_DE8
		DW	OFFSET UC_DE9
		DW	OFFSET UC_DEA
		DW	OFFSET UC_DEB
		DW	OFFSET UC_DEC
		DW	OFFSET UC_DED
		DW	OFFSET UC_DEE
		DW	OFFSET UC_DEF
		DW	OFFSET UC_DF0
		DW	OFFSET UC_DF1
		DW	OFFSET UC_DF2
		DW	OFFSET UC_DF3
		DW	OFFSET UC_DF4
		DW	OFFSET UC_DF5
		DW	OFFSET UC_DF6
		DW	OFFSET UC_DF7
		DW	OFFSET UC_DF8
		DW	OFFSET UC_DF9
		DW	OFFSET UC_DFA
		DW	OFFSET UC_DFB
		DW	OFFSET UC_DFC
		DW	OFFSET UC_DFD
		DW	OFFSET UC_DFE
		DW	OFFSET UC_DFF

ifdef	PS1	;---------------
c_decode_Length	db	1
		db	2
		db	4
		db	8
		db	16
		db	32
		db	64
		db	6
		db	12
		db	24
		db	48
endif	;-----------------------

.code
c_decode	proc	near

	local	UCMO_ComStartFlag:byte

	mov	UCMO_ComStartFlag,1

	;コマンド読み込み
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント

ifdef	Rhythm12	;---------------
	.if	((ax<(Rhythm12*12))&&(cs:[UC_Rhythm_flag]==1))
		pusha

		mov	dl,Rhythm12
		div	dl		;cl←音程
		mov	cx,ax		;ch←余り

		push	ax

		mov	dl,'$'
		mov	ah,02h
		int	21h		;$

		.if	(cl<6)
			mov	dl,'x'
			add	cl,30h
		.else
			mov	dl,'y'
			add	cl,30h-6
		.endif
		push	dx
		mov	dl,cl
		mov	ah,02h
		int	21h		;番号（0〜5）

		pop	dx
		mov	ah,02h
		int	21h		;マクロ　英文字

		pop	ax

  ifdef	PS1	;-----------------------
		;音符の表示
		mov	bx,cs:[UC_Rhythm_Address]
		xor	ah,ah
		add	bx,ax
		shl	ax,2
		add	bx,ax
		inc	bx		;bx += ax*5 + 1
		mov	al,es:[bx]
		call	c_output_note

		;音長の表示
		.if	(byte ptr cs:[UC_Step_work]==0)
		;	xor	ax,ax
		;	mov	al,ch		;ax←音長さコード
		;	mov	bx,offset c_decode_Length
		;	add	bx,ax
		;	mov	ah,cs:[bx]
			xor	bx,bx
			mov	bl,ch
			mov	ah,byte ptr cs:[c_decode_Length + bx]
		.else
			mov	dl,'%'
			mov	ah,02h			;
			int	21h			;
			mov	ah,byte ptr cs:[UC_Step_work]
		.endif
		call	hex2asc8
		mov	ah,09h
		int	21h			;
  endif	;-------------------------------

		popa
	.endif
endif	;-------------------------------

	SHL	AX,1			;
	PUSH	BX			;
;	MOV	BX,OFFSET UC_DATA_ADDRESS
;	ADD	BX,AX			;BX←変換情報アドレス格納アドレス
;	MOV	DX,CS:[BX]		;DX←変換情報アドレス
	mov	bx,ax			;
	mov	dx,cs:[UC_DATA_ADDRESS + bx]
	POP	BX			;

	;EoCじゃない間だったら、無限ループ。
	.while	(byte ptr cs:[c_Command_EoC]==00h)

	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;変換情報読み込み
	INC	BX			;
	XCHG	BX,DX			;

	.if	(al==00h)
		;変換情報に0x00があったら、.break
		.break				;End

	.elseif	(al==10h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;データ読み込み
		INC	BX			;ポインタインクリメント
		CALL	HEX2ASC8		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==11h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;データ読み込み
		INC	BX			;ポインタインクリメント
		CALL	FH2A8			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==12h)
		PUSH	DX
		MOV	AX,ES:[BX]		;データ読み込み
		INC	BX			;ポインタインクリメント
		INC	BX			;ポインタインクリメント
		CALL	HEX2ASC16		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==13h)
		PUSH	DX			;
		MOV	AX,ES:[BX]		;データ読み込み
		INC	BX			;ポインタインクリメント
		INC	BX			;ポインタインクリメント
		CALL	FH2A16			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==20h)

ifdef	Rhythm12	;---------------
ifdef	PS1	;-----------------------
	    .if	((UCMO_ComStartFlag==1)&&(byte ptr es:[bx-1]<(Rhythm12*12))&&(cs:[UC_Rhythm_flag]==1))

	    .else
endif	;-------------------------------
endif	;-------------------------------

		.if	((UCMO_ComStartFlag==1)&&(byte ptr es:[bx-1]<=Music_Note)&&(byte ptr cs:[UC_Step_work]!=0))

			XCHG	BX,DX			;
			push	dx

			mov	dl,cs:[bx]		;1文字表示
			mov	ah,02h			;
			int	21h			;

			mov	dl,cs:[bx+1]		;
			.if	(dl=='+')
				inc	bx		;1
				mov	ah,02h		;
				int	21h		;文字表示
			.endif
			mov	dl,'%'
			mov	ah,02h			;
			int	21h			;

			mov	ah,byte ptr cs:[UC_Step_work]
			call	hex2asc8
			mov	ah,09h
			int	21h			;

			mov	byte ptr cs:[UC_Step_work],0

			pop	dx			;
			XCHG	BX,DX			;

		.else

			PUSH	DX			;
			MOV	AH,09H			;表示
			INT	21H			;
			POP	DX			;

		.endif

ifdef	Rhythm12	;---------------
ifdef	PS1	;-----------------------
	    .endif
endif	;-------------------------------
endif	;-------------------------------

		.repeat
			XCHG	BX,DX			;
			MOV	AL,CS:[BX]		;変換情報読み込み
			INC	BX			;
			XCHG	BX,DX			;
		.until	(al=='$')

	;次の音符が、タイ付きか検索する。
	.elseif	(al==21h)

		PUSH	BX			;
		PUSH	DX			;

		.repeat

		XOR	AX,AX			;
		MOV	AL,ES:[BX]		;データ読み込み　曲
		lea	DX,[UCMO_COMMAND_SIZE]
		ADD	DX,AX			;
		XCHG	BX,DX			;
		MOV	AL,CS:[BX]		;データ読み込み　解析情報
		XCHG	BX,DX			;

		.if	(al==0)			;０：解析終了（音符 or 休符）
			.if	(byte ptr cs:[UC_portamento_D]!=0)
				mov	dl,'B'		;
				mov	ah,02h		;
				int	21h		;
			;	ifdef	SPC	;-------
				mov	dl,'W'		;
				mov	ah,02h		;
				int	21h		;
				mov	ax,word ptr cs:[UC_Detune_D]	;
				mov	byte ptr cs:[UC_portamento_D],0
				CALL	HEX2ASC16	;出力
			;	endif	;---------------
			;	ifdef	PS1	;-------
			;	mov	dl,'S'		;
			;	mov	ah,02h		;
			;	int	21h		;
			;	mov	ax,0		;
			;	mov	ah,byte ptr cs:[UC_Detune_D]	;
			;	mov	byte ptr cs:[UC_portamento_D],0
			;	CALL	HEX2ASC8	;出力
			;	endif	;---------------
				MOV	AH,09H		;
				INT	21H		;ピッチベンドのリセット
			.endif
			.break

		.elseif	(al==6)
ifdef	SubCommand	;------------------------
			xor	ax,ax
			MOV	al,byte ptr ES:[BX+1]
			.if	(al==06h)
				.break
;  ifdef	lastAkao	;------------------------
;			.elseif	((al==04h)||(al==05h)||(al==1Dh)||(al==1Eh)||(al==1Fh))
;  else	;--------------------------------
;			.elseif	((al==05h)||(al==1Dh)||(al==1Eh)||(al==1Fh))
;  endif	;--------------------------------
;				add	bx,2
;  ifdef	lastAkao	;------------------------
;			.elseif	((al==10h)||(al==14h)||(al==1Ch))
;  else	;--------------------------------
;			.elseif	((al==10h)||(al==1Ch))
;  endif	;--------------------------------
;				add	bx,3
;			.elseif	((al==01h)||(al==03h)||(al==07h)||(al==09h))
;				add	bx,5
			.else
;				add	bx,4
				push	di
				mov	di,ax
				mov	al,cs:[SubComSize + di]
				add	bx,ax
				pop	di
			.endif			;６：サブコマンド
else	;--------------------------------
			.break			;６：解析終了
endif	;--------------------------------

		.elseif	((al==7)||(al==8))	;７, ８：解析終了（End of Channel）
			.break

		.elseif	(al==9)			;９：次の音程とタイで繋ぐ。
			mov	dl,'&'		;
			mov	ah,02h		;
			int	21h		;
			.break

		.else				;その他のケースは、加算
			MOV	AH,0		;
			ADD	BX,AX		;

		.endif

		.until	0

		POP	DX			;
		POP	BX			;


	.elseif	(al==24h)
		;次の1Byteを出力する。
		XCHG	BX,DX			;
		PUSH	DX			;
		MOV	AH,02H			;
		MOV	DL,CS:[BX]		;表示情報読み込み
		INT	21H			;表示
		INC	BX			;
		POP	DX			;
		XCHG	BX,DX			;

	.elseif	(al==0f0h)
		;ポインタを進めるだけ
		INC	BX			;ポインタインクリメント

	.elseif	(al==0ffh)
		;次のwordに示されるAddressをcallする。
		PUSH	DX			;
		PUSH	BX			;
		MOV	BX,DX			;
		MOV	DX,CS:[BX]		;
		POP	BX			;
		CALL	DX			;
		POP	DX			;

		INC	DX			;
		INC	DX			;

		.break	.if	(byte ptr cs:[c_Command_EoC]==01h)

	.else
		;その他のコードが出てきたら、そのチャンネルの逆MML終了
		mov	byte ptr cs:[c_Command_EoC],01h
		.break

	.endif

	mov	UCMO_ComStartFlag,0

	.endw

	ret
c_decode	endp
;---------------------------------------------------------------|
;		初期変換					|
;---------------------------------------------------------------|
;	処理							|
;	１．タイトル、作曲、タイムベースの表示			|
;	２．データ解析						|
;		(1) 使用パート数				|
;---------------------------------------------------------------|
.const
MML2MID_HED1	db	'8z	@0	/*Instrument of percussion 1z*/'		,0dh,0ah,24h
MML2MID_HED2	db	'9z	@48	/*Instrument of percussion 2z*/'		,0dh,0ah,24h
MML2MID_HED3	db	0dh,0ah
ifdef	FixedVoice	;----------------
		;音色番号固定
		DB	'#include "define.mml"',0dh,0ah
else	;--------------------------------
		;音色番号不定
		DB	'#include "init.mml"',0dh,0ah
endif	;--------------------------------
		db	0dh,0ah,24h		;改行は、ff8mmlでも出力する。

ifdef	lastAkao	;------------------------
MML2MID_HED4	db	'/* Instrument Set ID = ',24h
MML2MID_HED5	db	' */',0dh,0ah,24h
endif	;--------------------------------

.code
UC_START	proc	near
	;---------------------------------------
	;◆ヘッダー出力
	lea	DX,[MML2MID_HED]	;これは define部
	MOV	AH,09H			;
	INT	21H			;

	mov	dl,24h			;$の表示
	mov	ah,02h			;
	int	21h			;
	lea	DX,[MML2MID_HED1]	;
	MOV	AH,09H			;
	INT	21H			;

	mov	dl,24h			;$の表示
	mov	ah,02h			;
	int	21h			;
	lea	DX,[MML2MID_HED2]	;
	MOV	AH,09H			;
	INT	21H			;

	lea	DX,[MML2MID_HED3]	;
	MOV	AH,09H			;
	INT	21H			;

ifdef	lastAkao	;------------------------
	lea	DX,[MML2MID_HED4]	;
	MOV	AH,09H			;
	INT	21H			;

	mov	ax,es:[0014h]
	call	hex2asc16
	MOV	AH,09H			;
	INT	21H			;

	lea	DX,[MML2MID_HED5]	;
	MOV	AH,09H			;
	INT	21H			;
endif	;--------------------------------

	;---------------------------------------
	;◆チャンネル数のチェック
ifdef	SPC	;------------------------
	MOV	CS:[UC_PART],8		;パート数８
endif	;---------------------------------------

ifdef	PS1	;------------------------
;	dword ptr es:[PARTF_ADDRESS"]について、
;	ビットが"Hi"の数をチェックする。＝チャンネル数。
;	※注意※
;	ビットが飛び飛びになっていても、
;	チャンネルデータのヘッダーは飛び飛びにならない。

	push	cx

	mov	cl,0			;Counter
	mov	ch,32			;パート数最大

	mov	dx,0000h		;
	mov	ax,0001h		;dx:axで、32bit幅とする。

	.repeat
		test	word ptr es:[PARTF_ADDRESS+0],ax
		jnz	UC_START_1	;
		test	word ptr es:[PARTF_ADDRESS+2],dx
		jnz	UC_START_1	;
		jmp	UC_START_2	
UC_START_1:
		inc	cl
UC_START_2:
		shl	ax,1		;
		rcl	dx,1		;

		dec	ch		;
	.until	(zero?)

	MOV	CS:[UC_PART],cl		;

	pop	cx
endif	;---------------------------------------

	;---------------------------------------
	;◆アドレス補正値の計算
ifdef	SPC	;------------------------
 ifdef	MUSIC_DATA	;-----------------------
  ifdef	MUSIC_START	;----------------
	MOV	AX,ES:[MUSIC_START]	;ch0演奏アドレス(ROM内)
  else	;--------------------------------
	MOV	AX,ES:[MUSIC_ADDRESS]	;ch0演奏アドレス(ROM内)
  endif	;--------------------------------
	SUB	AX,MUSIC_DATA		;データアドレス(SPCの)
 else	;---------------------------------------
	mov	ax,-0100h		;SPCとSPC700とでは、0100h アドレスが違う。
 endif	;---------------------------------------
	MOV	CS:[UC_ADDER],AX	;SPCアドレスにする為の補正値
endif	;---------------------------------------

	RET				;
UC_START	endp
;---------------------------------------------------------------|
;		後期変換					|
;---------------------------------------------------------------|
;	処理							|
;	１．ＭＭＬ出力部でえた音色のマクロ定義文出力		|
;---------------------------------------------------------------|
.const
ifdef	PS1	;------------------------	;Multi Sampling Instrument
	;拡張音色(PS1)
UC_END_VOICE_ADD	DW	OFFSET UCE_VOICE_0A	
			DW	OFFSET UCE_VOICE_1A	
			DW	OFFSET UCE_VOICE_2A	
			DW	OFFSET UCE_VOICE_3A	
			DW	OFFSET UCE_VOICE_4A	
			DW	OFFSET UCE_VOICE_5A	
			DW	OFFSET UCE_VOICE_6A	
			DW	OFFSET UCE_VOICE_7A	
			DW	OFFSET UCE_VOICE_0B	
			DW	OFFSET UCE_VOICE_1B	
			DW	OFFSET UCE_VOICE_2B	
			DW	OFFSET UCE_VOICE_3B	
			DW	OFFSET UCE_VOICE_4B	
			DW	OFFSET UCE_VOICE_5B	
			DW	OFFSET UCE_VOICE_6B	
			DW	OFFSET UCE_VOICE_7B	
endif	;--------------------------------

ifndef	FixedVoice	;------------------------	;Normal Instrument
	;音色番号不定
 ifndef	PS1	;------------------------
UC_END_VOICE_ADD	DW	OFFSET UCE_VOICE_0C	;(FF7以外で要る)
 else		;------------------------
			DW	OFFSET UCE_VOICE_0C	;(FF7以外で要る)
 endif		;------------------------
		DW	OFFSET UCE_VOICE_1C	
		DW	OFFSET UCE_VOICE_2C	
		DW	OFFSET UCE_VOICE_3C	
		DW	OFFSET UCE_VOICE_4C	
		DW	OFFSET UCE_VOICE_5C	
		DW	OFFSET UCE_VOICE_6C	
		DW	OFFSET UCE_VOICE_7C	
		DW	OFFSET UCE_VOICE_0D	
		DW	OFFSET UCE_VOICE_1D	
		DW	OFFSET UCE_VOICE_2D	
		DW	OFFSET UCE_VOICE_3D	
		DW	OFFSET UCE_VOICE_4D	
		DW	OFFSET UCE_VOICE_5D	
		DW	OFFSET UCE_VOICE_6D	
		DW	OFFSET UCE_VOICE_7D	
		DW	OFFSET UCE_VOICE_0E	
		DW	OFFSET UCE_VOICE_1E	
		DW	OFFSET UCE_VOICE_2E	
		DW	OFFSET UCE_VOICE_3E	
		DW	OFFSET UCE_VOICE_4E	
		DW	OFFSET UCE_VOICE_5E	
		DW	OFFSET UCE_VOICE_6E	
		DW	OFFSET UCE_VOICE_7E	
		DW	OFFSET UCE_VOICE_0F	
		DW	OFFSET UCE_VOICE_1F	
		DW	OFFSET UCE_VOICE_2F	
		DW	OFFSET UCE_VOICE_3F	
		DW	OFFSET UCE_VOICE_4F	
		DW	OFFSET UCE_VOICE_5F	
		DW	OFFSET UCE_VOICE_6F	
		DW	OFFSET UCE_VOICE_7F	
endif	;--------------------------------

ifdef	Rhythm12	;---------------	;Percussion
UC_Rhythm_Add	dw	offset UC_Rhythm_0x	
		dw	offset UC_Rhythm_1x	
		dw	offset UC_Rhythm_2x	
		dw	offset UC_Rhythm_3x	
		dw	offset UC_Rhythm_4x	
		dw	offset UC_Rhythm_5x	
		dw	offset UC_Rhythm_0y	
		dw	offset UC_Rhythm_1y	
		dw	offset UC_Rhythm_2y	
		dw	offset UC_Rhythm_3y	
		dw	offset UC_Rhythm_4y	
		dw	offset UC_Rhythm_5y	
endif	;--------------------------------

ifdef	PS1	;------------------------
	;拡張音色(PS1)
UCE_VOICE_0A	DB	'0a	',24h
UCE_VOICE_1A	DB	'1a	',24h
UCE_VOICE_2A	DB	'2a	',24h
UCE_VOICE_3A	DB	'3a	',24h
UCE_VOICE_4A	DB	'4a	',24h
UCE_VOICE_5A	DB	'5a	',24h
UCE_VOICE_6A	DB	'6a	',24h
UCE_VOICE_7A	DB	'7a	',24h
UCE_VOICE_0B	DB	'0b	',24h
UCE_VOICE_1B	DB	'1b	',24h
UCE_VOICE_2B	DB	'2b	',24h
UCE_VOICE_3B	DB	'3b	',24h
UCE_VOICE_4B	DB	'4b	',24h
UCE_VOICE_5B	DB	'5b	',24h
UCE_VOICE_6B	DB	'6b	',24h
UCE_VOICE_7B	DB	'7b	',24h
endif	;--------------------------------
ifndef	FixedVoice	;------------------------	FF7以外で要る
	;音色番号不定
UCE_VOICE_0C	DB	'0c	',24h
UCE_VOICE_1C	DB	'1c	',24h
UCE_VOICE_2C	DB	'2c	',24h
UCE_VOICE_3C	DB	'3c	',24h
UCE_VOICE_4C	DB	'4c	',24h
UCE_VOICE_5C	DB	'5c	',24h
UCE_VOICE_6C	DB	'6c	',24h
UCE_VOICE_7C	DB	'7c	',24h
UCE_VOICE_0D	DB	'0d	',24h
UCE_VOICE_1D	DB	'1d	',24h
UCE_VOICE_2D	DB	'2d	',24h
UCE_VOICE_3D	DB	'3d	',24h
UCE_VOICE_4D	DB	'4d	',24h
UCE_VOICE_5D	DB	'5d	',24h
UCE_VOICE_6D	DB	'6d	',24h
UCE_VOICE_7D	DB	'7d	',24h
UCE_VOICE_0E	DB	'0e	',24h
UCE_VOICE_1E	DB	'1e	',24h
UCE_VOICE_2E	DB	'2e	',24h
UCE_VOICE_3E	DB	'3e	',24h
UCE_VOICE_4E	DB	'4e	',24h
UCE_VOICE_5E	DB	'5e	',24h
UCE_VOICE_6E	DB	'6e	',24h
UCE_VOICE_7E	DB	'7e	',24h
UCE_VOICE_0F	DB	'0f	',24h
UCE_VOICE_1F	DB	'1f	',24h
UCE_VOICE_2F	DB	'2f	',24h
UCE_VOICE_3F	DB	'3f	',24h
UCE_VOICE_4F	DB	'4f	',24h
UCE_VOICE_5F	DB	'5f	',24h
UCE_VOICE_6F	DB	'6f	',24h
UCE_VOICE_7F	DB	'7f	',24h
endif	;--------------------------------
ifdef	Rhythm12	;---------------
UC_Rhythm_0x	db	'0x	',24h
UC_Rhythm_1x	db	'1x	',24h
UC_Rhythm_2x	db	'2x	',24h
UC_Rhythm_3x	db	'3x	',24h
UC_Rhythm_4x	db	'4x	',24h
UC_Rhythm_5x	db	'5x	',24h
UC_Rhythm_0y	db	'0y	',24h
UC_Rhythm_1y	db	'1y	',24h
UC_Rhythm_2y	db	'2y	',24h
UC_Rhythm_3y	db	'3y	',24h
UC_Rhythm_4y	db	'4y	',24h
UC_Rhythm_5y	db	'5y	',24h
endif	;--------------------------------



ifdef	PS1	;------------------------
	;拡張音色(PS1)
 ifdef	ff7	;------------------------
UCE_VOICE_Program	db	46	;harp
 else	;--------------------------------
UCE_VOICE_Program	db	48	;strings
 endif	;--------------------------------
		db	1
		db	2
		db	3
		db	4
		db	5
		db	6
		db	7
		db	8
		db	9
		db	10
		db	11
		db	12
		db	13
		db	14
		db	15
endif	;--------------------------------
ifdef	Rhythm12	;---------------
UCE_VOICE_Note	db	36	;B.Drum 1	;ロマサガ３設定暫定
		db	49	;Cymbal 1
		db	38	;S.Drum 1
		db	57	;Cymbal 2
		db	40	;S.Drum 2
		db	53	;Bell
		db	42	;H.H.Close
		db	42	;H.H.Close
		db	67	;Agogo 
		db	70	;Maracas 
		db	46	;H.H.Open
		db	35	;B.Drum 2

UCE_VOICE_M1		db	'1z	k127	v127	J',24h
endif	;-------------------------------

UCE_VOICE_M0		db	'0z	k127	v127	y100,2	y101,0	y6,64	H0,0	@',24h
UCE_VOICE_M0_VGM	db	'	k127	v127					@',24h
UCE_VOICE_cr	db	0dh,0ah,24h

.code
UC_Instrument	proc	near

	local	iMultiSample:BYTE

	mov	iMultiSample,0

;=======================================
;Multi Sampling Instrument
;=======================================
ifdef	PS1	;------------------------
	;拡張音色(PS1)
	XOR	CX,CX			;CL←0
	lea	SI,[UC_END_VOICE_ADD]
	lea	di,[UCE_VOICE_Program]
  ifdef	nlastAkao	;------------------------
	;拡張音色命令の引数がアドレス
	lea	BX,[UC_VoiceExWork]
  else	;--------------------------------
	;拡張音色命令の引数が音色番号
	MOV	BX,VOICE_ADDRESS	;従属音色情報アドレス
	MOV	DX,ES:[BX]		;
	.if	(dx==0000h)
		mov	cx,16
	.else
		add	bx,dx		;BX←従属音色情報先頭アドレス
	.endif
  endif	;--------------------------------

	.while	(cx<16)

  ifdef	nlastAkao	;------------------------
	;拡張音色命令の引数がアドレス
		mov	ax,cs:[bx]		;AL←音色登録情報
  else	;--------------------------------
	;拡張音色命令の引数が音色番号
		mov	ax,es:[bx]		;AL←音色登録情報
  endif	;--------------------------------
		.break	.if	(ax==0ffffh)

		mov	dl,'$'
		mov	ah,02h
		int	21h

		lodsw				;出力すべき文字列のアドレス
		mov	dx,ax			;
		MOV	AH,09H			;
		INT	21H			;出力

		.if	(cs:[D_Debug] & 02h)
		  lea	dx,[UCE_VOICE_M0_VGM]
		.else
		  mov	dl,'$'
		  mov	ah,02h
		  int	21h
		  lea	dx,[UCE_VOICE_M0]
		.endif
		mov	ah,09h
		int	21h

		.if	((cs:[D_Debug] & 02h) && (cx==0))
		  mov	ah,0
		.else
		  mov	ah,cs:[di]
		.endif
		call	hex2asc8
		mov	ah,09h
		int	21h

		lea	dx,[UCE_VOICE_cr]
		MOV	AH,09H			;
		INT	21H			;出力

		INC	BX			;
		INC	BX			;アドレスインクリメント
		INC	CX			;
		inc	di

		inc	iMultiSample
	.endw
endif	;-------------------------------



;=======================================
;Normal Instrument
;=======================================
ifndef	FixedVoice	;------------------------
	;音色番号は、曲毎に不定
	XOR	CX,CX			;CL←0
	lea	SI,[UC_END_VOICE_ADD]
  ifdef	PS1	;------------------------
	add	si,32			;PSは、従属音色の分、加算する
  endif	;--------------------------------
	lea	BX,[UC_VOICE]		;

	.while	(cx<64)

		mov	al,cs:[bx]		;AL←音色登録情報
		.break	.if	(al==0ffh)

		push	ax

		mov	dl,'$'
		mov	ah,02h
		int	21h
		lodsw				;出力すべき文字列のアドレス
		mov	dx,ax			;
		MOV	AH,09H			;
		INT	21H			;出力

		.if	(cs:[D_Debug] & 02h)
		  lea	dx,[UCE_VOICE_M0_VGM]
		.else
		  mov	dl,'$'
		  mov	ah,02h
		  int	21h
		  lea	dx,[UCE_VOICE_M0]
		.endif
		mov	ah,09h
		int	21h

		pop	ax

		.if	(cs:[D_Debug] & 02h)
		  add	al,iMultiSample
		  inc	al
		.endif
		mov	ah,al
		call	hex2asc8
		MOV	AH,09H			;
		INT	21H			;出力

		lea	dx,[UCE_VOICE_cr]
		MOV	AH,09H			;
		INT	21H			;出力

		INC	BX			;
		INC	CX			;

	.endw
endif	;-------------------------------
	lea	dx,[UCE_VOICE_cr]
	MOV	AH,09H			;
	INT	21H			;出力


;=======================================
;Percussion Instrument
;=======================================
ifdef	Rhythm12	;---------------
	mov	cx,12
	lea	bx,[UCE_VOICE_Note]
	lea	si,[UC_Rhythm_Add]
  ifdef	PS1	;-----------------------
	mov	di,cs:[UC_Rhythm_Address]
	cmp	di,0
	je	UC_Instrument_NoRhythm	;パーカッション無かったら吐かない
  endif	;-------------------------------

	.repeat
		mov	dl,'$'
		mov	ah,02h
		int	21h

		lodsw
		mov	dx,ax
		mov	ah,09h
		int	21h		;Macro Name

  ifdef	SPC	;-----------------------
		mov	dl,'$'
		mov	ah,02h
		int	21h

		lea	dx,[UCE_VOICE_M1]
		mov	ah,09h
		int	21h

		mov	ah,cs:[bx]
		call	hex2asc8
		mov	ah,09h
		int	21h
  endif	;-------------------------------
  ifdef	PS1	;-----------------------

		call	UC_Instrument_Phythm_PS1

  endif	;-------------------------------

		lea	dx,[UCE_VOICE_cr]
		MOV	AH,09H			;
		INT	21H			;出力

		inc	bx
	.untilcxz
UC_Instrument_NoRhythm:
endif	;-------------------------------


ifdef	PS1	;-----------------------
	;拡張音色(PS1)の情報を吐く
	call	UC_Instrument_PS1_multi
endif	;-------------------------------


	RET
UC_Instrument	endp
;---------------------------------------------------------------|
;		ＰＳ１	リズム定義出力				|
;---------------------------------------------------------------|
ifdef	Rhythm12	;---------------
  ifdef	PS1	;-----------------------

.const
UC_Instrument_Phythm_PS1_M1	db	"	/*J",24h
UC_Instrument_Phythm_PS1_M2	db	"	/*",24h
UC_Instrument_Phythm_PS1_ME	db	"*/",24h
UC_Instrument_Phythm_PS1_E	db	"	E",24h
UC_Instrument_Phythm_PS1_P	db	"	p",24h

.code
UC_Instrument_Phythm_PS1	proc	near	uses bx

	;[0]: Voice
	mov	dl,'$'
	mov	ah,02h
	int	21h

	xor	bx,bx				;
	mov	bl,es:[di]			;
	inc	di				;
	lea	dx,[UC_VOICE_NAME + bx]
;	mov	dx,OFFSET UC_VOICE_NAME		;
;	add	dx,bx				;
	add	dx,bx				;
	add	dx,bx				;
	mov	ah,09h
	int	21h

	;[1]:Note Number
	lea	dx,[UC_Instrument_Phythm_PS1_M1]
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h
	lea	dx,[UC_Instrument_Phythm_PS1_ME]
	mov	ah,09h
	int	21h

	;[2]:unknown
	lea	dx,[UC_Instrument_Phythm_PS1_M2]
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h
	lea	dx,[UC_Instrument_Phythm_PS1_ME]
	mov	ah,09h
	int	21h

	;[3]:Expression
	lea	dx,[UC_Instrument_Phythm_PS1_E]
	mov	ah,09h
	int	21h

;	xor	ax,ax				;
;	mov	al,es:[di]
;	inc	di
;	MOV	BX,OFFSET UC_Volume_TABLE	;
;	ADD	BX,AX				;
;	MOV	AH,CS:[BX]			;
	xor	bx,bx
	mov	bl,es:[di]
	inc	di
	mov	ah,byte ptr cs:[UC_Volume_TABLE + bx]
	call	hex2asc8
	mov	ah,09h
	int	21h

	;[4]:Panpot
	lea	dx,[UC_Instrument_Phythm_PS1_P]
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_Instrument_Phythm_PS1	endp
  endif	;-------------------------------
endif	;-------------------------------
;---------------------------------------------------------------|
;	ＰＳ１	AKAO Multi sampling Instrument 出力		|
;---------------------------------------------------------------|
ifdef	PS1	;-----------------------
.const
UC_Instrument_PS1_M00	db	3bh,"Multi Sampling Instrument No.=",24h
UC_Instrument_PS1_M01	db	3bh,"	Sample No.=",24h
UC_Instrument_PS1_M02	db	3bh,"	Noto No.=",24h
UC_Instrument_PS1_M03	db	"〜",24h
UC_Instrument_PS1_M08	db	3bh,"	Volume =",24h

.code
UC_Instrument_PS1_multi	proc	near	uses	bp ax bx cx dx si

	xor	cx,cx			;CL←0
ifdef	nlastAkao	;------------------------
	;引数がアドレス
	lea	si,[UC_VoiceExWork]
else	;--------------------------------
	;引数が、番号
	MOV	bx,ES:[VOICE_ADDRESS]	;従属音色情報アドレス
	.if	(bx==0000h)
		mov	cx,16
	.else
		lea	si,[bx + VOICE_ADDRESS]	;si←従属音色情報先頭アドレス
	.endif
endif	;--------------------------------
	lea	bp,[si]			;

	.while	(cx<16)
ifdef	nlastAkao	;------------------------
	;引数がアドレス
		lodsw	cs:[si]			;ax←音色登録情報
		mov	bx,ax			;bx ← 音色情報アドレス
else	;--------------------------------
	;引数が、番号
		lodsw	es:[si]			;ax←音色登録情報
		lea	bx,[bp + 20h]
		add	bx,ax			;bx ← 音色情報アドレス
endif	;--------------------------------
		.break	.if	(ax==0ffffh)

		;Message
		lea	dx,[UC_Instrument_PS1_M00]
		mov	ah,09h			;
		int	21h			;

		mov	ax,cx			;
		call	hex2asc16		;
		mov	ah,09h			;
		int	21h			;

		lea	dx,[UCE_VOICE_cr]	;
		mov	ah,09h			;
		int	21h			;

		;各サンプリング情報
ifdef	nlastAkao	;-----------------------
	;初期・中期の判定
		.while	(word ptr es:[bx+0]!=8080h)
else		;-------------------------------
	;後期の判定
		.while	((word ptr es:[bx+0]!=0) || (word ptr es:[bx+2]!=0) || (word ptr es:[bx+4]!=0) || (word ptr es:[bx+6]!=0))
endif		;-------------------------------
			;Voice No.
			lea	dx,[UC_Instrument_PS1_M01]
			mov	ah,09h			;
			int	21h			;
			mov	ah,es:[bx+0]
			call	hex2asc8
			mov	ah,09h
			int	21h
			
			lea	dx,[UC_Instrument_PS1_M02]
			mov	ah,09h			;
			int	21h			;
			mov	ah,es:[bx+1]
			call	hex2asc8
			mov	ah,09h
			int	21h

			lea	dx,[UC_Instrument_PS1_M03]
			mov	ah,09h			;
			int	21h			;
			mov	ah,es:[bx+2]
			call	hex2asc8
			mov	ah,09h
			int	21h

			lea	dx,[UC_Instrument_PS1_M08]
			mov	ah,09h			;
			int	21h			;
			mov	ah,es:[bx+7]
			call	hex2asc8
			mov	ah,09h
			int	21h

			lea	dx,[UCE_VOICE_cr]	;
			mov	ah,09h			;
			int	21h			;

			add	bx,8
		.endw
		inc	cx
	.endw



	ret
UC_Instrument_PS1_multi	endp
endif	;-------------------------------
;---------------------------------------------------------------|
;		ＭＭＬ出力部					|
;---------------------------------------------------------------|
;	処理							|
;	１．ＭＭＬ出力						|
;	２．使用されている音色番号の記憶			|
;---------------------------------------------------------------|

ifdef	SPC	;------------------------
.const
UC_PART_ASC	DB	'A	$',0	;1ch
		DB	'B	$',0	;2ch
		DB	'C	$',0	;3ch
		DB	'D	$',0	;4ch
		DB	'E	$',0	;5ch
		DB	'F	$',0	;6ch
		DB	'G	$',0	;7ch
		DB	'H	$',0	;8ch
.data?
UC_ADDER	DW	?			;先頭アドレス差分
endif	;-------------------------------

ifdef	PS1	;------------------------
.const
UC_PART_ASC	DB	'0A	$'	;1ch
		DB	'1A	$'	;2ch
		DB	'2A	$'	;3ch
		DB	'3A	$'	;4ch
		DB	'0B	$'	;5ch
		DB	'1B	$'	;6ch
		DB	'2B	$'	;7ch
		DB	'3B	$'	;8ch
		DB	'0C	$'	;9ch
		DB	'1C	$'	;10ch
		DB	'2C	$'	;11ch
		DB	'3C	$'	;12ch
		DB	'0D	$'	;13ch
		DB	'1D	$'	;14ch
		DB	'2D	$'	;15ch
		DB	'3D	$'	;16ch
		DB	'0E	$'	;1ch
		DB	'1E	$'	;2ch
		DB	'2E	$'	;3ch
		DB	'3E	$'	;4ch
		DB	'0F	$'	;5ch
		DB	'1F	$'	;6ch
		DB	'2F	$'	;7ch
		DB	'3F	$'	;8ch
		DB	'0G	$'	;9ch
		DB	'1G	$'	;10ch
		DB	'2G	$'	;11ch
		DB	'3G	$'	;12ch
		DB	'0H	$'	;13ch
		DB	'1H	$'	;14ch
		DB	'2H	$'	;15ch
		DB	'3H	$'	;16ch
endif	;-------------------------------

.const
UC_CR		DB	0Dh,0Ah,24h
UCMO_LOOP_OUTPUT	DB	'/*L1*/[$'		;
UCMO_LOOP_OUTPUT2	DB	'/*L2*/[$'		;

.data?
c_Command_EoC	db	?		;End of Channel
UC_PART		DB	?		;パート数

.code
UC_MML_OUTPUT	proc	near	uses	ax bx cx dx

	local	stAddr:word
	local	endAddr:word

ifdef	MUSIC_EOF	;----------------
	mov	ax,es:[MUSIC_EOF]	;
  ifdef	SPC	;------------------------
	sub	ax,cs:[UC_ADDER]	;
  endif	;--------------------------------
	mov	endAddr,ax		;終了アドレスの設定
endif	;--------------------------------

	MOV	CL,CS:[UC_PART]		;CL←使用パート数
	MOV	CH,0			;CH←現在のパート

	;チャンネル毎のdo〜while()文
	.while	(cl!=ch)

	push	cx			;

;	XOR	DX,DX			;
;	MOV	DL,CH			;
;	SHL	DX,1			;
;	PUSH	DX			;アドレス計算用
;	SHL	DX,1			;
;	ADD	DX,OFFSET UC_PART_ASC	;AX←UC_PART_ASC + CH * 4
	xor	bx,bx
	mov	bl,ch
	shl	bx,1
	push	bx
	shl	bx,1
	lea	dx,[UC_PART_ASC + bx]
	MOV	AH,09H			;
	INT	21H			;パート表示

;	POP	AX			;AX←パート番号＊２
;	ADD	AX,MUSIC_ADDRESS	;AX←パート情報＋AX
;	MOV	BX,AX			;
;	mov	bx,es:[bx]		;
	pop	bx			;
	lea	bx,es:[MUSIC_ADDRESS + bx]
	mov	ax,es:[bx]		;ax←アドレス

ifdef	SPC	;------------------------
ifndef	MUSIC_EOF	;----------------
	.if	(ax==0)
	   jmp	c_Command_Ch_END	;ポインタチェック
	.endif
endif	;--------------------------------
endif	;--------------------------------

ifdef	SPC	;------------------------
	mov	bx,ax
	sub	bx,cs:[UC_ADDER]	;
endif	;--------------------------------
ifdef	PS1	;------------------------
;	add	bx,MUSIC_ADDRESSa	;
;	ADD	BX,AX			;BX←演奏アドレス
	lea	bx,[MUSIC_ADDRESSa + bx]
	add	bx,ax
endif	;--------------------------------

	mov	stAddr,bx		;先頭アドレス

ifdef	MUSIC_EOF	;----------------
	.if	(bx>=endAddr)
		jmp	c_Command_Ch_END	;ポインタチェック
	.endif
endif	;--------------------------------

	CALL	UCMO_LOOP_SEARCH	;無限ループ解析

	call	UC_INIT			;変数初期化

;---------------------------------------

	mov	byte ptr cs:[c_Command_EoC],00h

	;"End of Channel"が来るまでのwhile()文	
	.while	(byte ptr cs:[c_Command_EoC]==00h)

ifdef	MUSIC_EOF	;----------------
		.break	.if	(bx>=endAddr)
endif	;--------------------------------

		;ループアドレスのチェック
		push	es
		mov	ax,bx			;ax←アドレス
		mov	cx,UCMOLS_LOOP_PTY	;回数セット
		lea	di,[UCMOLS_LOOP_ADDRESS]
		push	cs			
		pop	es			;es:di ← アドレス
		.repeat
			scasw
			.if	(ZERO?)
				push	ax
				lea	DX,[UCMO_LOOP_OUTPUT]
				MOV	AH,09H			;
				INT	21H			;
				pop	ax
			.endif
		.untilcxz
		pop	es

		call	c_decode

	.endw

;---------------------------------------
;チャンネルの終了

c_Command_Ch_END:

	lea 	DX,[UC_CR]		;
	MOV	AH,09H	 		;
	INT	21H			;改行
	lea 	DX,[UC_CR]		;
	MOV	AH,09H			;
	INT	21H			;改行

	POP	CX			;
	INC	CH			;パート番号インクリメント

	.endw

;---------------------------------------
c_Command_END:				;
	RET				;RETURN
UC_MML_OUTPUT	endp
;---------------------------------------------------------------|
;		逆ＭＭＬ部メインルーチン			|
;---------------------------------------------------------------|
UN_MML_COMPAILE	proc	near	uses es

	CALL	UC_START	;初期設定
	CALL	UC_MML_OUTPUT	;ＭＭＬ出力部
	CALL	UC_Instrument	;後期設定

	RET			;RETURN
UN_MML_COMPAILE	endp
