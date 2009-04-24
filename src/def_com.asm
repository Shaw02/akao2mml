;===============================================================
;	初期化
;===============================================================
UC_INIT		proc	near	uses ax

	mov	ax,0

ifdef	SPC	;------------------------
	mov	word ptr cs:[UC_Detune_D],8192		;パイプライン対策
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	byte ptr cs:[UC_Detune_D],64		;
endif	;-------------------------------

	mov	byte ptr cs:[UC_Step_work],al
	mov	byte ptr cs:[UC_DATA_E],al
	mov	byte ptr cs:[UC_DATA_P],al

ifdef	PS1	;------------------------
	mov	byte ptr cs:[UC_LFO_PitchBend_delay],al
	mov	byte ptr cs:[UC_LFO_PitchBend_range],al
	mov	byte ptr cs:[UC_LFO_PitchBend_count],al
	mov	byte ptr cs:[UC_LFO_PitchBend_depth],al

	mov	byte ptr cs:[UC_LFO_Expression_delay],al
	mov	byte ptr cs:[UC_LFO_Expression_range],al
	mov	byte ptr cs:[UC_LFO_Expression_count],al
	mov	byte ptr cs:[UC_LFO_Expression_depth],al

	mov	byte ptr cs:[UC_LFO_Panpot_delay],al
	mov	byte ptr cs:[UC_LFO_Panpot_range],al
	mov	byte ptr cs:[UC_LFO_Panpot_count],al
	mov	byte ptr cs:[UC_LFO_Panpot_depth],al
endif	;-------------------------------

	mov	byte ptr cs:[UC_portamento_D],al
	mov	word ptr cs:[UC_LoopCountData],ax
	mov	word ptr cs:[UC_Tempo_Work],ax

ifdef	Rhythm12	;---------------
	mov	byte ptr cs:[UC_Rhythm_flag],al
endif	;-------------------------------

	ret
UC_INIT		endp
;****************************************************************
;*		音色						*
;****************************************************************
;
;		音色マクロ変換
;
ifdef	ff7	;------------------------
UC_VoiceExWork	dw	16	DUP	(0FFFFh)
endif	;--------------------------------

ifndef	ff7	;------------------------
UC_VOICE	DB	64	DUP	(0FFh)	
endif	;--------------------------------

UC_VoiceEx_Name:				;音色マクロ名
		DB	'0a$','1a$','2a$','3a$','4a$','5a$','6a$','7a$'
		DB	'0b$','1b$','2b$','3b$','4b$','5b$','6b$','7b$'

UC_VOICE_NAME:					;音色マクロ名
ifdef	ff7	;------------------------
		DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$','8c$','9c$'
		DB	'0d$','1d$','2d$','3d$','4d$','5d$','6d$','7d$','8d$','9d$'
		DB	'0e$','1e$','2e$','3e$','4e$','5e$','6e$','7e$','8e$','9e$'
		DB	'0f$','1f$','2f$','3f$','4f$','5f$','6f$','7f$','8f$','9f$'
		DB	'0g$','1g$','2g$','3g$','4g$','5g$','6g$','7g$','8g$','9g$'
		DB	'0h$','1h$','2h$','3h$','4h$','5h$','6h$','7h$','8h$','9h$'
		DB	'0i$','1i$','2i$','3i$','4i$','5i$','6i$','7i$','8i$','9i$'
		DB	'0j$','1j$','2j$','3j$','4j$','5j$','6j$','7j$','8j$','9j$'
		DB	'0k$','1k$','2k$','3k$','4k$','5k$','6k$','7k$','8k$','9k$'
		DB	'0l$','1l$','2l$','3l$','4l$','5l$','6l$','7l$','8l$','9l$'
		DB	'0m$','1m$','2m$','3m$','4m$','5m$','6m$','7m$','8m$','9m$'
		DB	'0n$','1n$','2n$','3n$','4n$','5n$','6n$','7n$','8n$','9n$'
		DB	'0o$','1o$','2o$','3o$','4o$','5o$','6o$','7o$','8o$','9o$'
