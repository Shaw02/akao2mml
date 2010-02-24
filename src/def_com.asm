.code
;===============================================================
;	������
;===============================================================
UC_INIT		proc	near	uses ax

	mov	ax,0

;ifdef	SPC	;------------------------
	mov	word ptr cs:[UC_Detune_D],8192		;�p�C�v���C���΍�
;endif	;-------------------------------
;ifdef	PS1	;------------------------
;	mov	byte ptr cs:[UC_Detune_D],64		;
;endif	;-------------------------------

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
;	mov	word ptr cs:[UC_Tempo_Work],ax		;���������Ȃ��ł݂�

ifdef	Rhythm12	;---------------
	mov	byte ptr cs:[UC_Rhythm_flag],al
endif	;-------------------------------

	ret
UC_INIT		endp
;****************************************************************
;*		���F						*
;****************************************************************
;
;		���F�}�N���ϊ�
;
.data
ifdef	ff7	;------------------------
UC_VoiceExWork	dw	16	DUP	(0FFFFh)
endif	;--------------------------------

ifndef	ff7	;------------------------
UC_VOICE	DB	64	DUP	(0FFh)	
endif	;--------------------------------


.const
		;���F�}�N����
UC_VoiceEx_Name	DB	'0a$','1a$','2a$','3a$','4a$','5a$','6a$','7a$'
		DB	'0b$','1b$','2b$','3b$','4b$','5b$','6b$','7b$'

		;���F�}�N����
ifdef	ff7	;------------------------
UC_VOICE_NAME	DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$','8c$','9c$'
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
UC_VOICE_NAME	DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$'
		DB	'0d$','1d$','2d$','3d$','4d$','5d$','6d$','7d$'
		DB	'0e$','1e$','2e$','3e$','4e$','5e$','6e$','7e$'
		DB	'0f$','1f$','2f$','3f$','4f$','5f$','6f$','7f$'
		DB	'0g$','1g$','2g$','3g$','4g$','5g$','6g$','7g$'
		DB	'0h$','1h$','2h$','3h$','4h$','5h$','6h$','7h$'
		DB	'0i$','1i$','2i$','3i$','4i$','5i$','6i$','7i$'
		DB	'0j$','1j$','2j$','3j$','4j$','5j$','6j$','7j$'
endif	;--------------------------------

