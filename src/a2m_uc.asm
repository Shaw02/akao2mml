;************************************************************************
;*									*
;*		�t�l�l�k��						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		�t�l�l�k�����C�����[�`��			|
;---------------------------------------------------------------|
UN_MML_COMPAILE	proc	near	;
	CALL	UC_START	;�����ݒ�
	CALL	UC_MML_OUTPUT	;�l�l�k�o�͕�
	CALL	UC_Instrument	;����ݒ�
	RET			;RETURN
UN_MML_COMPAILE	endp
;---------------------------------------------------------------|
;		�����ϊ�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�^�C�g���A��ȁA�^�C���x�[�X�̕\��			|
;	�Q�D�f�[�^���						|
;		(1) �g�p�p�[�g��				|
;---------------------------------------------------------------|
MML2MID_HED:
	DB	'#title     ""',0dh,0ah
	DB	'#copyright "(c)SQUARE"',0dh,0ah
	db	0dh,0ah
;ifdef	ff8	;------------------------
;	DB	'#timebase 48',0dh,0ah
;	DB	0dh,0ah
;	DB	0dh,0ah
;	DB	'0A	EX x41,x10,x42,x12,{x40,x00,x7f,x00},xf7	BT4,4',0DH,0AH
;	DB	0dh,0ah
;	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
;	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	r1',0DH,0AH
;	DB	0dh,0ah
;	DB	'0A			C1 ',0Dh,0ah
;	DB	'1A			C2 ',0Dh,0ah
;	DB	'2A			C3 ',0Dh,0ah
;	DB	'3A			C4 ',0Dh,0ah
;	DB	'0B			C5 ',0Dh,0ah
;	DB	'1B			C6 ',0Dh,0ah
;	DB	'2B			C7 ',0Dh,0ah
;	DB	'3B			C8 ',0Dh,0ah
;	DB	'0C			C9 ',0Dh,0ah
;	DB	'1C			C10',0Dh,0Ah
;	DB	'2C			C11',0Dh,0ah
;	DB	'3C			C12',0Dh,0ah
;	DB	'0D			C13',0Dh,0ah
;	DB	'1D			C14',0Dh,0ah
;	DB	'2D			C15',0Dh,0ah
;	DB	'3D			C16',0Dh,0ah
;	DB	'0E	EExff,x21,1,1	C1 ',0Dh,0ah
;	DB	'1E	EExff,x21,1,1	C2 ',0Dh,0ah
;	DB	'2E	EExff,x21,1,1	C3 ',0Dh,0ah
;	DB	'3E	EExff,x21,1,1	C4 ',0Dh,0ah
;	DB	'0F	EExff,x21,1,1	C5 ',0Dh,0ah
;	DB	'1F	EExff,x21,1,1	C6 ',0Dh,0ah
;	DB	'2F	EExff,x21,1,1	C7 ',0Dh,0ah
;	DB	'3F	EExff,x21,1,1	C8 ',0Dh,0ah
;	DB	'0G	EExff,x21,1,1	C9 ',0Dh,0ah
;	DB	'1G	EExff,x21,1,1	C10',0Dh,0Ah
;	DB	'2G	EExff,x21,1,1	C11',0Dh,0ah
;	DB	'3G	EExff,x21,1,1	C12',0Dh,0ah
;	DB	'0H	EExff,x21,1,1	C13',0Dh,0ah
;	DB	'1H	EExff,x21,1,1	C14',0Dh,0ah
;	DB	'2H	EExff,x21,1,1	C15',0Dh,0ah
;	DB	'3H	EExff,x21,1,1	C16',0Dh,0ah
;	DB	0dh,0ah
;	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
;	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	v127	E127	p64	BR8'
;endif	;--------------------------------
	DB	24h
;
;MML2MID_HED0:						;�S�p�[�g��
;	db	'0z',0dh,0ah				;�����f�B�[�ɂ���ׁB
;	db	0dh,0ah,24h				;

MML2MID_HED1:
;ifdef	ff7	;------------------------
	db	'8z	@0	/*Instrument of percussion 1z*/'		,0dh,0ah,24h
;endif	;--------------------------------
;ifdef	ff8	;------------------------
;	db	'0z	EX x41,x10,x42,x12,{x40,x10+R,x15,0},xF7	J0'	,0dh,0ah,24h
;endif	;--------------------------------
MML2MID_HED2:
;ifdef	ff7	;------------------------
	db	'9z	@0	/*Instrument of percussion 2z*/'		,0dh,0ah,24h
;endif	;--------------------------------
;ifdef	ff8	;------------------------
;	db	'1z	EX x41,x10,x42,x12,{x40,x10+R,x15,1},xF7	H0,3	@0'	,0dh,0ah,24h
;endif	;--------------------------------
MML2MID_HED3:
	db	0dh,0ah
ifdef	ff7	;------------------------
	DB	'#include "define.mml"',0dh,0ah
endif	;--------------------------------
ifdef	ff8	;------------------------
	DB	'#include "init.mml"',0dh,0ah
endif	;--------------------------------
	db	0dh,0ah,24h		;���s�́Aff8mml�ł��o�͂���B

UC_START	proc	near
	MOV	DX,OFFSET MML2MID_HED	;
	MOV	AH,09H			;
	INT	21H			;

;ifdef	ff8	;------------------------
;	mov	dl,24h			;$�̕\��
;	mov	ah,02h			;
;	int	21h			;
;	MOV	DX,OFFSET MML2MID_HED0	;
;	MOV	AH,09H			;
;	INT	21H			;
;endif	;--------------------------------

	mov	dl,24h			;$�̕\��
	mov	ah,02h			;
	int	21h			;
	MOV	DX,OFFSET MML2MID_HED1	;
	MOV	AH,09H			;
	INT	21H			;

	mov	dl,24h			;$�̕\��
	mov	ah,02h			;
	int	21h			;
	MOV	DX,OFFSET MML2MID_HED2	;
	MOV	AH,09H			;
	INT	21H			;

	MOV	DX,OFFSET MML2MID_HED3	;
	MOV	AH,09H			;
	INT	21H			;
	

;---------------------------------------
;	�`�����l�����̃`�F�b�N

;	���̃A���S���Y���ł́A�ꕔ�̋ȂŌ��o�s�\�B
;	MOV	AX,ES:[MUSIC_ADDRESS]	;�g�p�p�[�g��
;	add	ax,MUSIC_ADDRESSa
;	SHR	AX,1			;AX��AX/2


;	dword pre es:[PARTF_ADDRESS"]�ɂ��āA
;	�r�b�g��"Hi"�̐����`�F�b�N����B���`�����l�����B
;	�����Ӂ�
;	�r�b�g����є�тɂȂ��Ă��Ă��A
;	�`�����l���f�[�^�̃w�b�_�[�͔�є�тɂȂ�Ȃ��B

	push	cx

	mov	cl,0			;Counter
	mov	ch,32			;�p�[�g���ő�

	mov	dx,0000h		;
	mov	ax,0001h		;dx:ax�ŁA32bit���Ƃ���B

UC_START_0:
	test	word ptr es:[PARTF_ADDRESS+0],ax
	jnz	UC_START_1		;
	test	word ptr es:[PARTF_ADDRESS+2],dx
	jnz	UC_START_1		;
	jmp	UC_START_2
UC_START_1:
	inc	cl
UC_START_2:
	shl	ax,1			;
	rcl	dx,1			;

	dec	ch
	jnz	UC_START_0

	MOV	CS:[UC_PART],cl		;

;	Debug�p
;	mov	ah,cl			;���o�`�����l�������o��
;	call	hex2asc8		;
;	mov	ah,09h			;
;	int	21h			;

	pop	cx
	RET				;
UC_START	endp
;---------------------------------------------------------------|
;		����ϊ�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�l�l�k�o�͕��ł������F�̃}�N����`���o��		|
;---------------------------------------------------------------|
UC_END_VOICE_ADD:
		DW	OFFSET UCE_VOICE_0A	
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
ifdef	ff8	;------------------------
		DW	OFFSET UCE_VOICE_0C	
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

UCE_VOICE_0A	DB	'0a		k127	y100,2	y101,0	y6,64	H1,3	@48',0dh,0ah,24h
UCE_VOICE_1A	DB	'1a		k127	y100,2	y101,0	y6,64	H0,3	@1 ',0dh,0ah,24h
UCE_VOICE_2A	DB	'2a		k127	y100,2	y101,0	y6,64	H0,3	@2 ',0dh,0ah,24h
UCE_VOICE_3A	DB	'3a		k127	y100,2	y101,0	y6,64	H0,3	@3 ',0dh,0ah,24h
UCE_VOICE_4A	DB	'4a		k127	y100,2	y101,0	y6,64	H0,3	@4 ',0dh,0ah,24h
UCE_VOICE_5A	DB	'5a		k127	y100,2	y101,0	y6,64	H0,3	@5 ',0dh,0ah,24h
UCE_VOICE_6A	DB	'6a		k127	y100,2	y101,0	y6,64	H0,3	@6 ',0dh,0ah,24h
UCE_VOICE_7A	DB	'7a		k127	y100,2	y101,0	y6,64	H0,3	@7 ',0dh,0ah,24h
UCE_VOICE_0B	DB	'0b		k127	y100,2	y101,0	y6,64	H0,3	@8 ',0dh,0ah,24h
UCE_VOICE_1B	DB	'1b		k127	y100,2	y101,0	y6,64	H0,3	@9 ',0dh,0ah,24h
UCE_VOICE_2B	DB	'2b		k127	y100,2	y101,0	y6,64	H0,3	@10',0dh,0ah,24h
UCE_VOICE_3B	DB	'3b		k127	y100,2	y101,0	y6,64	H0,3	@11',0dh,0ah,24h
UCE_VOICE_4B	DB	'4b		k127	y100,2	y101,0	y6,64	H0,3	@12',0dh,0ah,24h
UCE_VOICE_5B	DB	'5b		k127	y100,2	y101,0	y6,64	H0,3	@13',0dh,0ah,24h
UCE_VOICE_6B	DB	'6b		k127	y100,2	y101,0	y6,64	H0,3	@14',0dh,0ah,24h
UCE_VOICE_7B	DB	'7b		k127	y100,2	y101,0	y6,64	H0,3	@15',0dh,0ah,24h
ifdef	ff8	;------------------------
UCE_VOICE_0C	DB	'0c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_1C	DB	'1c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_2C	DB	'2c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_3C	DB	'3c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_4C	DB	'4c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_5C	DB	'5c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_6C	DB	'6c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_7C	DB	'7c		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_0D	DB	'0d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_1D	DB	'1d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_2D	DB	'2d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_3D	DB	'3d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_4D	DB	'4d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_5D	DB	'5d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_6D	DB	'6d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_7D	DB	'7d		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_0E	DB	'0e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_1E	DB	'1e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_2E	DB	'2e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_3E	DB	'3e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_4E	DB	'4e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_5E	DB	'5e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_6E	DB	'6e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_7E	DB	'7e		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_0F	DB	'0f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_1F	DB	'1f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_2F	DB	'2f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_3F	DB	'3f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_4F	DB	'4f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_5F	DB	'5f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_6F	DB	'6f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
UCE_VOICE_7F	DB	'7f		k127	y100,2	y101,0	y6,64	H0,3	@',24h
endif	;--------------------------------
UCE_VOICE_cr	db	0dh,0ah,24h

UC_Instrument	proc	near

	XOR	CX,CX			;CL��0

ifdef	ff7	;------------------------
	MOV	BX,OFFSET UC_VoiceExWork
endif	;--------------------------------
ifdef	ff8	;------------------------
	MOV	BX,VOICE_ADDRESS	;�]�����F���A�h���X
	MOV	DX,ES:[BX]		;
	.if	(dx==0000h)
		mov	cx,16
	.else
		add	bx,dx		;BX���]�����F���擪�A�h���X
	.endif

endif	;--------------------------------

	.while	(cx<16)

ifdef	ff7	;------------------------
		mov	ax,cs:[bx]		;AL�����F�o�^���
endif	;--------------------------------
ifdef	ff8	;------------------------
		mov	ax,es:[bx]		;AL�����F�o�^���
endif	;--------------------------------
		.break	.if	(ax==0ffffh)
		
		PUSH	BX			;

		MOV	AH,02H			;'$'�̕\��
		MOV	DL,24H			;
		INT	21H			;

		MOV	BX,OFFSET UC_END_VOICE_ADD
		ADD	BX,CX			;
		ADD	BX,CX			;
		MOV	DX,CS:[BX]		;DX���o�͂��ׂ�������̃A�h���X
		MOV	AH,09H			;
		INT	21H			;�o��

		POP	BX			;
		
		INC	BX			;
		INC	BX			;�A�h���X�C���N�������g
		INC	CX			;

	.endw


ifdef	ff8	;------------------------
	XOR	CX,CX			;CL��0
	MOV	BX,OFFSET UC_VOICE	;
UC_END_L2:

	.while	(cx<64)

		mov	al,cs:[bx]		;AL�����F�o�^���
		.break	.if	(al==0ffh)

		PUSH	BX			;
		push	ax

		MOV	AH,02H			;'$'�̕\��
		MOV	DL,24H			;
		INT	21H			;

		MOV	BX,OFFSET UC_END_VOICE_ADD
		ADD	BX,32			;
		ADD	BX,CX			;
		ADD	BX,CX			;
		MOV	DX,CS:[BX]		;DX���o�͂��ׂ�������̃A�h���X
		MOV	AH,09H			;
		INT	21H			;�o��

		pop	ax

		mov	ah,al
		call	hex2asc8
		MOV	AH,09H			;
		INT	21H			;�o��

		mov	dx,offset UCE_VOICE_cr
		MOV	AH,09H			;
		INT	21H			;�o��

		POP	BX			;

		INC	BX			;
		INC	CX			;

	.endw

endif	;--------------------------------

	mov	dx,offset UCE_VOICE_cr
	MOV	AH,09H			;
	INT	21H			;�o��

	RET
UC_Instrument	endp
;---------------------------------------------------------------|
;		�R�}���h�ϊ�					|
;---------------------------------------------------------------|
;	����							|
;		�P�R�}���h�����AMML�Ƀf�R�[�h���ďo�͂���	|
;	����							|
;		ds	��cs�ł��鎖				|
;		es:bx	�R�}���h�̃|�C���^			|
;	�Ԓl							|
;		es:bx	���̃R�}���h�̃|�C���^			|
;	�j��							|
;		�قڑS�Ẵ��W�X�^				|
;---------------------------------------------------------------|
;�R�����g�A�E�g�p
c_CommentOut0	db	'/*$'
c_CommentOut1	db	'*/$'