else	;--------------------------------
		DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$'
		DB	'0d$','1d$','2d$','3d$','4d$','5d$','6d$','7d$'
		DB	'0e$','1e$','2e$','3e$','4e$','5e$','6e$','7e$'
		DB	'0f$','1f$','2f$','3f$','4f$','5f$','6f$','7f$'
		DB	'0g$','1g$','2g$','3g$','4g$','5g$','6g$','7g$'
		DB	'0h$','1h$','2h$','3h$','4h$','5h$','6h$','7h$'
		DB	'0i$','1i$','2i$','3i$','4i$','5i$','6i$','7i$'
		DB	'0j$','1j$','2j$','3j$','4j$','5j$','6j$','7j$'
endif	;--------------------------------

;===============================================================
;		音色
;===============================================================
UC_VOICE_OUTPUT	proc	near	uses	cx dx
	mov	ax,0				;
	MOV	AL,ES:[BX]			;ax←データ読み込み
	INC	BX				;
	push	bx

	MOV	DX,OFFSET UC_VOICE_NAME		;
ifdef	ff7	;------------------------
	add	dx,ax				;
	add	dx,ax				;
	add	dx,ax				;DX←Address + ax *3
else	;--------------------------------
	xor	bx,bx				;BX←0
	.repeat
	   mov	ah,cs:[UC_VOICE + BX]		;使用登録済み音色読み込み
	   .if	(ah==0ffh)
		MOV	CS:[UC_VOICE + BX],AL	;登録
		.break
	   .elseif	(ah==al)
		.break
	   .endif

	   inc	bx
	.until	0

	add	dx,bx				;
	add	dx,bx				;
	add	dx,bx				;DX←Address + BX *3
endif	;--------------------------------

	MOV	AH,09H				;
	INT	21H				;

	pop	bx
	RET					;
UC_VOICE_OUTPUT	endp
;===============================================================
;	0xFC	拡張音色
;===============================================================
UC_VoiceEx	proc	near	uses dx

	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;

ifdef	ff7	;------------------------
	mov	ax,es:[bx]			;ax←データ読み込み
	inc	bx
	inc	bx
	add	ax,bx
	mov	dx,ax				;cx←音色のアドレス

	PUSH	BX				;
	xor	bx,bx				;BX←0
	.repeat
	   mov	ax,cs:[UC_VoiceExWork + BX]		;使用登録済み音色読み込み
	   .if	(ax==0ffffh)
		MOV	CS:[UC_VoiceExWork + BX],dx	;登録
		.break
	   .elseif	(ax==dx)
		.break
	   .endif

	   inc	bx
	   inc	bx
	.until	0
	mov	ax,bx
	shr	ax,1
	POP	BX
endif	;--------------------------------
ifdef	ff8	;------------------------
	XOR	AX,AX
	MOV	AL,ES:[BX]
	INC	BX
endif	;--------------------------------

	MOV	DX,OFFSET UC_VoiceEx_Name	;
	ADD	dx,ax				;
	ADD	dx,ax				;
	ADD	dx,ax				;
	MOV	AH,09H				;マクロ番号表示
	INT	21H				;

	ret					;
UC_VoiceEx	endp
;****************************************************************
ifdef	Rhythm12	;---------------
UC_Rhythm_flag	db	0
;===============================================================
;		リズムon
;===============================================================
UC_Rhythm_on	proc	near
	mov	byte ptr cs:[UC_Rhythm_flag],1
	ret
UC_Rhythm_on	endp
;===============================================================
;		リズムoff
;===============================================================
UC_Rhythm_off	proc	near
	mov	byte ptr cs:[UC_Rhythm_flag],0
	ret
UC_Rhythm_off	endp
endif	;-------------------------------
;===============================================================
;	0xEC	パーカッションon
;===============================================================
UC_Perc_On	db	'1z$'

UC_PercussionOn		proc	near

	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	DX,OFFSET UC_Perc_On
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_PercussionOn		endp
;===============================================================
;	0xED	パーカッションoff
;===============================================================
UC_Perc_Off	db	'0z$'

