ifdef	SPC	;------------------------
;****************************************************************
;*		音量						*
;****************************************************************
;対数テーブル
UC_Volume_Table:
	db	00h,	0Fh,	19h,	1Fh,	25h,	29h,	2Ch,	2Fh
	db	32h,	35h,	37h,	39h,	3Bh,	3Ch,	3Eh,	3Fh
	db	41h,	42h,	43h,	45h,	46h,	47h,	48h,	49h
	db	4Ah,	4Bh,	4Ch,	4Ch,	4Dh,	4Eh,	4Fh,	4Fh
	db	50h,	51h,	52h,	52h,	53h,	53h,	54h,	55h
	db	55h,	56h,	56h,	57h,	57h,	58h,	58h,	59h
	db	59h,	5Ah,	5Ah,	5Bh,	5Bh,	5Ch,	5Ch,	5Ch
	db	5Dh,	5Dh,	5Eh,	5Eh,	5Eh,	5Fh,	5Fh,	5Fh
	db	60h,	60h,	60h,	61h,	61h,	61h,	62h,	62h
	db	62h,	63h,	63h,	63h,	64h,	64h,	64h,	65h
	db	65h,	65h,	65h,	66h,	66h,	66h,	67h,	67h
	db	67h,	67h,	68h,	68h,	68h,	68h,	69h,	69h
	db	69h,	69h,	69h,	6Ah,	6Ah,	6Ah,	6Ah,	6Bh
	db	6Bh,	6Bh,	6Bh,	6Ch,	6Ch,	6Ch,	6Ch,	6Ch
	db	6Dh,	6Dh,	6Dh,	6Dh,	6Dh,	6Eh,	6Eh,	6Eh
	db	6Eh,	6Eh,	6Fh,	6Fh,	6Fh,	6Fh,	6Fh,	6Fh
	db	70h,	70h,	70h,	70h,	70h,	70h,	71h,	71h
	db	71h,	71h,	71h,	71h,	72h,	72h,	72h,	72h
	db	72h,	72h,	73h,	73h,	73h,	73h,	73h,	73h
	db	74h,	74h,	74h,	74h,	74h,	74h,	74h,	75h
	db	75h,	75h,	75h,	75h,	75h,	75h,	76h,	76h
	db	76h,	76h,	76h,	76h,	76h,	77h,	77h,	77h
	db	77h,	77h,	77h,	77h,	77h,	78h,	78h,	78h
	db	78h,	78h,	78h,	78h,	78h,	79h,	79h,	79h
	db	79h,	79h,	79h,	79h,	79h,	79h,	7Ah,	7Ah
	db	7Ah,	7Ah,	7Ah,	7Ah,	7Ah,	7Ah,	7Bh,	7Bh
	db	7Bh,	7Bh,	7Bh,	7Bh,	7Bh,	7Bh,	7Bh,	7Bh
	db	7Ch,	7Ch,	7Ch,	7Ch,	7Ch,	7Ch,	7Ch,	7Ch
	db	7Ch,	7Dh,	7Dh,	7Dh,	7Dh,	7Dh,	7Dh,	7Dh
	db	7Dh,	7Dh,	7Dh,	7Eh,	7Eh,	7Eh,	7Eh,	7Eh
	db	7Eh,	7Eh,	7Eh,	7Eh,	7Eh,	7Eh,	7Fh,	7Fh
	db	7Fh,	7Fh,	7Fh,	7Fh,	7Fh,	7Fh,	7Fh,	7Fh

;===============================================================
;		音量	for	FF4
;===============================================================
UC_ExpressionEx	proc	near

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
		lea	dx,[UC_ExpressionM]
		mov	ah,09h
		int	21h
		pop	ax		;Dummy
		call	UC_SAVE_E
	.else
		pop	bx
		call	UC_Expression
	.endif

	ret
UC_ExpressionEx	endp
;===============================================================
;		音量
;===============================================================
UC_SAVE_E	proc	near
	MOV	al,ES:[BX]			;データ保存
	inc	bx