UCMO_TAI_OUTPUT:			;
	DB	'&$'			;

c_decode	proc	near

	local	UCMO_ComStartFlag:byte

	mov	UCMO_ComStartFlag,1

	;�R�}���h�ǂݍ���
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g

	SHL	AX,1			;
	PUSH	BX			;
	MOV	BX,OFFSET UC_DATA_ADDRESS
	ADD	BX,AX			;BX���ϊ����A�h���X�i�[�A�h���X
	MOV	DX,CS:[BX]		;DX���ϊ����A�h���X
	POP	BX			;

	;EoC����Ȃ��Ԃ�������A�������[�v�B
	.while	(byte ptr cs:[c_Command_EoC]==00h)

	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
	INC	BX			;
	XCHG	BX,DX			;

	.if	(al==00h)
		;�ϊ�����0x00����������A.break
		.break				;End

	.elseif	(al==10h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		CALL	HEX2ASC8		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==11h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		CALL	FH2A8			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==12h)
		PUSH	DX
		MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		INC	BX			;�|�C���^�C���N�������g
		CALL	HEX2ASC16		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==13h)
		PUSH	DX			;
		MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		INC	BX			;�|�C���^�C���N�������g
		CALL	FH2A16			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==20h)

		.if	((UCMO_ComStartFlag==1)&&(byte ptr es:[bx-1]<9ah)&&(byte ptr cs:[UC_Step_work]!=0))

			XCHG	BX,DX			;
			push	dx

			mov	dl,cs:[bx]		;1�����\��
			mov	ah,02h			;
			int	21h			;

			mov	dl,cs:[bx+1]		;
			.if	(dl=='+')
				inc	bx		;1
				mov	ah,02h		;
				int	21h		;�����\��
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
			MOV	AH,09H			;�\��
			INT	21H			;
			POP	DX			;

		.endif

		.repeat
			XCHG	BX,DX			;
			MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
			INC	BX			;
			XCHG	BX,DX			;
		.until	(al=='$')

	;���̉������A�^�C�t������������B
	.elseif	(al==21h)

		PUSH	BX			;
		PUSH	DX			;

		.repeat

		XOR	AX,AX			;
		MOV	AL,ES:[BX]		;�f�[�^�ǂݍ��݁@��
		MOV	DX,OFFSET UCMO_COMMAND_SIZE
		ADD	DX,AX			;
		XCHG	BX,DX			;
		MOV	AL,CS:[BX]		;�f�[�^�ǂݍ��݁@��͏��
		XCHG	BX,DX			;

		.if	(al==0)			;�O�F��͏I���i���� or �x���j
			.if	(byte ptr cs:[UC_portamento_D]!=0)
				mov	dl,'B'		;
				mov	ah,02h		;
				int	21h		;
				mov	dl,'S'		;
				mov	ah,02h		;
				int	21h		;
				mov	ax,0		;
				mov	ah,byte ptr cs:[UC_Detune_D]	;
				mov	byte ptr cs:[UC_portamento_D],0
				CALL	HEX2ASC8	;�o��
				MOV	AH,09H		;
				INT	21H		;�s�b�`�x���h�̃��Z�b�g
			.endif
			.break

		.elseif	(al==8)			;�W�F��͏I���iEnd of Channel�j
ifdef	ff7	;------------------------
			.break
endif	;--------------------------------
ifdef	ff8	;------------------------
			MOV	AX,ES:[BX]

			.if	(ax==006FEh)
				.break
			.elseif	((ax==004FEh)||(ax==01DFEh)||(ax==01EFEh)||(ax==01FFEh))
				add	bx,2
			.elseif	((ax==010FEh)||(ax==014FEh)||(ax==01CFEh))
				add	bx,3
			.elseif	((ax==007FEh)||(ax==009FEh))
				add	bx,5
			.else
				add	bx,4
			.endif
endif	;--------------------------------

		.elseif	(al==9)			;�X�F���̉����ƃ^�C�Ōq���B
			mov	dl,'&'		;
			mov	ah,02h		;
			int	21h		;
			.break

		.else				;���̑��̃P�[�X�́A���Z
			MOV	AH,0		;
			ADD	BX,AX		;

		.endif

		.until	0

		POP	DX			;
		POP	BX			;


	.elseif	(al==24h)
		;����1Byte���o�͂���B
		XCHG	BX,DX			;
		PUSH	DX			;
		MOV	AH,02H			;
		MOV	DL,CS:[BX]		;�\�����ǂݍ���
		INT	21H			;�\��
		INC	BX			;
		POP	DX			;
		XCHG	BX,DX			;

	.elseif	(al==0f0h)
		;�|�C���^��i�߂邾��
		INC	BX			;�|�C���^�C���N�������g

	.elseif	(al==0ffh)
		;����word�Ɏ������Address��call����B
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
		;���̑��̃R�[�h���o�Ă�����A���̃`�����l���̋tMML�I��
		mov	byte ptr cs:[c_Command_EoC],01h
		.break

	.endif

	mov	UCMO_ComStartFlag,0

	.endw

	ret
c_decode	endp
;---------------------------------------------------------------|
;		�l�l�k�o�͕�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�l�l�k�o��						|
;	�Q�D�g�p����Ă��鉹�F�ԍ��̋L��			|
;---------------------------------------------------------------|
UC_PART		DB	?			;�p�[�g��
UC_CR		DB	0Dh,0Ah,24h
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
UCMO_LOOP_OUTPUT:			;
	DB	'/*L1*/[$'		;
UCMO_LOOP_OUTPUT2:			;
	DB	'/*L2*/[$'		;

c_Command_EoC	db	?		;End of Channel

UC_MML_OUTPUT	proc	near		;proc �ɂ͂��Ȃ��B

;---------------------------------------
	MOV	CL,CS:[UC_PART]		;CL���g�p�p�[�g��
	MOV	CH,0			;CH�����݂̃p�[�g

	;�`�����l������do�`while()��
	.while	(cl!=ch)

	push	cx			;

	call	UC_INIT			;�ϐ�������

	XOR	DX,DX			;
	MOV	DL,CH			;
	SHL	DX,1			;
	PUSH	DX			;�A�h���X�v�Z�p
	SHL	DX,1			;
	ADD	DX,OFFSET UC_PART_ASC	;AX��UC_PART_ASC + CH * 4
	MOV	AH,09H			;
	INT	21H			;�p�[�g�\��

	POP	AX			;AX���p�[�g�ԍ����Q
	ADD	AX,MUSIC_ADDRESS	;AX���p�[�g���{AX
	MOV	BX,AX			;
	MOV	BX,ES:[BX]		;BX�����t�A�h���X�i���΁j
	add	bx,MUSIC_ADDRESSa	;
	ADD	BX,AX			;BX�����t�A�h���X

	CALL	UCMO_LOOP_SEARCH	;

;---------------------------------------

	mov	byte ptr cs:[c_Command_EoC],00h

	;"End of Channel"������܂ł�while()��	
	.while	(byte ptr cs:[c_Command_EoC]==00h)

		;�������[�v�̊J�n�_�ł��邩�`�F�b�N
		MOV	AX,CS:[UCMOLS_LOOP_ADDRESS]	;���[�v�A�h���X����H
		.if	(ax==bx)			;
			MOV	DX,OFFSET UCMO_LOOP_OUTPUT
			MOV	AH,09H			;
			INT	21H			;
		.endif
		MOV	AX,CS:[UCMOLS_LOOP_ADDRESS2]	;���[�v�A�h���X����H
		.if	((ax==bx)&&(cs:[UCMOLS_LOOP_flag]==01h))
			MOV	DX,OFFSET UCMO_LOOP_OUTPUT2
			MOV	AH,09H			;
			INT	21H			;
		.endif

		call	c_decode

	.endw

;---------------------------------------
;�`�����l���̏I��

	MOV 	DX,OFFSET UC_CR		;
	MOV	AH,09H	 		;
	INT	21H			;���s
	MOV	DX,OFFSET UC_CR		;
	MOV	AH,09H			;
	INT	21H			;���s

	POP	CX			;
	INC	CH			;�p�[�g�ԍ��C���N�������g

	.endw

;---------------------------------------
c_Command_END:				;
	RET				;RETURN
UC_MML_OUTPUT	endp
;---------------------------------------------------------------|
;		�������[�v���					|
;---------------------------------------------------------------|
;	����							|
;		�������[�v�A�h���X����������B			|
;---------------------------------------------------------------|
UCMOLS_LOOP_msg1	DB	'/*Loop=$'
UCMOLS_LOOP_msg2	DB	'*/$'

UCMOLS_START_ADDRESS	DW	?
UCMOLS_LOOP_ADDRESS	DW	0000H
UCMOLS_LOOP_ADDRESS2	DW	0000H
UCMOLS_LOOP_flag	DB	00
UCMOLS_LOOP_flag1	DB	00
UCMOLS_LOOP_flag2	DB	00
UCMOLS_LOOP_bxwork	dw	0000h

UCMO_LOOP_SEARCH	proc	near
	PUSH	BX				;
	PUSH	CX				;���W�X�^�ۑ�

;	�f�o�b�O�p
	mov	dx,offset UCMOLS_LOOP_msg1
	mov	ah,09h
	int	21h

UCMOL_0:MOV	AX,BX				;
	MOV	CS:[UCMOLS_START_ADDRESS],AX	;�擪�A�h���X�ۑ�
	XOR	AX,AX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;���[�v�A�h���X���Z�b�g
	mov	byte ptr cs:[UCMOLS_LOOP_flag],00h
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],00h
	mov	byte ptr cs:[UCMOLS_LOOP_flag2],00h

UCMOL_1:
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ��݁@��

	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	MOV	AH,AL			;AH���R�}���h
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�f�[�^�ǂݍ��݁@��͏��
	XCHG	BX,DX			;
	CMP	AL,0			;
	JZ	UCMOL_KEY		;
	CMP	AL,9			;
	JZ	UCMOL_KEY		;
	JMP	UCMOL_2			;
UCMOL_KEY:

	MOV	AL,1			;�E0F?h�ȊO�̃R�}���h
	CMP	AH,0F0h			;AL��1
	JC	UCMOL_K			;�E0F?h�̃R�}���h
	MOV	AL,2			;AL��2
UCMOL_K:CMP	AH,0A0h			;�E0A0h�̃R�}���h
	JNZ	UCMOL_2			;�p�[�g�I��
	JMP	UCMOL_EE		;

UCMOL_2:
	CMP	AL,8			;
	JNZ	UCMOL_3			;
ifdef	ff7	;------------------------
	mov	dx,bx			;
	ADD	BX,1			;
	MOV	AX,ES:[BX]		;
	ADD	bx,2			;

	jmp	UCMOL_E0

;	TEST	AX,AX			;
;	JZ	UCMOL_EE		;If AX=0 Then Return
;	ADD	AX,BX			;AX�����[�v��A�h���X
;	MOV	BX,AX			;BX��AX
;	jmp	UCMOL_E3		;

endif	;--------------------------------
ifdef	ff8	;------------------------
	MOV	AX,ES:[BX]		;
	CMP	AX,007FEH		;
	JZ	UCMOL_7			;
	CMP	AX,006FEH		;
	JZ	UCMOL_E			;

	cmp	ax,004FEh		;
	jz	UCMOL_2_2		;
	cmp	ax,01DFEh		;
	jz	UCMOL_2_2		;
	cmp	ax,01EFEh		;
	jz	UCMOL_2_2		;
	cmp	ax,01fFEh		;
	jz	UCMOL_2_2		;

	cmp	ax,010FEh		;
	jz	UCMOL_2_3		;
	cmp	ax,014FEh		;
	jz	UCMOL_2_3		;
	cmp	ax,01CFEh		;
	jz	UCMOL_2_3		;

	cmp	ax,009FEh		;
	jz	UCMOL_2_5		;

	JMP	UCMOL_2_4		;

UCMOL_2_2:				;
	ADD	BX,2			;
	JMP	UCMOL_1			;

UCMOL_2_3:				;
	ADD	BX,3			;
	JMP	UCMOL_1			;

UCMOL_2_4:				;
	ADD	BX,4			;
	JMP	UCMOL_1			;

UCMOL_2_5:				;
	ADD	BX,5			;
	JMP	UCMOL_1			;
endif	;--------------------------------


UCMOL_3:				;
	MOV	AH,0			;
	ADD	BX,AX			;
	JMP	UCMOL_1			;
UCMOL_7:				;
	mov	byte ptr cs:[UCMOLS_LOOP_flag],01h
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],01h
	mov	byte ptr cs:[UCMOLS_LOOP_flag2],01h
	add	bx,5			;
	jmp	UCMOL_1			;
UCMOL_E:				;
	mov	ax,bx
	mov	word ptr cs:[UCMOLS_LOOP_bxwork],ax
	MOV	DX,BX				;DX��FE06h�R�}���h�̃A�h���X
	ADD	BX,2				;
	MOV	AX,ES:[BX]			;

UCMOL_E0:
	TEST	AX,AX				;
	JZ	UCMOL_EE			;If AX=0 Then Return
	ADD	AX,BX				;AX�����[�v��A�h���X
	MOV	BX,AX				;BX��AX
	CMP	DX,AX				;AX < DX ?
	JNC	UCMOL_E1			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E1:
	MOV	DX,CS:[UCMOLS_START_ADDRESS]	;DX���擪�A�h���X
	CMP	AX,DX				;AX <= DX
	JNC	UCMOL_E2			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E2:
	cmp	byte ptr cs:[UCMOLS_LOOP_flag1],01h	;
	jnz	UCMOL_E3			;
	MOV	AX,BX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS2],AX	;���[�v�A�h���X���Z�b�g
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],00h	;

	mov	ax,word ptr cs:[UCMOLS_LOOP_bxwork]
	mov	bx,ax				;
	add	bx,4				;
	JMP	UCMOL_1				;
UCMOL_E3:
	MOV	AX,BX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;���[�v�A�h���X���Z�b�g
UCMOL_EE:


;	�f�o�b�O�p
	MOV	ax,CS:[UCMOLS_LOOP_ADDRESS]	;
	call	hex2asc16
	mov	ah,09h
	int	21h

	mov	dl,2ch
	mov	ah,02
	int	21h

	MOV	ax,CS:[UCMOLS_LOOP_ADDRESS2]	;
	call	hex2asc16
	mov	ah,09h
	int	21h

	mov	dx,offset UCMOLS_LOOP_msg2
	mov	ah,09h
	int	21h

	POP	CX			;
	POP	BX			;
	RET
UCMO_LOOP_SEARCH	endp
