ifdef	PS1	;------------------------
;===============================================================
;	0xB4		Pitch Bend LFO
;===============================================================
.data
UC_LFO_PitchBend_delay	db	0
UC_LFO_PitchBend_range	db	0
UC_LFO_PitchBend_count	db	0
UC_LFO_PitchBend_depth	db	0

.code
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
.data
UC_LFO_Expression_delay	db	0
UC_LFO_Expression_range	db	0
UC_LFO_Expression_count	db	0
UC_LFO_Expression_depth	db	0

.code
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
.data
UC_LFO_Panpot_delay	db	0
UC_LFO_Panpot_range	db	0
UC_LFO_Panpot_count	db	0
UC_LFO_Panpot_depth	db	0
.code
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
