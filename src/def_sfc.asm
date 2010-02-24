ifdef	SPC	;------------------------
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
