;|==============================================================|
;|	�e�h�m�`�k�@�e�`�m�s�`�r�x�@VIII			|
;|		�t�l�l�k�R���p�C��				|
;|								|
;|				Programmed By			|
;|					Sound Tester:774	|
;|								|
;===============================================================|


.186
.model	tiny,c

.code
;=======================================================================|
;				Start Up				|
;=======================================================================|
	.startup
ff8mml_:	
	lea	AX,[CEND + BSTACK]	;
	MOV	SP,AX			;

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;�Z�O�����g�����ււցB
	MOV	SS,AX			;

	cld

	call	_main
COMEND:
	.exit

;=======================================================================|
;				define					|
;=======================================================================|
;
;	�t�l�l�k�ϊ����
;
BSTACK		EQU	0400H		;�X�^�b�N�o�b�t�@
;
;		�R���p�C�����
;
D_Debug		DB	00h		;�f�o�b�O�t���O
segAKAO_File	dw	0		;���t�@�C���p
hAKAO_File	dw	0		;���t�@�C���p
;=======================================================================|
;				Start					|
;=======================================================================|
;�E�ėp�T�u���[�`��
include	sub_dos.asm
include	sub_cnv.asm

;�E�Q�[�����̐ݒ�
include	def_ff4.asm		;SPC FINAL FANTASY 4
include	def_ff5.asm		;SPC FINAL FANTASY 4
include	def_ff6.asm		;SPC FINAL FANTASY 5
include	def_rs1.asm		;SPC Romancing Saga 1
include	def_rs2.asm		;SPC Romancing Saga 2
include	def_rs3.asm		;SPC Romancing Saga 3
include	def_ps1.asm		;PS  common
include	def_com.asm		;General

include	def_sfc.asm		;SPC general (������)
include	def_ps.asm		;PS  general (������)

;�E�t�R���p�C���@���C��
include	a2m_uc.asm

;************************************************************************
;*									*
;*		���C�����[�`��						*
;*									*
;************************************************************************
;===============================================================|
;								|
;		�I�v�V��������					|
;								|
;===============================================================|
OP_FLAG_DEBUG	DB	0			;�f�o�b�O�L��
OP_FLAG_HELP	DB	0			;�I�v�V�����t���O�|�w���v�\��
OP_FLAG_FILE	DB	085H	DUP(00H)	;�t�@�C�����i�P�Q�W�{�S�������j
OP_HELP	DB	0DH,0AH
ifdef	SPC	;------------------------
	DB	"AKAO (SQUARE SFC SOFT)  UnMML Compiler for MML2MID",0DH,0AH
endif	;--------------------------------
ifdef	PS1	;------------------------
	db	"AKAO (SQUARE SPlaystation's SOFT)  UnMML Compiler for MML2MID",0DH,0AH
endif	;--------------------------------
	DB	"		Programmed by  ����������midi�ϊ�����X����889",0DH,0AH
	db	"		Special Thanks    ���X���̏Z�l�B",0DH,0AH
	DB	0DH,0AH
	DB	ProjectName," [/?] [filename1] [>filename2]",0DH,0AH
	DB	0DH,0AH
ifdef	SPC	;------------------------
	DB	"   filename1	Source SPC filename",0DH,0AH
endif	;--------------------------------
ifdef	PS1	;------------------------
	DB	"   filename1	Source SND filename",0DH,0AH
endif	;--------------------------------
	DB	"  >filename2	Output MML filename",0DH,0AH
	DB	"  /D		Set the debug mode (0 to 255)",0DH,0AH
	db	"  mode		 bit0(+  1) : Do not using repeat command : [, :, ]",0DH,0AH
ifdef	FF8	;------------------------
	db	"		 bit2(+  2) : Instrument no out same as VGMtrans.",0DH,0AH
endif	;--------------------------------
;	db	"		 bit2(+  4) : reserve",0DH,0AH
;	db	"		 bit3(+  8) : reserve",0DH,0AH
;	db	"		 bit4(+ 16) : reserve",0DH,0AH
;	db	"		 bit5(+ 32) : reserve",0DH,0AH
;	db	"		 bit6(+ 64) : reserve",0DH,0AH
;	db	"		 bit7(+128) : �q�b�|���n�j���|�[��",0DH,0AH
	db	"		 default = 0",0dh,0ah
	DB	"  /?		Display help",0DH,0AH
	DB	024H
;****************************************************************
;*		�I�v�V�����t���O����				*
;****************************************************************
OPTION_ERROR_MSG	db	'�I�v�V�������s���ł��B',0dh,0ah,24h
OPTION_ERROR	proc	near
	lea	dx,[OPTION_ERROR_MSG]
	mov	ah,09h
	int	21h
	jmp	COMEND
OPTION_ERROR	endp
;****************************************************************
;*		�I�v�V�����t���O����				*
;****************************************************************
;	�g�p���W�X�^						*
;	ds:si	�I�v�V����������A�h���X			*
;	es:di	�t���O�ʒu					*
;	AX	�ėp						*
;	CX	�I�v�V����������ŏI�A�h���X�{�P		*
;****************************************************************
OPTION_FLAG	proc	near	uses ax bx cx dx di si ds es

	MOV	AX,CS			;
	MOV	DS,AX			;DS��CS
	MOV	ES,AX			;DS��CS

	MOV	ax,0000H		;
	MOV	si,0080H		;BX���I�v�V����������擪�A�h���X�|�P
	lodsb				;AL���I�v�V����������
	ADD	ax,si			;
	MOV	cx,ax			;CX���I�[�v�V����������ŏI�Ԓn

	.while	(cx>=si)

	lodsb

	.if	(al<21h)
		.continue

	.elseif	((al=='/')||(al=='-'))
		.if	(cx<si)
			JMP	OPTION_ERROR		;��������G���[
		.endif

		lodsb

		.if	((al=='h')||(al=='H')||(al=='?'))
			MOV	AH,0FFh			;�t���O���ėp�B
			lea	di,[OP_FLAG_HELP]	;�t���O�A�h���X
			call	OP_FLAG_SET
		.elseif	((al=='d')||(al=='D'))
			lea	di,[OP_FLAG_DEBUG]
			call	OP_Number_SET
		.else
			JMP	OPTION_ERROR		;����������G���[
		.endif

	.else
		lea	di,[OP_FLAG_FILE]	;�t�@�C��
		call	OP_FILE_SET
	.endif

	.endw

	ret
OPTION_FLAG	endp
;----------------------------------------------------------------
OP_Number_SET	proc	near	uses ax bx dx
	.repeat
		mov	dx,si			;DX���I�v�V�����A�h���X
		.if	(cx<dx)
			JMP	OPTION_ERROR	;����������G���[
		.endif
		CALL	ASC2HEX8		;AH��������i���l�j
		mov	si,bx
	.until	(!(Carry?))
	call	OP_FLAG_SET
	ret
OP_Number_SET	endp
;----------------------------------------------------------------
OP_FLAG_SET	proc	near
	mov	[di],ah			;�t���O�Z�b�g
	ret
OP_FLAG_SET	endp
;----------------------------------------------------------------
OP_FILE_SET	proc	near	uses ax

	local	dotFlag:BYTE

	mov	al,[di]
	.if	(al!=0)
		JMP	OPTION_ERROR	;�t�@�C�������Q�����Ă���悧�`
	.endif

	dec	si			;�|�C���^��߂�
	mov	dotFlag,0

	.while	(cx>=si)
		lodsb
		.if	(al<21h)
			dec	si
			.break		;21h������������I���B
		.elseif	(al=='.')
			mov	dotFlag,1
		.endif
		stosb
	.endw

	.if	(dotFlag==0)		;�g���q����`����Ȃ��������`
		mov	al,'.'
		stosb
ifdef	SPC	;------------------------
		mov	al,'S'		;".SPC"�ɂ���B�ꉞ�A�啶���ŁB
		stosb	
		mov	al,'P'
		stosb
		mov	al,'C'
		stosb
endif	;--------------------------------
ifdef	PS1	;------------------------
		mov	al,'S'		;".SND"�ɂ���B�ꉞ�A�啶���ŁB
		stosb
		mov	al,'N'
		stosb
		mov	al,'D'
		stosb
endif	;--------------------------------
	.endif

	mov	al,0			;
	stosb
	mov	al,24h
	stosb

	ret
OP_FILE_SET	endp
;****************************************************************
OPTION_DEBUG	proc	near	uses ax	;
	MOV	AL,CS:[OP_FLAG_DEBUG]	;
	MOV	CS:[D_Debug],AL		;�ݒ�
	RET				;RETURN
OPTION_DEBUG	endp			;
;****************************************************************
OPTION_HELP	proc	near
	lea	DX,[OP_HELP]		;�\��
	MOV	AH,09H			;
	INT	21H			;
	JMP	COMEND			;�v���O�����I��
OPTION_HELP	endp			;
;****************************************************************
OPTION_FILE	proc	near	uses ax dx

;���t�@�C���̃I�[�v��
	MOV	al,0			;Read mode
	lea	dx,[OP_FLAG_FILE]	;DX���t�@�C�����A�h���X
	call	File_Open		;
	mov	word ptr cs:[hAKAO_File],ax

;���t�@�C���̃��[�h
	PUSH	DS			;
	MOV	ax,word ptr CS:[hAKAO_File]
	push	word ptr CS:[segAKAO_File]
	pop	DS			;
	MOV	dx,0000H		;
	call	File_Load		;
	POP	DS			;

;���t�@�C���̃N���[�Y
	MOV	ax,WORD PTR CS:[hAKAO_File]
	call	File_Close		;

	RET				;RETURN
OPTION_FILE	endp			;
;****************************************************************
;*		�I�v�V��������					*
;****************************************************************
Op_	proc	near	uses ax

	CALL	OPTION_FLAG		;�t���O����
	MOV	AL,0			;�`�F�b�N�p

OP_L01:	CMP	CS:[OP_FLAG_DEBUG],AL	;�ꕪ����������
	JZ	OP_L02			;
	CALL	OPTION_DEBUG		;

OP_L02:	CMP	CS:[OP_FLAG_HELP],AL	;�w���v�\��
	JZ	OP_L03			;
	CALL	OPTION_HELP		;

OP_L03:	CMP	CS:[OP_FLAG_FILE],AL	;�t�@�C���ǂݍ���
	JZ	OP_L04			;
	CALL	OPTION_FILE		;
	jmp	OP_LEE			;

OP_L04:	jmp	COMEND			;�t�@�C�����̎w�肪������΁A

OP_LEE:	
	RET				;RETURN
Op_	endp
;=======================================================================|
;				Start Up				|
;=======================================================================|
_main	proc near

	call	ComSmole		;�������̍ŏ���

	mov	ax,01000h		;
	call	Memory_Open		;
	mov	word ptr cs:[segAKAO_File],ax

	call	Op_

	CALL	UN_MML_COMPAILE		;�t�l�l�k�R���p�C����

	mov	ax,word ptr cs:[segAKAO_File]
	call	Memory_Close		;�������̉��

	ret
_main	endp
;************************************************************************
;*		�I���							*
;************************************************************************
CEND:
	END