UC_PercussionOff	proc	near
	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	DX,OFFSET UC_Perc_Off
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_PercussionOff	endp
;****************************************************************
;*		音程						*
;****************************************************************
;===============================================================
;		オクターブ
;===============================================================
UC_Octave	proc	near
	MOV	Ah,ES:[BX]			;
	inc	bx				;
	dec	ah				;
	call	hex2asc8			;
	mov	ah,9				;
	int	21h				;
	RET					;
UC_Octave	endp
;===============================================================
;		ピッチベンド
;===============================================================
UC_Detune_D	dw	?
UC_Detune	proc	near	uses dx
	xor	ax,ax				;
	mov	al,es:[bx]			;
	inc	bx				;
ifdef	SPC	;------------------------
	mov	ah,4				;多分、このくらい？
	imul	ah				;
	add	ax,8192				;
endif	;-------------------------------
ifdef	PS1	;------------------------
	add	ax,64				;
endif	;-------------------------------
	mov	word ptr cs:[UC_Detune_D],ax	;
	CALL	HEX2ASC16			;出力

	MOV	AH,09H				;
	INT	21H				;
	ret					;
UC_Detune	endp
;===============================================================
;		ポルタメント
;===============================================================
UC_portamento_D	db	0			;保存する
UC_portamento	proc	near	uses	cx dx
	mov	al,byte ptr cs:[UC_portamento_D]
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;初期変位出力

	MOV	DL,','				;','の出力
	MOV	AH,02H				;
	INT	21H				;

	MOV	DL,'%'				;'%'の出力
	MOV	AH,02H				;
	INT	21H				;

;	xor	ax,ax
	mov	ah,es:[bx]
	inc	bx
	.if	(ah==0)
	inc	ah
	.endif
	call	hex2asc8			;
	mov	ah,09h				;
	int	21h				;ステップの出力

	MOV	DL,','				;','の出力
	MOV	AH,02H				;
	INT	21H				;

	MOV	Al,ES:[BX]			;
	inc	bx				;
	add	byte ptr cs:[UC_portamento_D],al
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;ステップの出力

	ret
UC_portamento	endp
;===============================================================
;		ポルタメント	for FF4
;===============================================================
ifdef	ff4	;-----------------------
UC_1ShotLFO_Pitch	proc	near
	
	xor	ax,ax
	mov	al,es:[bx]
	inc	bx
	shl	ax,1
	call	hex2asc16
	mov	ah,09h
	int	21h			;Delay

	mov	dl,','
	mov	ah,02h
	int	21h

	mov	dl,'0'
	mov	ah,02h
	int	21h

	mov	dl,','
	mov	ah,02h
	int	21h

	mov	dl,'%'
	mov	ah,02h
	int	21h

	xor	ax,ax
	mov	al,es:[bx]
	inc	bx
	shl	ax,1
	call	hex2asc16
	mov	ah,09h
	int	21h			;Length

	mov	dl,','
	mov	ah,02h
	int	21h

	mov	ah,8			;
	MOV	al,ES:[BX]		;
	inc	bx			;
	imul	ah			;
	call	fh2a16			;
	mov	ah,09h			;
	int	21h			;Depth

	ret
UC_1ShotLFO_Pitch	endp
endif	;-------------------------------
;****************************************************************
;*		音量						*
;****************************************************************







		;	to	do







;****************************************************************
;*		その他						*
;****************************************************************
;===============================================================
;		リバーブ
;===============================================================
UC_UC_Reverb_M1	db	'/*Reverb($'
UC_UC_Reverb_M2	db	')*/$'

UC_Reverb		proc	near
	MOV	DX,OFFSET UC_UC_Reverb_M1
	MOV	AH,09H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX		;
	MOV	AL,ES:[BX]	;データ読み込み
	inc	bx		;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
endif	;-------------------------------
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_UC_Reverb_M2
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_Reverb		endp
;===============================================================
;		相対リバーブ
;===============================================================
UC_UC_Reverb_M8	db	'/*Reverb($'
UC_UC_Reverb_M9	db	')*/$'