;===============================================================
;		���F
;===============================================================
.code
UC_VOICE_OUTPUT	proc	near	uses	cx dx
	mov	ax,0				;
	MOV	AL,ES:[BX]			;ax���f�[�^�ǂݍ���
	INC	BX				;
	push	bx

	lea	DX,[UC_VOICE_NAME]		;
ifdef	ff7	;------------------------
	add	dx,ax				;
	add	dx,ax				;
	add	dx,ax				;DX��Address + ax *3
else	;--------------------------------
	xor	bx,bx				;BX��0
	.repeat
	   mov	ah,cs:[UC_VOICE + BX]		;�g�p�o�^�ς݉��F�ǂݍ���
	   .if	(ah==0ffh)
		MOV	CS:[UC_VOICE + BX],AL	;�o�^
		.break
	   .elseif	(ah==al)
		.break
	   .endif

	   inc	bx
	.until	0

	add	dx,bx				;
	add	dx,bx				;
	add	dx,bx				;DX��Address + BX *3
endif	;--------------------------------

	MOV	AH,09H				;
	INT	21H				;

	pop	bx
	RET					;
UC_VOICE_OUTPUT	endp
;===============================================================
;	0xFC	�g�����F
;===============================================================
UC_VoiceEx	proc	near	uses dx

	MOV	DL,24H		;'$'�̏o��
	MOV	AH,02H		;
	INT	21H		;

ifdef	ff7	;------------------------
	mov	ax,es:[bx]			;ax���f�[�^�ǂݍ���
	inc	bx
	inc	bx
	add	ax,bx
	mov	dx,ax				;cx�����F�̃A�h���X

	PUSH	BX				;
	xor	bx,bx				;BX��0
	.repeat
	   mov	ax,cs:[UC_VoiceExWork + BX]		;�g�p�o�^�ς݉��F�ǂݍ���
	   .if	(ax==0ffffh)
		MOV	CS:[UC_VoiceExWork + BX],dx	;�o�^
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

	lea	DX,[UC_VoiceEx_Name]		;
	ADD	dx,ax				;
	ADD	dx,ax				;
	ADD	dx,ax				;
	MOV	AH,09H				;�}�N���ԍ��\��
	INT	21H				;

	ret					;
UC_VoiceEx	endp
;****************************************************************
ifdef	Rhythm12	;---------------
.data
UC_Rhythm_flag		db	0
UC_Rhythm_Address	dw	0
.code
;===============================================================
;		���Y��on
;===============================================================
UC_Rhythm_on_M	db	'/*1z*/$'
UC_Rhythm_on	proc	near
	lea	dx,[UC_Rhythm_on_M]
	mov	ah,09h			;
	int	21h			;

	mov	byte ptr cs:[UC_Rhythm_flag],1

	call	UC_Rhythm_adr_set

	ret
UC_Rhythm_on	endp
;===============================================================
;		���Y��off
;===============================================================
UC_Rhythm_off_M	db	'/*0z*/$'
UC_Rhythm_off	proc	near
	lea	dx,[UC_Rhythm_off_M]
	mov	ah,09h			;
	int	21h			;

	mov	byte ptr cs:[UC_Rhythm_flag],0
	ret
UC_Rhythm_off	endp
;===============================================================
;		���Y���A�h���X�@�Z�b�g
;===============================================================
.const
UC_Rhythm_adr_set_M1	db	' /*Adr=0x',24h
UC_Rhythm_adr_set_M2	db	' */',24h
.code
UC_Rhythm_adr_set	proc	near	uses dx si

	lea	dx,[UC_Rhythm_adr_set_M1]
	mov	ah,09h			;
	int	21h			;

	mov	ax,es:[bx]		;
	inc	bx			;
	inc	bx			;
	add	ax,bx			;

	mov	cs:[UC_Rhythm_Address],ax	;���Y����`�̃A�h���X
	call	dat2hex16		
	mov	ah,09h			
	int	21h			;�\�������Ă���

	lea	dx,[UC_Rhythm_adr_set_M2]
	mov	ah,09h
	int	21h

	ret
UC_Rhythm_adr_set	endp
endif	;-------------------------------
;===============================================================
;	0xEC	�p�[�J�b�V����on
;===============================================================
.const
UC_Perc_On		db	'1z$'
UC_Perc_On_VGMtrans	db	'@127$'
.code
UC_PercussionOn		proc	near

	.if	(cs:[D_Debug] & 02h)
		lea	dx,[UC_Perc_On_VGMtrans]
	.else
		MOV	DL,24H		;'$'�̏o��
		MOV	AH,02H		;
		INT	21H		;
		lea	dx,[UC_Perc_On]
	.endif
	MOV	AH,09H			;
	INT	21H			;

	ret
UC_PercussionOn		endp
;===============================================================
;	0xED	�p�[�J�b�V����off
;===============================================================
.const
UC_Perc_Off	db	'0z$'
.code
UC_PercussionOff	proc	near
	MOV	DL,24H		;'$'�̏o��
	MOV	AH,02H		;
	INT	21H		;

	lea	DX,[UC_Perc_Off]
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_PercussionOff	endp
;****************************************************************
;*		����						*
;****************************************************************
;===============================================================
;		�I�N�^�[�u
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
;		�s�b�`�x���h
;===============================================================
.data?
UC_Detune_D	dw	?
.code
UC_Detune	proc	near	uses dx
	xor	ax,ax				;
	mov	al,es:[bx]			;
	inc	bx				;
ifdef	SPC	;------------------------
	mov	ah,4				;�����A���̂��炢�H
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ah,64				;�����A���̂��炢�H
endif	;-------------------------------
	imul	ah				;
	add	ax,8192				;
	mov	word ptr cs:[UC_Detune_D],ax	;
	CALL	HEX2ASC16			;�o��

	MOV	AH,09H				;
	INT	21H				;
	ret					;
UC_Detune	endp
;===============================================================
;		�|���^�����g
;===============================================================
.data
UC_portamento_D	db	0			;�ۑ�����
.code
UC_portamento	proc	near	uses	cx dx
	mov	al,byte ptr cs:[UC_portamento_D]
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;�����ψʏo��

	MOV	DL,','				;','�̏o��
	MOV	AH,02H				;
	INT	21H				;

	MOV	DL,'%'				;'%'�̏o��
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
	int	21h				;�X�e�b�v�̏o��

	MOV	DL,','				;','�̏o��
	MOV	AH,02H				;
	INT	21H				;

	MOV	Al,ES:[BX]			;
	inc	bx				;
	add	byte ptr cs:[UC_portamento_D],al
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;�X�e�b�v�̏o��

	ret
UC_portamento	endp
;===============================================================
;		�|���^�����g	for FF4
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
;*		����						*
;****************************************************************
;�ΐ��e�[�u��
.const
ifdef	SPC	;------------------------
UC_Volume_Table	db	00h,	0Fh,	19h,	1Fh,	25h,	29h,	2Ch,	2Fh
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
endif	;-------------------------------
ifdef	PS1	;------------------------
;			�w���l���A���j�A�ɕϊ�
;			=INT(LOG((x+1))/LOG(129)*128)
;			0	+1	+2	+3	+4	+5	+6	+7
UC_Volume_TABLE	db	0,	18,	28,	36,	42,	47,	51,	54
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
endif	;-------------------------------

;===============================================================
;		����	for	PS
;===============================================================
.code
ifdef	PS1	;------------------------
UC_Volume	proc	near
	MOV	AL,ES:[BX]			;�f�[�^�ǂݍ���
	INC	BX				;
	PUSH	BX				;

	xor	bx,bx
	mov	bl,al
	mov	ah,byte ptr cs:[UC_Volume_TABLE + bx]

	CALL	HEX2ASC8			;�o��
	MOV	AH,09H				;
	INT	21H				;
	POP	BX				;
	RET					;
UC_Volume	endp
endif	;-------------------------------
;===============================================================
;		����	for	FF4
;===============================================================
.code
ifdef	FF4	;------------------------
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
endif	;-------------------------------
;===============================================================
;		����
;===============================================================
UC_SAVE_E	proc	near
	MOV	al,ES:[BX]			;�f�[�^�ۑ�
	inc	bx
ifdef	SPC	;-----------------------
ifdef	ExpRange	;---------------
	shl	al,1				;�{�ɂ���
endif	;-------------------------------
	push	bx
	lea	bx,[UC_Volume_Table]
	xlat
	pop	bx
endif	;-------------------------------
	mov	ah,al
	MOV	CS:[UC_DATA_E],al

	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_SAVE_E	endp
;===============================================================
;		���ʃ��[�h
;===============================================================
.const
UC_ExpressionM	db	'E$'
UC_ExpressionM1	db	'UE1,0,%$'

.data?
UC_DATA_E	DB	?			;�G�N�X�v���b�V����

.code
UC_Expression	proc	near

	lea	DX,[UC_ExpressionM]
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_DATA_E]
	CALL	HEX2ASC8	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

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
ifdef	SPC	;-----------------------
	dec	ax		;
endif	;-------------------------------
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	MOV	DL,2CH		;','�̏o��
	MOV	AH,02H		;
	INT	21H		;

	XOR	AX,AX		;
	MOV	al,ES:[BX]	;�f�[�^�ǂݍ���
	INC	BX		;
ifdef	SPC	;-----------------------
ifdef	ExpRange	;---------------
	shl	al,1				;�{�ɂ���
endif	;-------------------------------
	push	bx
	lea	bx,[UC_Volume_Table]
	xlat
	pop	bx
endif	;-------------------------------
	mov	ah,al

	sub	ah,byte ptr cs:[UC_DATA_E]
	mov	byte ptr cs:[UC_DATA_E],al
	CALL	FH2A8		;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	RET					;
UC_Expression	endp
;===============================================================
;		�p��	for	FF4
;===============================================================
ifdef	FF4	;------------------------
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
endif	;-------------------------------
;===============================================================
;		�p���|�b�g�E�Z�[�u
;===============================================================
UC_SAVE_P	proc	near
	MOV	AH,ES:[BX]			;�f�[�^�ۑ�
	inc	bx

ifdef	SPC	;-----------------------
ifndef	PanRange	;---------------
	shr	ah,1
endif	;-------------------------------
endif	;-------------------------------
	MOV	CS:[UC_DATA_P],ah		;

	call	hex2asc8
	mov	ah,09h
	int	21h
	ret
UC_SAVE_P	endp
;===============================================================
;		�p���|�b�g�E���[�h
;===============================================================
.const
UC_PanpotM	db	'p$'
UC_PanpotM1	db	'UP1,0,%$'

.data?
UC_DATA_P	DB	?			;�p���|�b�g

.code
UC_Panpot	proc	near

	lea	DX,[UC_PanpotM]
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_DATA_P]
	CALL	HEX2ASC8	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

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
ifdef	SPC	;-----------------------
	dec	ax		;
endif	;-------------------------------
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	MOV	DL,2CH		;','�̏o��
	MOV	AH,02H		;
	INT	21H		;

	XOR	AX,AX		;
	MOV	al,ES:[BX]	;�f�[�^�ǂݍ���
	INC	BX		;

ifdef	SPC	;-----------------------
ifndef	PanRange	;---------------
	shr	al,1
endif	;-------------------------------
endif	;-------------------------------
	mov	ah,al
	sub	ah,byte ptr cs:[UC_DATA_P]
	mov	byte ptr cs:[UC_DATA_P],al
	CALL	FH2A8		;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	RET					;
UC_Panpot	endp




		;	to	do







;****************************************************************
;*		���̑�						*
;****************************************************************
;===============================================================
;		���o�[�u
;===============================================================
.const
UC_UC_Reverb_M1	db	'/*Reverb($'
UC_UC_Reverb_M2	db	')*/$'

.code
UC_Reverb		proc	near
	lea	DX,[UC_UC_Reverb_M1]
	MOV	AH,09H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX		;
	MOV	AL,ES:[BX]	;�f�[�^�ǂݍ���
	inc	bx		;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
endif	;-------------------------------
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	lea	DX,[UC_UC_Reverb_M2]
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_Reverb		endp
;===============================================================
;		���΃��o�[�u
;===============================================================
.const
UC_UC_Reverb_M8	db	'/*Reverb($'
UC_UC_Reverb_M9	db	')*/$'

.code
UC_RelativeReverb	proc	near
	lea	DX,[UC_UC_Reverb_M8]
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
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	MOV	DL,2CH		;','�̏o��
	MOV	AH,02H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX		;
	MOV	AL,ES:[BX]	;�f�[�^�ǂݍ���
	inc	bx		;
endif	;-------------------------------
ifdef	PS1	;------------------------
	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
endif	;-------------------------------
	CALL	FH2A16		;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	lea	DX,[UC_UC_Reverb_M9]
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_RelativeReverb	endp
;****************************************************************
;*		���^�E�C�x���g					*
;****************************************************************
;===============================================================
;		�e���|	for	FF4
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
;		�e���|
;===============================================================
.const
UC_RTempo_M	db	't$'

.data
UC_Tempo_Work	dw	0

.code
UC_Tempo	proc	near	uses dx cx
	lea	DX,[UC_RTempo_M]
	MOV	AH,09H			;
	INT	21H			;

ifdef	SPC	;------------------------
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ���
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
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	RET
UC_Tempo	endp
;===============================================================
;		���΃e���|
;===============================================================
.const
UC_RelativeTempo_M	db	'UT1,0,%$'

.code
UC_RelativeTempo	proc	near	uses dx cx

	lea	DX,[UC_RTempo_M]
	MOV	AH,09H		;
	INT	21H		;

	mov	ax,word ptr cs:[UC_Tempo_Work]
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	lea	DX,[UC_RelativeTempo_M]
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
	CALL	HEX2ASC16	;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��

	MOV	DL,2CH		;','�̏o��
	MOV	AH,02H		;
	INT	21H		;

ifdef	SPC	;------------------------
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ���
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
	DIV	CX		;ax��Tempo �~ 11/10
endif	;-------------------------------
	push	ax
	sub	ax,word ptr cs:[UC_Tempo_Work]
	CALL	FH2A16		;���l�ϊ�
	MOV	AH,09H		;
	INT	21H		;�����Ă����\��
	pop	ax

	mov	word ptr cs:[UC_Tempo_Work],ax

	ret
UC_RelativeTempo	endp
;===============================================================
;	0xFD	���q
;===============================================================
.const
UC_Beat_M	db	'BT$'

.code
UC_Beat			proc	near

	lea	dx,[UC_Beat_M]
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
	cmp	ah,0		;0���Z�G���[�h�~
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

	mov	dl,al		;dl��al�itimes�j
	mov	ax,192		;�itimebase �~ 4�j
	div	dl		;al��192 �� dl�itimes�j
	mov	ah,al		;
	call	hex2asc8	;
	mov	ah,09h		;
	int	21h		;

	ret
UC_Beat			endp
;===============================================================
;	0xFE	���߁i���n�[�T���j�ԍ�
;===============================================================
.const
UC_Measures_M	db	'WC$'

.code
UC_Measures		proc	near

	lea	dx,[UC_Measures_M]
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
;*		�V�[�P���X					*
;****************************************************************
;===============================================================
;	0xA2	���̉����E�x���̉���
;===============================================================
.data
UC_Step_work	db	0			;

.code
UC_Step		proc	near
	MOV	AH,ES:[BX]			;�f�[�^�ǂݍ���
	inc	bx				;
	mov	byte ptr cs:[UC_Step_work],ah	;�ۑ�
	RET					;
UC_Step		endp

;===============================================================
;		LOOP	�����p�̕ϐ�	�i�܂��́A32��̃l�X�g�ɑΉ��j
;			���V�~�����[�g�ł��A���̕ϐ����g���܂��B
;===============================================================
.data?
UC_LoopCountData	dw	?
UC_Loop_count		db	32	dup(?)
UC_Loop_counter		db	32	dup(?)
UC_Loop_addr		dw	32	dup(?)

.code
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
Loop_End2	proc	near
	.if	(cs:[D_Debug]&001h)
		call	Loop_EndEx2
	.else
		call	LOOP_COUNT_POP2
	.endif
	ret
Loop_End2	endp
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
;		LOOP	�J�n�_	�i�V�~�����[�g�p�j
;===============================================================
Loop_StartEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

ifdef	SPC	;------------------------
	mov	al,es:[bx]		;�񐔓ǂݏo��
	inc	bx
	inc	al
	lea	si,[UC_Loop_count]
	add	si,cx
	mov	byte ptr cs:[si],al
endif	;--------------------------------

	lea	si,[UC_Loop_counter]
	add	si,cx
	mov	byte ptr cs:[si],1	;�P��ڂɃZ�b�g

	mov	ax,bx			;ax �� �߂��A�h���X
	lea	si,[UC_Loop_addr]
	add	si,cx
	add	si,cx
	mov	word ptr cs:[si],ax

	inc	word ptr cs:[UC_LoopCountData]

	ret
Loop_StartEx	endp
;===============================================================
;		LOOP	�J�n�_
;===============================================================
LOOP_COUNT_PUSH	proc	near	uses cx dx si
	mov	dl,'['
	mov	ah,02h
	int	21h

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

ifdef	SPC	;------------------------
	MOV	al,ES:[BX]			;�f�[�^�ǂݍ���
	INC	BX				;���[�v��
	INC	al				
	lea	si,[UC_Loop_count]		
	add	si,cx				
	mov	cs:[si],al			;���[�v�񐔂�ۑ�
endif	;--------------------------------

	lea	si,[UC_Loop_addr]		;
	add	si,cx				;
	add	si,cx				;
	xor	ax,ax				;
	mov	cs:[si],ax			;�W�����v�� 0x0000�ɂ��Ă���

	inc	word ptr cs:[UC_LoopCountData]

	RET					
LOOP_COUNT_PUSH	endp
;===============================================================
;		LOOP	�I��	�i�V�~�����[�g�p�j
;===============================================================
Loop_EndEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

ifdef	SPC	;------------------------
	lea	si,[UC_Loop_count]
	add	si,cx
	mov	ah,byte ptr cs:[si]	;ah �� ���[�v��
endif	;--------------------------------
ifdef	PS1	;------------------------
	mov	ah,es:[bx]		;�񐔓ǂݏo��
	inc	bx
endif	;--------------------------------

	lea	si,[UC_Loop_counter]
	add	si,cx
	mov	al,byte ptr cs:[si]	;al �� �����[�v��

	.if	(ah>al)
		inc	al
		mov	cs:[si],al
		lea	si,[UC_Loop_addr]
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
;		LOOP	�I���_
;===============================================================
LOOP_COUNT_POP	proc	near	uses cx dx si
	mov	dl,']'
	mov	ah,02h
	int	21h

	cmp	word ptr cs:[UC_LoopCountData],0
	jz	LOOP_COUNT_POP_E

	dec	word ptr cs:[UC_LoopCountData]
	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

ifdef	SPC	;------------------------
	lea	si,[UC_Loop_count]		
	add	si,cx				
	mov	ah,cs:[si]			;���[�v��
endif	;--------------------------------
ifdef	PS1	;------------------------
	mov	ah,es:[bx]			;�񐔓ǂݏo��
	inc	bx
endif	;--------------------------------
	CALL	HEX2ASC8			;�o��
	MOV	AH,09H				;
	INT	21H				;

	lea	si,[UC_Loop_addr]		
	add	si,cx				
	add	si,cx				
	mov	ax,cs:[si]

	.if	(ax!=0)			;�W�����v��
		mov	bx,ax		;�W�����v����
	.endif

LOOP_COUNT_POP_E:

	RET
LOOP_COUNT_POP	endp
;===============================================================
;		LOOP	�I��	�i�V�~�����[�g�p�j
;===============================================================
Loop_EndEx2	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	mov	ah,2

	lea	si,[UC_Loop_counter]
	add	si,cx
	mov	al,byte ptr cs:[si]	;al �� �����[�v��

	.if	(ah>al)
		inc	al
		mov	cs:[si],al
		lea	si,[UC_Loop_addr]
		add	si,cx
		add	si,cx
		mov	ax,word ptr cs:[si]
		mov	bx,ax
	.else
		dec	word ptr cs:[UC_LoopCountData]
	.endif

	ret
Loop_EndEx2	endp
;===============================================================
;		LOOP	�I���_
;===============================================================
LOOP_COUNT_POP2	proc	near	uses cx dx si
	mov	dl,']'
	mov	ah,02h
	int	21h

	cmp	word ptr cs:[UC_LoopCountData],0
	jz	LOOP_COUNT_POP2_E

	dec	word ptr cs:[UC_LoopCountData]
	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax

	mov	ah,2				;
	CALL	HEX2ASC8			;�o��
	MOV	AH,09H				;
	INT	21H				;

	lea	si,[UC_Loop_addr]		
	add	si,cx				
	add	si,cx				
	mov	ax,cs:[si]

	.if	(ax!=0)			;�W�����v��
		mov	bx,ax		;�W�����v����
	.endif

LOOP_COUNT_POP2_E:

	RET
LOOP_COUNT_POP2	endp
;===============================================================
;		LOOP	����	�i�V�~�����[�g�p�j
;===============================================================
Loop_ExitEx	proc	near	uses ax cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	mov	al,es:[bx]
	mov	dl,al			;dl �� ���J�b�R�H
	inc	bx

	mov	ax,es:[bx]
ifdef	SPC	;------------------------
	sub	ax,cs:[UC_ADDER]	;ax���s�����΃A�h���X
endif	;--------------------------------
ifdef	FF8	;------------------------
	add	ax,bx
endif	;--------------------------------
	add	bx,2
ifdef	FF7	;------------------------
	add	ax,bx
endif	;--------------------------------

	xchg	ax,dx			;dx �� �W�����v��

	lea	si,[UC_Loop_counter]
	add	si,cx
	.if	(cs:[si]==al)
		mov	bx,dx		;�W�����v
		lea	si,[UC_Loop_count]
		add	si,cx
		.if	(cs:[si]==al)
			;�u���݂̃��[�v�񐔁v���u�J�b�R���v���u���[�v�ځv��������
			dec	word ptr cs:[UC_LoopCountData]
		.endif
	.endif

	ret
Loop_ExitEx	endp
;===============================================================
;		LOOP	����
;===============================================================
.const
UC_ExitLoop_M1	db	'/*Adr=0x$'
UC_ExitLoop_M2	db	'*/:$'

.code
UC_ExitLoop		proc	near	uses cx dx si

	mov	ax,word ptr cs:[UC_LoopCountData]
	mov	cx,ax
	dec	cx

	lea	DX,[UC_ExitLoop_M1]
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]	;
	inc	bx		;
	call	hex2asc8	;
	MOV	AH,09H		;
	INT	21H		;����ڂŔ�����H

	mov	dl,','		;
	mov	ah,02h		;
	int	21h		;�J���}

	MOV	AX,ES:[BX]		;
ifdef	SPC	;------------------------
	sub	ax,cs:[UC_ADDER]	;ax���s�����΃A�h���X
endif	;--------------------------------
ifdef	FF8	;------------------------
	add	ax,bx
endif	;--------------------------------
	add	bx,2
ifdef	FF7	;------------------------
	add	ax,bx
endif	;--------------------------------

	lea	si,[UC_Loop_addr]
	add	si,cx		
	add	si,cx		
	mov	cs:[si],ax	;�s�����ۑ�

	call	DAT2HEX16
	MOV	AH,09H		;
	INT	21H		;

	lea	DX,[UC_ExitLoop_M2]
	MOV	AH,09H		;
	INT	21H		;

	ret			;
UC_ExitLoop		endp
;===============================================================
;		End Of Channel
;===============================================================
UC_End	proc	near	uses ax dx

	mov	byte ptr cs:[c_Command_EoC],01h		;�f�t�H���g�́A�I���

	.if	!(cs:[D_Debug]&001h)
		;-----------------------
		;�L�����[�v���c���Ă�ꍇ�A��������
		.while	(word ptr cs:[UC_LoopCountData]!=0)
			lea	dx,[UCDFF_M06_2]
			mov	ah,09h		;
			int	21h		;
			dec	word ptr cs:[UC_LoopCountData]
		.endw
	.endif

	ret
UC_End	endp
;===============================================================
;		EoC	with	�������[�v
;===============================================================
.const
UCDFF_M06_1	DB	']2/*L*/$'
UCDFF_M06_2	DB	']1$'

.data?
UCDFF_M07_Adr	dw	?	;��ѐ�

.code
UC_PermanentLoop	proc	near	uses cx di

ifdef	FF8	;------------------------
	call	UC_End
else	;--------------------------------
	mov	byte ptr cs:[c_Command_EoC],01h		;�f�t�H���g�́A�I���
endif	;--------------------------------
	;-----------------------
	;�������[�v����
	mov	ax,es:[bx]		;ax�����[�v��

	.if	(ax!=0)
		;���[�v�A�h���X�̃`�F�b�N
		push	es
ifdef	SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;bx���߂���΃A�h���X
endif	;--------------------------------
ifdef	PS1	;------------------------
		add	ax,MUSIC_ADDRESSa	;bx�����[�v��A�h���X
		add	ax,bx			;
endif	;--------------------------------
		mov	bx,ax

		mov	cx,UCMOLS_LOOP_PTY	;�񐔃Z�b�g
		lea	di,[UCMOLS_LOOP_ADDRESS]
		push	cs			
		pop	es			;es:di �� �A�h���X
	repne	scasw
		pop	es
		.if	(ZERO?)
			.if	(cs:[UCMOLS_LOOP_Count]==1)	;
				call	UC_End
			.endif
			lea	DX,[UCDFF_M06_1]
			MOV	AH,09H		;
			INT	21H		;
			dec	cs:[UCMOLS_LOOP_Count]
			.if	(cs:[UCMOLS_LOOP_Count]>0)	;
				mov	bx,word ptr cs:[UCDFF_M07_Adr]	;�����W�����v��ɃS�[
				mov	byte ptr cs:[c_Command_EoC],00h	;�I���Ȃ����烊�Z�b�g
			.endif
		.else	;�������[�v��ƈႤ�ꍇ
			mov	byte ptr cs:[c_Command_EoC],00h	;�I���Ȃ����烊�Z�b�g
		.endif
	.else
		call	UC_End
	.endif

	RET			;RET���߂ŁA���ɖ߂�B�i�`�����l���I���j
UC_PermanentLoop	endp
ifdef	SPC	;------------------------
;===============================================================
;		�t���O�ɂ��W�����v�I�I
;===============================================================
.const
UC_ConditionalJump_M1	db	'/*L-Adr=0x$'
UC_ConditionalJump_M2	db	'*/:$'

.code
UC_ConditionalJump	proc	near	uses ax dx
	lea	DX,[UC_ConditionalJump_M1]
	MOV	AH,09H		;
	INT	21H		;

	MOV	AX,ES:[BX]		;
	inc	bx			;
	inc	bx			;

	sub	ax,cs:[UC_ADDER]	;ax���s�����΃A�h���X

	mov	word ptr cs:[UCDFF_M07_Adr],ax
	call	dat2hex16	;
	MOV	AH,09H		;
	INT	21H		;

	lea	DX,[UC_ConditionalJump_M2]
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_ConditionalJump	endp
endif	;--------------------------------
