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
ifdef	ff8	;------------------------
	DB	'#timebase 48',0dh,0ah
	DB	0dh,0ah
	DB	0dh,0ah
	DB	'0A	EX x41,x10,x42,x12,{x40,x00,x7f,x00},xf7	BT4,4',0DH,0AH
	DB	0dh,0ah
	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	r1',0DH,0AH
	DB	0dh,0ah
	DB	'0A			C1 ',0Dh,0ah
	DB	'1A			C2 ',0Dh,0ah
	DB	'2A			C3 ',0Dh,0ah
	DB	'3A			C4 ',0Dh,0ah
	DB	'0B			C5 ',0Dh,0ah
	DB	'1B			C6 ',0Dh,0ah
	DB	'2B			C7 ',0Dh,0ah
	DB	'3B			C8 ',0Dh,0ah
	DB	'0C			C9 ',0Dh,0ah
	DB	'1C			C10',0Dh,0Ah
	DB	'2C			C11',0Dh,0ah
	DB	'3C			C12',0Dh,0ah
	DB	'0D			C13',0Dh,0ah
	DB	'1D			C14',0Dh,0ah
	DB	'2D			C15',0Dh,0ah
	DB	'3D			C16',0Dh,0ah
	DB	'0E	EExff,x21,1,1	C1 ',0Dh,0ah
	DB	'1E	EExff,x21,1,1	C2 ',0Dh,0ah
	DB	'2E	EExff,x21,1,1	C3 ',0Dh,0ah
	DB	'3E	EExff,x21,1,1	C4 ',0Dh,0ah
	DB	'0F	EExff,x21,1,1	C5 ',0Dh,0ah
	DB	'1F	EExff,x21,1,1	C6 ',0Dh,0ah
	DB	'2F	EExff,x21,1,1	C7 ',0Dh,0ah
	DB	'3F	EExff,x21,1,1	C8 ',0Dh,0ah
	DB	'0G	EExff,x21,1,1	C9 ',0Dh,0ah
	DB	'1G	EExff,x21,1,1	C10',0Dh,0Ah
	DB	'2G	EExff,x21,1,1	C11',0Dh,0ah
	DB	'3G	EExff,x21,1,1	C12',0Dh,0ah
	DB	'0H	EExff,x21,1,1	C13',0Dh,0ah
	DB	'1H	EExff,x21,1,1	C14',0Dh,0ah
	DB	'2H	EExff,x21,1,1	C15',0Dh,0ah
	DB	'3H	EExff,x21,1,1	C16',0Dh,0ah
	DB	0dh,0ah
	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	v127	E127	p64	BR8'
endif	;--------------------------------
	DB	24h

MML2MID_HED0:						;�S�p�[�g��
	db	'0z',0dh,0ah				;�����f�B�[�ɂ���ׁB
	db	0dh,0ah,24h				;

MML2MID_HED1:
ifdef	ff7	;------------------------
	db	'8z	@0	/*Instrument of percussion 1z*/'		,0dh,0ah,24h
endif	;--------------------------------
ifdef	ff8	;------------------------
	db	'0z	EX x41,x10,x42,x12,{x40,x10+R,x15,0},xF7	J0'	,0dh,0ah,24h
endif	;--------------------------------
MML2MID_HED2:
ifdef	ff7	;------------------------
	db	'9z	@0	/*Instrument of percussion 2z*/'		,0dh,0ah,24h
endif	;--------------------------------
ifdef	ff8	;------------------------
	db	'1z	EX x41,x10,x42,x12,{x40,x10+R,x15,1},xF7	H0,3	@0'	,0dh,0ah,24h
endif	;--------------------------------
MML2MID_HED3:
ifdef	ff7	;------------------------
	db	0dh,0ah
	DB	'#include "define.mml"',0dh,0ah
endif	;--------------------------------
	db	0dh,0ah,24h		;���s�́Aff8mml�ł��o�͂���B

UC_START	proc	near
	MOV	DX,OFFSET MML2MID_HED	;
	MOV	AH,09H			;
	INT	21H			;

ifdef	ff8	;------------------------
	mov	dl,24h			;$�̕\��
	mov	ah,02h			;
	int	21h			;
	MOV	DX,OFFSET MML2MID_HED0	;
	MOV	AH,09H			;
	INT	21H			;
endif	;--------------------------------

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

UCE_VOICE_0A	DB	'0a		k127	y100,2	y101,0	y6,64	H0,2	@48',0dh,0ah,24h
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
	MOV	BX,VOICE_ADDRESS	;�]�����F���A�h���X
	cmp	bx,0
	JZ	UC_END_L1		;����������I���B
	MOV	DX,ES:[BX]		;
	CMP	DX,0000H		;�]�����F�L��H
	JZ	UC_END_L1		;����������I���B
	ADD	BX,DX			;BX���]�����F���擪�A�h���X
