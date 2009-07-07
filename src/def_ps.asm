ifdef	PS1	;------------------------
;===============================================================
;	0xA3	音量
;===============================================================

UC_Volume_TABLE:	;指数値を、リニアに変換
			;=INT(LOG((x+1))/LOG(129)*128)
;		0	+1	+2	+3	+4	+5	+6	+7
	db	0,	18,	28,	36,	42,	47,	51,	54
	db	57,	60,	63,	65,	67,	69,	71,	73
	db	74,	76,	77,	78,	80,	81,	82,	83
	db	84,	85,	86,	87,	88,	89,	90,	91
	db	92,	92,	93,	94,	95,	95,	96,	97
	db	97,	98,	99,	99,	100,	100,	101,	101
	db	102,	103,	103,	104,	104,	105,	105,	106
	db	106,	106,	107,	107,	108,	108,	109,	109
	db	109,	110,	110,	111,	111,	111,	112,	112
	db	113,	113,	113,	114,	114,	114,	115,	115
	db	115,	116,	116,	116,	117,	117,	117,	117
	db	118,	118,	118,	119,	119,	119,	119,	120
	db	120,	120,	121,	121,	121,	121,	122,	122
	db	122,	122,	123,	123,	123,	123,	124,	124
	db	124,	124,	124,	125,	125,	125,	125,	126
	db	126,	126,	126,	126,	127,	127,	127,	127

UC_Volume	proc	near
	MOV	AL,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	BX				;

;	XOR	AH,AH				;
;	MOV	BX,OFFSET UC_Volume_TABLE	;
;	ADD	BX,AX				;
;	MOV	AH,CS:[BX]			;
	xor	bx,bx
	mov	bl,al
	mov	ah,byte ptr cs:[UC_Volume_TABLE + bx]

	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	BX				;
	RET					;
UC_Volume	endp
;===============================================================
;	0xA8	音量セーブ
;===============================================================
UC_DATA_E	DB	?			;エクスプレッション
UC_SAVE_E	proc	near
	MOV	AL,ES:[BX]			;データ保存
	MOV	CS:[UC_DATA_E],AL		;
	RET					;
UC_SAVE_E	endp
;===============================================================
;	0xA9	音量ロード
;===============================================================
UC_LOAD_E	proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	DX				;
	MOV	AL,CS:[UC_DATA_E]		;保存データ
	MOV	CS:[UC_DATA_E],AH		;
	SUB	AH,AL				;
	CALL	FH2A8				;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_E	endp
;---------------------------------------------------------------
UC_LOAD_ES	proc	near
	PUSH	DX				;
	MOV	AH,CS:[UC_DATA_E]		;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_ES	endp
;===============================================================
;	0xAA	パンポット・セーブ
;===============================================================
UC_DATA_P	DB	?			;パンポット
UC_SAVE_P	proc	near
	MOV	AL,ES:[BX]			;データ保存
	MOV	CS:[UC_DATA_P],AL		;
	RET					;
UC_SAVE_P	endp
;===============================================================
;	0xA9	パンポット・ロード
;===============================================================
UC_LOAD_P	proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	DX				;
	MOV	AL,CS:[UC_DATA_P]		;保存データ
	MOV	CS:[UC_DATA_P],AH		;
	SUB	AH,AL				;
	CALL	FH2A8				;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_P	endp
;---------------------------------------------------------------
UC_LOAD_PS	proc	near
	PUSH	DX				;
	MOV	AH,CS:[UC_DATA_P]		;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_PS	endp
;===============================================================
;	0xB4		Pitch Bend LFO
;===============================================================
UC_LFO_PitchBend_delay	db	0
UC_LFO_PitchBend_range	db	0
UC_LFO_PitchBend_count	db	0
UC_LFO_PitchBend_depth	db	0

UC_LFO_PitchBend	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_delay],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_count],al

	call	UC_LFO_PitchBend_Output
	ret
UC_LFO_PitchBend	endp
;===============================================================
;	0xB5		Pitch Bend LFO
;===============================================================
UC_LFO_PitchBendDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_depth],al

	call	UC_LFO_PitchBend_Output
	ret