UC_RelativeReverb	proc	near
	MOV	DX,OFFSET UC_UC_Reverb_M8
	MOV	AH,09H		;
	INT	21H		;

ifdef	Change_tLength	;---------------
	mov	ax,es:[bx]
	add	bx,2
else	;-------------------------------
	xor	ax,ax
	mov	al,es:[bx]
	inc	bx		;
endif	;-------------------------------
	dec	ax		;
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX		;
	MOV	AL,ES:[BX]	;データ読み込み
	inc	bx		;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
endif	;-------------------------------
	CALL	FH2A16		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_UC_Reverb_M9
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_RelativeReverb	endp
;****************************************************************
;*		メタ・イベント					*
;****************************************************************
;===============================================================
;		テンポ	for	FF4
;===============================================================
ifdef	ff4	;-----------------------
UC_TempoEx	proc	near

	push	bx
ifdef	Change_tLength	;---------------
	mov	ax,es:[bx]
	add	bx,2
else	;-------------------------------
	xor	ax,ax
	mov	al,es:[bx]
	inc	bx
endif	;-------------------------------

	.if	(ax==0)
		pop	ax		;Dummy
		call	UC_Tempo
	.else
		pop	bx
		call	UC_RelativeTempo
	.endif

	ret
UC_TempoEx	endp
endif	;-------------------------------
;===============================================================
;		テンポ
;===============================================================
UC_RTempo_M	db	't$'

UC_Tempo_Work	dw	0

UC_Tempo	proc	near	uses dx cx
	MOV	DX,OFFSET UC_RTempo_M
	MOV	AH,09H			;
	INT	21H			;

ifdef	SPC	;------------------------
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み
	inc	bx			;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]		;
	inc	bx			;
	inc	bx			;
endif	;-------------------------------

ifdef	TempoMul	;---------------
	mov	dx,TempoMul
	mul	dx
endif	;-------------------------------
ifdef	TempoDiv	;---------------
	mov	cx,TempoDiv
	div	cx
endif	;-------------------------------
	mov	word ptr cs:[UC_Tempo_Work],ax
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	RET
UC_Tempo	endp
;===============================================================
;		相対テンポ
;===============================================================
UC_RelativeTempo_M:
	db	'UT1,0,%$'
UC_RelativeTempo	proc	near	uses dx cx

	MOV	DX,OFFSET UC_RTempo_M
	MOV	AH,09H		;
	INT	21H		;

	mov	ax,word ptr cs:[UC_Tempo_Work]
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_RelativeTempo_M
	MOV	AH,09H		;
	INT	21H		;

ifdef	Change_tLength	;---------------
	mov	ax,es:[bx]
	add	bx,2
else	;-------------------------------
	xor	ax,ax
	mov	al,es:[bx]
	inc	bx
endif	;-------------------------------
	dec	ax		;
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み
	inc	bx			;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]		;
	inc	bx			;
	inc	bx			;
endif	;-------------------------------

ifdef	TempoMul	;---------------
	mov	dx,TempoMul
	mul	dx
endif	;-------------------------------
ifdef	TempoDiv	;---------------
	mov	cx,TempoDiv
	DIV	CX		;ax←Tempo × 11/10
endif	;-------------------------------
	push	ax
	sub	ax,word ptr cs:[UC_Tempo_Work]
	CALL	FH2A16		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示
	pop	ax

	mov	word ptr cs:[UC_Tempo_Work],ax

	ret
UC_RelativeTempo	endp
;===============================================================
;	0xFD	拍子
;===============================================================
UC_Beat_M	db	'BT$'
UC_Beat			proc	near

	mov	dx,offset UC_Beat_M
	mov	ah,09h
	int	21h

	mov	al,es:[bx]	;
	inc	bx		;
	mov	ah,es:[bx]	;
	inc	bx		;

	cmp	al,0		;
	jnz	UC_Beat_1	;
	mov	al,48		;
UC_Beat_1:			;
	cmp	ah,0		;0除算エラー防止
	jnz	UC_Beat_2	;
	mov	ah,4		;