ifdef	ExpRange	;---------------
	shl	al,1				;倍にする
endif	;-------------------------------
	push	bx
	lea	bx,[UC_Volume_Table]
	xlat

	mov	ah,al
	MOV	CS:[UC_DATA_E],ah

	call	hex2asc8
	mov	ah,09h
	int	21h

	pop	bx
	ret
UC_SAVE_E	endp
;===============================================================
;		音量ロード
;===============================================================
UC_ExpressionM	db	'E$'
UC_ExpressionM1	db	'UE1,0,%$'
UC_DATA_E	DB	?			;エクスプレッション
UC_Expression	proc	near

	lea	DX,[UC_ExpressionM]
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_DATA_E]
	CALL	HEX2ASC8	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	lea	DX,[UC_ExpressionM1]
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

	XOR	AX,AX		;
	MOV	al,ES:[BX]	;データ読み込み
	INC	BX		;
ifdef	ExpRange	;---------------
	shl	al,1				;倍にする
endif	;-------------------------------

	push	bx
	lea	bx,[UC_Volume_Table]
	xlat
	mov	ah,al
	pop	bx

	push	ax
	sub	ah,byte ptr cs:[UC_DATA_E]
	CALL	FH2A8		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示
	pop	ax

	mov	byte ptr cs:[UC_DATA_E],ah

	RET					;
UC_Expression	endp
;===============================================================
;		パン	for	FF4
;===============================================================
UC_PanpotEx	proc	near

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
		lea	dx,[UC_PanpotM]
		mov	ah,09h
		int	21h
		pop	ax		;Dummy
		call	UC_SAVE_P
	.else
		pop	bx
		call	UC_Panpot
	.endif

	ret
UC_PanpotEx	endp
;===============================================================
;		パンポット・セーブ
;===============================================================
UC_SAVE_P	proc	near
	MOV	AH,ES:[BX]			;データ保存
	inc	bx

ifndef	PanRange	;---------------
	shr	ah,1
endif	;-------------------------------
	MOV	CS:[UC_DATA_P],ah		;

	call	hex2asc8
	mov	ah,09h
	int	21h
	ret
UC_SAVE_P	endp
;===============================================================
;		パンポット・ロード
;===============================================================
UC_PanpotM	db	'p$'
UC_PanpotM1	db	'UP1,0,%$'
UC_DATA_P	DB	?			;パンポット
UC_Panpot	proc	near

	lea	DX,[UC_PanpotM]
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_DATA_P]
	CALL	HEX2ASC8	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	lea	DX,[UC_PanpotM1]
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

	XOR	AX,AX		;
	MOV	ah,ES:[BX]	;データ読み込み
	INC	BX		;

ifndef	PanRange	;---------------
	shr	ah,1
endif	;-------------------------------
	push	ax
	sub	ah,byte ptr cs:[UC_DATA_P]
	CALL	FH2A8		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示
	pop	ax

	mov	byte ptr cs:[UC_DATA_P],ah

	RET					;
UC_Panpot	endp
;===============================================================
;		LFO
;===============================================================
UC_LFO_OUT	proc	near	uses cx dx,
		depth:word, delay:byte, rate:byte

	mov	ax,depth

	.if	(ax!=0)

ifdef	LFO_DepthMul	;---------------
		mov	dx,LFO_DepthMul
		mul	dx
endif	;-------------------------------
ifdef	LFO_DepthDiv	;---------------
		mov	cx,LFO_DepthDiv
		div	cx
endif	;-------------------------------

		call	fh2a16		;
		mov	ah,09h		;
		int	21h		;Depth

		mov	dl,','		;
		mov	ah,02h		;
		int	21h		;

		mov	dl,'1'		;step
		mov	ah,02h		;
		int	21h		;

		mov	dl,','		;
		mov	ah,02h		;
		int	21h		;

		xor	ax,ax
		mov	al,delay