UC_LFO_PitchBendDepth	endp
;---------------------------------------------------------------
UC_LFO_PitchBend_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_PitchBend_depth],0
	jz	UC_LFO_PitchBend_End
	cmp	byte ptr cs:[UC_LFO_PitchBend_range],0
	jz	UC_LFO_PitchBend_End
	cmp	byte ptr cs:[UC_LFO_PitchBend_count],0
	jz	UC_LFO_PitchBend_End

	xor	ax,ax
	mov	al,byte ptr cs:[UC_LFO_PitchBend_depth]
	shl	ax,3
;	mov	ah,byte ptr cs:[UC_LFO_PitchBend_range]
;	imul	ah		;
;	mov	dx,8		;符号付きですよ？奥さん！！　多分
;	imul	dx
	cmp	ax,0
	jz	UC_LFO_PitchBend_End
	call	fh2a16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_PitchBend_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_PitchBend_count]
;	mov	ah,byte ptr cs:[UC_LFO_PitchBend_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_PitchBend_End:

	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_PitchBend_Output	endp
;===============================================================
;	0xB8		Expression LFO
;===============================================================
UC_LFO_Expression_delay	db	0
UC_LFO_Expression_range	db	0
UC_LFO_Expression_count	db	0
UC_LFO_Expression_depth	db	0

UC_LFO_Expression	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_delay],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_count],al

	call	UC_LFO_Expression_Output
	ret
UC_LFO_Expression	endp
;===============================================================
;	0xB9		Expression LFO
;===============================================================
UC_LFO_ExpressionDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_depth],al

	call	UC_LFO_Expression_Output
	ret
UC_LFO_ExpressionDepth	endp
;---------------------------------------------------------------
UC_LFO_Expression_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_Expression_depth],0
	jz	UC_LFO_Expression_End
	cmp	byte ptr cs:[UC_LFO_Expression_range],0
	jz	UC_LFO_Expression_End
	cmp	byte ptr cs:[UC_LFO_Expression_count],0
	jz	UC_LFO_Expression_End

	xor	ax,ax
	mov	ah,byte ptr cs:[UC_LFO_Expression_depth]
	shr	ah,3
;	mov	ah,byte ptr cs:[UC_LFO_Expression_range]
;	imul	ah
;	mov	dx,2
;	imul	dx
	cmp	ah,0
	jz	UC_LFO_Expression_End
	call	fh2a8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_Expression_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_Expression_count]
;	mov	ah,byte ptr cs:[UC_LFO_Expression_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_Expression_End:
	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_Expression_Output	endp
;===============================================================
;	0xBC		Panpot LFO
;===============================================================
UC_LFO_Panpot_delay	db	0
UC_LFO_Panpot_range	db	0
UC_LFO_Panpot_count	db	0
UC_LFO_Panpot_depth	db	0
UC_LFO_Panpot		proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_count],al

	call	UC_LFO_Panpot_Output
	ret
UC_LFO_Panpot		endp
;===============================================================
;	0xBD		Panpot LFO
;===============================================================
UC_LFO_PanpotDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_depth],al

	call	UC_LFO_Panpot_Output
	ret
UC_LFO_PanpotDepth	endp
;---------------------------------------------------------------
UC_LFO_Panpot_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_Panpot_depth],0
	jz	UC_LFO_Panpot_End
	cmp	byte ptr cs:[UC_LFO_Panpot_range],0
	jz	UC_LFO_Panpot_End
	cmp	byte ptr cs:[UC_LFO_Panpot_count],0
	jz	UC_LFO_Panpot_End

	xor	ax,ax
	mov	ah,byte ptr cs:[UC_LFO_Panpot_depth]
	shr	ah,3
;	mov	ah,byte ptr cs:[UC_LFO_Panpot_range]
;	imul	ah
;	mov	dx,2
;	imul	dx
	cmp	ah,0
	jz	UC_LFO_Panpot_End
	call	fh2a8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_Panpot_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_Panpot_count]
;	mov	ah,byte ptr cs:[UC_LFO_Panpot_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_Panpot_End:

	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_Panpot_Output	endp
endif	;--------------------------------