UC_Beat_2:			;

	push	ax

	call	hex2asc8
	mov	ah,09h
	int	21h

	mov	dl,','
	mov	ah,02h
	int	21h

	pop	ax

	mov	dl,al		;dl←al（times）
	mov	ax,192		;（timebase × 4）
	div	dl		;al←192 ÷ dl（times）
	mov	ah,al		;
	call	hex2asc8	;
	mov	ah,09h		;
	int	21h		;

	ret
UC_Beat			endp
;===============================================================
;	0xFE	小節（リハーサル）番号
;===============================================================
UC_Measures_M	db	'WC$'
UC_Measures		proc	near

	mov	dx,offset UC_Measures_M
	mov	ah,09h
	int	21h

	mov	dl,'"'
	mov	ah,02h
	int	21h

	mov	ax,es:[bx]
	inc	bx
	inc	bx

	call	hex2asc16
	mov	ah,09h
	int	21h

	mov	dl,'"'
	mov	ah,02h
	int	21h

	ret
UC_Measures		endp
;****************************************************************
;*		シーケンス					*
;****************************************************************
;===============================================================
;	0xA2	次の音符・休符の音長
;===============================================================
UC_Step_work	db	0			;
UC_Step		proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	inc	bx				;
	mov	byte ptr cs:[UC_Step_work],ah	;保存
	RET					;
UC_Step		endp

;===============================================================
;		LOOP	処理用の変数	（まずは、32回のネストに対応）
;			※シミュレートでも、この変数を使います。
;===============================================================
UC_LoopCountData	dw	0
UC_Loop_count		db	32	dup(0)
UC_Loop_counter		db	32	dup(0)
UC_Loop_addr		dw	32	dup(0)

ifdef	SPC	;------------------------
;---------------------------------------------------------------
Loop_Start	proc	near
	.if	(cs:[D_Debug]&001h)
		call	Loop_StartEx
	.else
		call	LOOP_COUNT_PUSH
	.endif
	ret
Loop_Start	endp
;---------------------------------------------------------------
Loop_End	proc	near
	.if	(cs:[D_Debug]&001h)
		call	Loop_EndEx
	.else
		call	LOOP_COUNT_POP
	.endif
	ret
Loop_End	endp
;---------------------------------------------------------------
Loop_Exit	proc	near
	.if	(cs:[D_Debug]&001h)
		call	Loop_ExitEx
	.else
		call	UC_ExitLoop
	.endif
	ret
Loop_Exit	endp
;===============================================================
;		LOOP	開始点	（シミュレート用）
;===============================================================
Loop_StartEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

	mov	al,es:[bx]
	inc	bx

	inc	al
	mov	si,offset UC_Loop_count
	add	si,cx
	mov	byte ptr cs:[si],al

	mov	si,offset UC_Loop_counter
	add	si,cx
	mov	byte ptr cs:[si],1	;１回目にセット

	mov	ax,bx			;ax ← 戻り先アドレス
	mov	si,offset UC_Loop_addr
	add	si,cx
	add	si,cx
	mov	word ptr cs:[si],ax

	inc	word ptr cs:[UC_LoopCountData]

	ret
Loop_StartEx	endp
;===============================================================
;		LOOP	終了	（シミュレート用）
;===============================================================
Loop_EndEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	mov	si,offset UC_Loop_count
	add	si,cx
	mov	ah,byte ptr cs:[si]	;ah ← ループ回数

	mov	si,offset UC_Loop_counter
	add	si,cx
	mov	al,byte ptr cs:[si]	;al ← 何ループ目

	.if	(ah>al)
		inc	al
		mov	cs:[si],al
		mov	si,offset UC_Loop_addr
		add	si,cx
		add	si,cx
		mov	ax,word ptr cs:[si]
		mov	bx,ax
	.else
		dec	word ptr cs:[UC_LoopCountData]
	.endif

	ret