UC_END_L0:
	MOV	AX,ES:[BX]		;�ǂݍ���
	CMP	AX,0FFFFH		;�Ō�H
	JZ	UC_END_L1		;
	cmp	cx,16			;
	jz	UC_END_L1		;16�ϊ�������Ō�
	
	PUSH	BX			;
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'�̕\��
	MOV	DL,24H			;
	INT	21H			;
	MOV	DX,CS:[BX]		;DX���o�͂��ׂ�������̃A�h���X
	MOV	AH,09H			;
	INT	21H			;�o��
	POP	BX			;
	
	INC	BX			;
	INC	BX			;�A�h���X�C���N�������g
	INC	CX			;
	JMP	UC_END_L0		;
UC_END_L1:

ifdef	ff8	;------------------------
	XOR	CX,CX			;CL��0
	MOV	BX,OFFSET UC_VOICE	;
UC_END_L2:
	MOV	AL,CS:[BX]		;AL�����F�o�^���
	CMP	AL,0FFh			;���I������
	JZ	UC_END_LE		;
	cmp	cx,64			;
	jz	UC_END_L1		;64�ϊ�������Ō�

	PUSH	BX			;
	push	ax
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,32			;
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'�̕\��
	MOV	DL,24H			;
	INT	21H			;
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
	JMP	UC_END_L2		;
endif	;--------------------------------

UC_END_LE:
	mov	dx,offset UCE_VOICE_cr
	MOV	AH,09H			;
	INT	21H			;�o��

	RET
UC_Instrument	endp
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
;
;			�������
;	0�@	( Search End )
;	1-4	Address Add
;	8	If 0FE06h THEN Search END
;	9	Output '&$' ( and Search END )
;
UCMO_COMMAND_SIZE:				;
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;00h-0Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;10h-1Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;20h-2Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;30h-3Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;40h-4Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;50h-5Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;60h-6Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;70h-7Fh
	DB	0,0,0,0, 9,9,9,9, 9,9,9,9, 9,9,9,0	;80h-8Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,1,1, 1,1,1,1	;90h-9Fh
	DB	0,2,2,2, 3,2,1,1, 2,3,2,3, 2,2,2,2	;A0h-AFh
	DB	3,2,2,1, 4,2,1,2, 4,2,1,2, 3,2,1,2	;B0h-BFh
	DB	2,2,1,1, 1,1,1,1, 1,2,1,1, 1,1,1,1	;C0h-CFh
	DB	1,1,2,2, 1,1,1,1, 2,2,3,1, 2,3,3,3	;D0h-DFh
ifdef	ff7	;------------------------
	DB	1,1,1,1, 1,1,1,1, 3,4,3,4, 3,1,8,4	;E0h-EFh
	DB	4,4,2,1, 3,1,2,3, 2,2,1,1, 3,3,3,1	;F0h-FFh
endif	;--------------------------------
ifdef	ff8	;------------------------
	DB	1,1,1,1, 1,1,3,1, 1,1,1,1, 1,1,1,1	;E0h-EFh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 9,0,8,1	;F0h-FFh
endif	;--------------------------------
UCMO_ComStartFlag:
	db	0
UCMO_TAI_OUTPUT:			;
	DB	'&$'			;
UCMO_LOOP_OUTPUT:			;
	DB	'/*L1*/[$'		;
UCMO_LOOP_OUTPUT2:			;
	DB	'/*L2*/[$'		;