ifdef	LFO_DelayMul	;---------------
		mov	dx,LFO_DelayMul
		mul	dx
endif	;-------------------------------
ifdef	LFO_DelayDiv	;---------------
		mov	cx,LFO_DelayDiv
		div	cx
endif	;-------------------------------
		call	hex2asc16	;
		mov	ah,09h		;
		int	21h		;delay

		mov	dl,','		;
		mov	ah,02h		;
		int	21h		;

		xor	ax,ax
		mov	al,rate
ifdef	LFO_RateMul	;---------------
		mov	dx,LFO_RateMul
		mul	dx
endif	;-------------------------------
ifdef	LFO_RateDiv	;---------------
		mov	cx,LFO_RateDiv
		div	cx
endif	;-------------------------------
		call	hex2asc16
		mov	ah,09h		;
		int	21h		;rate

	.else
		mov	dl,'0'		;
		mov	ah,02h		;
		int	21h		;
	.endif

	ret
UC_LFO_OUT	endp
;===============================================================
;		LFO
;===============================================================
UC_LFO_IW	proc	near	uses cx dx,

	local	delay:byte
	local	rate:byte
	local	depth:word

ifndef	LFO_DepthFirst	;---------------
	mov	al,es:[bx]
	inc	bx
	mov	delay,al

	mov	al,es:[bx]
	inc	bx
	mov	rate,al
endif	;-------------------------------

	mov	al,es:[bx]		;なので、4ではなく、2にする。
	inc	bx
	cbw				;word化
ifdef	LFO_PitchCent	;---------------
	mov	dx,512*LFO_DepthDiv/LFO_PitchCent
else	;-------------------------------
	mov	dx,2			;MML2MIDは、片側の振幅指定。
endif	;-------------------------------
	imul	dx

ifdef	LFO_PitchCent	;---------------
	mov	cx,LFO_DepthMul
else	;-------------------------------
	mov	cx,1			;MML2MIDは、片側の振幅指定。
endif	;-------------------------------
	idiv	cx

	mov	depth,ax

ifdef	LFO_DepthFirst	;---------------
	mov	al,es:[bx]
	inc	bx
	mov	delay,al

	mov	al,es:[bx]
	inc	bx
	mov	rate,al
endif	;-------------------------------

	invoke	UC_LFO_OUT,depth,delay,rate

	ret
UC_LFO_IW	endp
;===============================================================
;		LFO
;===============================================================
UC_LFO_IE	proc	near	uses cx dx,

	local	delay:byte
	local	rate:byte
	local	depth:word

	mov	al,es:[bx]
	inc	bx
	mov	delay,al

	mov	al,es:[bx]
	inc	bx
	mov	rate,al

	mov	al,es:[bx]
	inc	bx
	.if	(al&80h)
		mov	dx,0ffffh
		mov	ah,0ffh
	.else
		xor	dx,dx
		xor	ah,ah
	.endif
	mov	cx,2
	idiv	cx
	mov	depth,ax

	invoke	UC_LFO_OUT,depth,delay,rate

	ret
UC_LFO_IE	endp
;===============================================================
;		LFO
;===============================================================
UC_LFO_IP	proc	near	uses cx dx

	local	delay:byte
	local	rate:byte
	local	depth:word

ifdef	LFO_PanDelay0	;---------------
	mov	delay,0
else	;-------------------------------
	mov	al,es:[bx]
	inc	bx
	mov	delay,al
endif	;-------------------------------

	mov	al,es:[bx]
	inc	bx
	.if	(al&80h)
		mov	dx,0ffffh
		mov	ah,0ffh
	.else
		xor	dx,dx
		xor	ah,ah
	.endif
	mov	cx,2
	idiv	cx
	mov	depth,ax

	mov	al,es:[bx]
	inc	bx
	mov	rate,al

	invoke	UC_LFO_OUT,depth,delay,rate

	ret
UC_LFO_IP	endp
;****************************************************************
;*		シーケンス					*
;****************************************************************
endif	;--------------------------------