Loop_EndEx	endp
;===============================================================
;		LOOP	抜け	（シミュレート用）
;===============================================================
Loop_ExitEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	mov	al,es:[bx]
	mov	dl,al			;dl ← 何カッコ？
	inc	bx
	mov	ax,es:[bx]
	sub	ax,cs:[UC_ADDER]	;ax ← ジャンプ先
	add	bx,2			;al ← 何カッコ？
	xchg	ax,dx			;dx ← ジャンプ先

	mov	si,offset UC_Loop_counter
	add	si,cx
	.if	(cs:[si]==al)
		mov	bx,dx		;ジャンプ
		mov	si,offset UC_Loop_count
		add	si,cx
		.if	(cs:[si]==al)
			;「現在のループ回数」＝「カッコ数」＝「ループ目」だったら
			dec	word ptr cs:[UC_LoopCountData]
		.endif
	.endif

	ret
Loop_ExitEx	endp
;===============================================================
;		LOOP	開始点
;===============================================================
LOOP_COUNT_PUSH	proc	near	uses cx dx di
	mov	dl,'['
	mov	ah,02h
	int	21h

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

	MOV	AH,ES:[BX]			;データ読み込み
	INC	BX				;ループ回数
	INC	AH				
	mov	di,offset UC_Loop_count		
	add	di,cx				
	mov	cs:[di],ah			;ループ回数を保存

	mov	di,offset UC_Loop_addr		;
	add	di,cx				;
	add	di,cx				;
	xor	ax,ax				;
	mov	cs:[di],ax			;ジャンプ先 0x0000にしておく

	inc	word ptr cs:[UC_LoopCountData]

	RET					
LOOP_COUNT_PUSH	endp
;===============================================================
;		LOOP	終了点
;===============================================================
LOOP_COUNT_POP	proc	near	uses cx dx di
	mov	dl,']'
	mov	ah,02h
	int	21h

	cmp	word ptr cs:[UC_LoopCountData],0
	jz	LOOP_COUNT_POP_E

	dec	word ptr cs:[UC_LoopCountData]
	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

	mov	di,offset UC_Loop_count		
	add	di,cx				
	mov	ah,cs:[di]			;ループ回数
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;

	mov	di,offset UC_Loop_addr		
	add	di,cx				
	add	di,cx				
	mov	ax,cs:[di]

	.if	(ax!=0)			;ジャンプ先
		mov	bx,ax		;ジャンプする
	.endif

LOOP_COUNT_POP_E:

	RET
LOOP_COUNT_POP	endp
endif	;--------------------------------
ifdef	PS1	;------------------------
;===============================================================
;	0xC8		ループ
;===============================================================
UC_LoopCountInc	proc	near
	inc	word ptr cs:[UC_LoopCountData]
	ret
UC_LoopCountInc	endp
;===============================================================
;	0xC9,0xCA	ループ
;===============================================================
UC_LoopCountDec	proc	near
	cmp	word ptr cs:[UC_LoopCountData],0
	jz	UC_LoopCountDec_1
	dec	word ptr cs:[UC_LoopCountData]
UC_LoopCountDec_1:
	ret
UC_LoopCountDec	endp
endif	;--------------------------------

;===============================================================
;		LOOP	抜け
;===============================================================
UC_ExitLoop_M1	db	'/*Adr=0x$'
UC_ExitLoop_M2	db	'*/:$'
UC_ExitLoop		proc	near	uses cx dx di

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	MOV	DX,OFFSET UC_ExitLoop_M1
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]	;
	inc	bx		;
	call	hex2asc8	;
	MOV	AH,09H		;
	INT	21H		;何回目で抜ける？

	mov	dl,','		;
	mov	ah,02h		;
	int	21h		;カンマ

	MOV	AX,ES:[BX]		;
ifdef	SPC	;------------------------
	sub	ax,cs:[UC_ADDER]	;ax←行き先絶対アドレス
endif	;--------------------------------
ifdef	FF8	;------------------------
	add	ax,bx
endif	;--------------------------------
	add	bx,2
ifdef	FF7	;------------------------
	add	ax,bx