UC_MML_OUTPUT	proc	near		;
	MOV	CL,CS:[UC_PART]		;CL���g�p�p�[�g��
;	mov	cl,32
	MOV	CH,0			;CH�����݂̃p�[�g

UCMO_L00:				;
	push	cx			;

	call	UC_INIT			;�ϐ�������

;	mov	dx,0000h		;
;	mov	ax,0001h		;dx:ax�ŁA32bit���Ƃ���B

UCMO_L00_0:				;���Y�p�[�g�����邩�`�F�b�N
;	cmp	ch,0			;
;	jz	UCMO_L00_1		;
;	shl	ax,1			;
;	rcl	dx,1			;
;	dec	ch			;cx�̐��������[�v
;	jmp	UCMO_L00_0		;

UCMO_L00_1:
;	pop	cx			;
;	PUSH	CX			;
;	test	word ptr es:[PARTF_ADDRESS+0],ax
;	jnz	UCMO_L00_2		;
;	test	word ptr es:[PARTF_ADDRESS+2],dx
;	jnz	UCMO_L00_2		;
;	jmp	UCMO_LQQ		;����������A���̃p�[�g�փS�[

UCMO_L00_2:
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
UCMO_L01:
	mov	byte ptr cs:[UCMO_ComStartFlag],1

	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS]	;���[�v�A�h���X���Z�b�g
	CMP	AX,BX				;����H
	JNZ	UCMO_L01_1			;
	MOV	DX,OFFSET UCMO_LOOP_OUTPUT	;
	MOV	AH,09H				;
	INT	21H				;
UCMO_L01_1:
	cmp	cs:[UCMOLS_LOOP_flag],01h	;
	jnz	UCMO_L01_2
	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS2]	;���[�v�A�h���X���Z�b�g
	CMP	AX,BX				;����H
	JNZ	UCMO_L01_2			;
	MOV	DX,OFFSET UCMO_LOOP_OUTPUT2	;
	MOV	AH,09H				;
	INT	21H				;
UCMO_L01_2:
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g
	SHL	AX,1			;
	PUSH	BX			;
	MOV	BX,OFFSET UC_DATA_ADDRESS
	ADD	BX,AX			;BX���ϊ����A�h���X�i�[�A�h���X
	MOV	DX,CS:[BX]		;DX���ϊ����A�h���X
	POP	BX			;
	jmp	UCMO_L03
UCMO_L02:
	mov	byte ptr cs:[UCMO_ComStartFlag],0
UCMO_L03:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
	INC	BX			;
	XCHG	BX,DX			;

	CMP	AL,00h			
	JZ	UCMO_L01		
UCML_L10:
	CMP	AL,10h			
	JNZ	UCMO_L11		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g
	CALL	HEX2ASC8		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L11:
	CMP	AL,11h			
	JNZ	UCMO_L12		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g
	CALL	FH2A8			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L12:
	CMP	AL,12h			
	JNZ	UCMO_L13		
	PUSH	DX
	MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g
	INC	BX			;�|�C���^�C���N�������g
	CALL	HEX2ASC16		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L13:
	CMP	AL,13h			
	JNZ	UCMO_L20		
	PUSH	DX			;
	MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g
	INC	BX			;�|�C���^�C���N�������g
	CALL	FH2A16			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L20:
	CMP	AL,20h			;
	JNZ	UCMO_L21		;

	cmp	byte ptr cs:[UCMO_ComStartFlag],1
	jnz	UCMO_L20_2

	;----------------------------------------
	mov	ah,es:[bx-1]		;�R�}���h��0x9A������������
	cmp	ah,9ah			;
	jnc	UCMO_L20_2		;

	mov	ah,byte ptr cs:[UC_Step_work]
	cmp	ah,0			;�����ݒ�̗L���`�F�b�N
	jz	UCMO_L20_2		;

	XCHG	BX,DX			;
	push	dx

	mov	dl,cs:[bx]		;1�����\��
	mov	ah,02h			;
	int	21h			;

	mov	dl,cs:[bx+1]		;
	cmp	dl,'+'			;
	jnz	UCMO_L20_sharp		;
	inc	bx			;1�����\��
	mov	ah,02h			;
	int	21h			;
UCMO_L20_sharp:
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

	jmp	UCMO_L20_1
	;----------------------------------------
UCMO_L20_2:
	PUSH	DX			;
	MOV	AH,09H			;�\��
	INT	21H			;
	POP	DX			;
UCMO_L20_1:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
	INC	BX			;
	XCHG	BX,DX			;
	CMP	AL,'$'			;
	JNZ	UCMO_L20_1		;
	JMP	UCMO_L02		;
UCMO_L21:
	CMP	AL,21h			;
	JZ	UCMO_L21_0		;
	JMP	UCMO_L24		;
UCMO_L21_0:				;
	PUSH	BX			;
	PUSH	DX			;
UCMO_L21_1:				;
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ��݁@��
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�f�[�^�ǂݍ��݁@��͏��
	XCHG	BX,DX			;
	CMP	AL,0			;�O�F��͏I��
	JZ	UCMO_L21_e_reset		;
	CMP	AL,9			;�X�F���̉����ƃ^�C�Ōq���B
	JNZ	UCMO_L21_2		;
	MOV	DX,OFFSET UCMO_TAI_OUTPUT
	MOV	AH,09H			;
	INT	21H			;
	JMP	UCMO_L21_E		;
UCMO_L21_e_reset:			;�\�t�g�G���x���[�v���Z�b�g

	cmp	byte ptr cs:[UC_portamento_D],0
	jz	UCMO_L21_e_reset_01		;
	mov	dl,'B'				;
	mov	ah,02h				;
	int	21h				;
	mov	dl,'S'				;
	mov	ah,02h				;
	int	21h				;
	mov	ax,0				;
	mov	ah,byte ptr cs:[UC_Detune_D]	;
;	add	ah,byte ptr cs:[UC_portamento_D]
	mov	byte ptr cs:[UC_portamento_D],0
	CALL	HEX2ASC8			;�o��
	MOV	AH,09H				;
	INT	21H				;�s�b�`�x���h�̃��Z�b�g
UCMO_L21_e_reset_01:			;
	jmp	UCMO_L21_E		;


UCMO_L21_2:				;
	CMP	AL,8			;
	JNZ	UCMO_L21_3		;8����Ȃ�������Abx���Z�����ցB
ifdef	ff7	;------------------------
	jmp	UCMO_L21_E		;ff7�́A�������ŏI���
endif	;--------------------------------
ifdef	ff8	;------------------------
	MOV	AX,ES:[BX]		;
	CMP	AX,006FEH		;
	JZ	UCMO_L21_E		;

	cmp	ax,004FEh		;
	jz	UCMO_L21_2_2		;
	cmp	ax,01fFEh		;
	jz	UCMO_L21_2_2		;

	cmp	ax,014FEh		;
	jz	UCMO_L21_2_3		;

	cmp	ax,007FEh		;
	jz	UCMO_L21_2_5		;
	cmp	ax,009FEh		;
	jz	UCMO_L21_2_5		;

	JMP	UCMO_L21_2_4		;

UCMO_L21_2_2:				;
	ADD	BX,2			;04h,1fh
	JMP	UCMO_L21_1		;

UCMO_L21_2_3:				;14h
	ADD	BX,3			;
	JMP	UCMO_L21_1		;

UCMO_L21_2_4:				;other
	ADD	BX,4			;
	JMP	UCMO_L21_1		;

UCMO_L21_2_5:				;07h,09h
	ADD	BX,5			;
	JMP	UCMO_L21_1		;
endif	;--------------------------------



UCMO_L21_3:				;
	MOV	AH,0			;
	ADD	BX,AX			;
	JMP	UCMO_L21_1		;
UCMO_L21_E:				;
	POP	DX			;
	POP	BX			;
	JMP	UCMO_L02		;
UCMO_L24:
	CMP	AL,24h			;
	JNZ	UCMO_LF0		;
	XCHG	BX,DX			;
	PUSH	DX			;
	MOV	AH,02H			;
	MOV	DL,CS:[BX]		;�\�����ǂݍ���
	INT	21H			;�\��
	INC	BX			;
	POP	DX			;
	XCHG	BX,DX			;
	JMP	UCMO_L02		;
UCMO_LF0:
	CMP	AL,0F0h			
	JNZ	UCMO_LFF		
	INC	BX			;�|�C���^�C���N�������g
	JMP	UCMO_L02		;
UCMO_LFF:
	CMP	AL,0FFh			;
	JNZ	UCMO_LQQ		;

	PUSH	DX			;
	PUSH	BX			;
	MOV	BX,DX			;
	MOV	DX,CS:[BX]		;
	POP	BX			;
	CALL	DX			;
	POP	DX			;

	INC	DX			;
	INC	DX			;
	JMP	UCMO_L02		;
UCMO_LQQ:
	MOV 	DX,OFFSET UC_CR		;
	MOV	AH,09H	 		;
	INT	21H			;���s
	MOV	DX,OFFSET UC_CR		;
	MOV	AH,09H			;
	INT	21H			;���s

	POP	CX			;
	INC	CH			;�p�[�g�ԍ��C���N�������g
	CMP	CL,CH			;�p�[�g�I���H
	JZ	UCMO_END		;
	JMP	UCMO_L00		;
UCMO_END:				;
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
	ADD	BX,1			;
	MOV	AX,ES:[BX]		;
	ADD	bx,2			;
	TEST	AX,AX			;
	JZ	UCMOL_EE		;If AX=0 Then Return
	ADD	AX,BX			;AX�����[�v��A�h���X
	MOV	BX,AX			;BX��AX
	jmp	UCMOL_E3		;
endif	;--------------------------------
ifdef	ff8	;------------------------
	MOV	AX,ES:[BX]		;
	CMP	AX,007FEH		;
	JZ	UCMOL_7			;
	CMP	AX,006FEH		;
	JZ	UCMOL_E			;

	cmp	ax,004FEh		;
	jz	UCMOL_2_2		;
	cmp	ax,01fFEh		;
	jz	UCMOL_2_2		;

	cmp	ax,014FEh		;
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