endif	;--------------------------------

	mov	di,offset UC_Loop_addr	
	add	di,cx		
	add	di,cx		
	mov	cs:[di],ax	;行き先を保存

	call	DAT2HEX16
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UC_ExitLoop_M2
	MOV	AH,09H		;
	INT	21H		;

	ret			;
UC_ExitLoop		endp

;===============================================================
;		End Of Channel
;===============================================================
UC_End	proc	near	uses ax dx

	mov	byte ptr cs:[c_Command_EoC],01h		;デフォルトは、終わる

	.if	!(cs:[D_Debug]&001h)
		;-----------------------
		;有限ループが残ってる場合、解消する
		.while	(word ptr cs:[UC_LoopCountData]!=0)
			mov	dx,offset UCDFF_M06_2
			mov	ah,09h		;
			int	21h		;
			dec	word ptr cs:[UC_LoopCountData]
		.endw
	.endif

	ret
UC_End	endp
;===============================================================
;		EoC	with	無限ループ
;===============================================================
UCDFF_M06_1	DB	']2/*L*/$'
UCDFF_M06_2	DB	']1/*L*/$'
UCDFF_M07_Adr	dw	?	;飛び先

UC_PermanentLoop	proc	near	uses cx

	mov	byte ptr cs:[c_Command_EoC],01h		;デフォルトは、終わる

ifdef	PS1	;------------------------
	;-----------------------
	;有限ループが残ってる場合、解消する
	.while	(word ptr cs:[UC_LoopCountData]!=0)
		mov	dx,offset UCDFF_M06_2
		mov	ah,09h		;
		int	21h		;
		dec	word ptr cs:[UC_LoopCountData]
	.endw
endif	;--------------------------------

	;-----------------------
	;無限ループ処理
	mov	ax,es:[bx]		;ax←ループ先

	.if	(ax!=0)
		;ループアドレスのチェック
		push	es
ifdef	SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;bx←戻り先絶対アドレス
endif	;--------------------------------
ifdef	PS1	;------------------------
		add	ax,MUSIC_ADDRESSa	;bx←ループ先アドレス
		add	ax,bx			;
endif	;--------------------------------
		mov	bx,ax

		mov	cx,UCMOLS_LOOP_PTY	;回数セット
		mov	di,offset UCMOLS_LOOP_ADDRESS
		push	cs			
		pop	es			;es:di ← アドレス
	repne	scasw
		pop	es
		.if	(ZERO?)
			.if	(cs:[UCMOLS_LOOP_Count]==1)	;
				call	UC_End
			.endif
			MOV	DX,OFFSET UCDFF_M06_1
			MOV	AH,09H		;
			INT	21H		;
			dec	cs:[UCMOLS_LOOP_Count]
			.if	(cs:[UCMOLS_LOOP_Count]>0)	;
				mov	bx,word ptr cs:[UCDFF_M07_Adr]	;条件ジャンプ先にゴー
				mov	byte ptr cs:[c_Command_EoC],00h	;終わらないからリセット
			.endif
		.else	;無限ループ先と違う場合
			mov	byte ptr cs:[c_Command_EoC],00h	;終わらないからリセット
		.endif
	.else
		call	UC_End
	.endif

	RET			;RET命令で、↑に戻る。（チャンネル終了）
UC_PermanentLoop	endp
ifdef	SPC	;------------------------
;===============================================================
;		フラグによるジャンプ！！
;===============================================================
UC_ConditionalJump_M1	db	'/*L-Adr=0x$'
UC_ConditionalJump_M2	db	'*/:$'
UC_ConditionalJump	proc	near	uses ax dx
	MOV	DX,OFFSET UC_ConditionalJump_M1
	MOV	AH,09H		;
	INT	21H		;

	MOV	AX,ES:[BX]		;
	inc	bx			;
	inc	bx			;

	sub	ax,cs:[UC_ADDER]	;ax←行き先絶対アドレス

	mov	word ptr cs:[UCDFF_M07_Adr],ax
	call	dat2hex16	;
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UC_ConditionalJump_M2
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_ConditionalJump	endp
endif	;--------------------------------
