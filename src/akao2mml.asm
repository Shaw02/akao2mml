;|==============================================================|
;|	�e�h�m�`�k�@�e�`�m�s�`�r�x�@VIII			|
;|		�t�l�l�k�R���p�C��				|
;|								|
;|				Programmed By			|
;|					Sound Tester:774	|
;|								|
;===============================================================|


.186
.model	tiny,stdcall

.dosseg

.stack	01000h


;=======================================================================|
;				define					|
;=======================================================================|
.data
;
;	�t�l�l�k�ϊ����
;
;		�R���p�C�����
;
D_Debug		DB	00h		;�f�o�b�O�t���O
segAKAO_File	dw	0		;���t�@�C���p
;=======================================================================|
;				Start Up				|
;=======================================================================|
.code
	.startup

	MOV	SP,offset DGROUP:stack

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	SS,AX			;

	cld

	call	_main
COMEND:
	.exit	0

;---------------------------------------------------------------|
;		�G���[����					|
;---------------------------------------------------------------|
;����								|
;	dx	�\��������i�G���[���e�j			|
;---------------------------------------------------------------|
PRINT_ERR:
	push	cs			;
	pop	ds			;
	MOV	AH,09H			;
	INT	21H			;
	.exit	255			;

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
include	def_sd2.asm		;SPC �����`�� 2
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
;****************************************************************
;*		�G���[						*
;****************************************************************
.const
OPTION_ERROR_MSG	db	'�I�v�V�������s���ł��B',0dh,0ah,24h
.code
OPTION_ERROR	proc	near
	lea	dx,[OPTION_ERROR_MSG]
	jmp	PRINT_ERR
OPTION_ERROR	endp

;****************************************************************
;*		�w���v						*
;****************************************************************
.const
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
.code
OPTION_HELP	proc	near
	push	cs
	pop	ds
	lea	DX,[OP_HELP]		;�\��
	MOV	AH,09H			;
	INT	21H			;
	.exit	0
OPTION_HELP	endp			;

;****************************************************************
;*		�I�v�V��������					*
;****************************************************************
;������								*
;	ptFilename	�t�@�C����������|�C���^		*
;���Ԃ�l							*
;	ptFilename[]	�I�v�V����������Ŏw�肳�ꂽ�t�@�C����	*
;���g�p���W�X�^							*
;	ds:si		�I�v�V����������A�h���X		*
;	es:di		ptFilename				*
;	ax		�ėp					*
;	cx		�I�v�V����������ŏI�A�h���X�{�P	*
;****************************************************************
.code
Op_	proc	near	uses ds es,
		ptFilename:DWORD	;�t�@�C����������|�C���^

	local	cDebug:BYTE		;�f�o�b�O�̐ݒ�L��
	local	cHelp:BYTE		;�w���v�\���̗L��
	local	dotFlag:BYTE		;�t�@�C�����̊g���q�̗L��

	pusha

	;-----------------------
	;�t���O����
	xor	ax,ax			;ax �� 0
	les	di,ptFilename		;
	stosb				;�擪�ɂ����A0�����Ă����B
	mov	cDebug,al		;
	mov	cHelp,al		;
	mov	dotFlag,al		;

	push	cs			;
	pop	ds			;DS��CS
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
			JMP	OPTION_ERROR	;��������G���[
		.endif

		lodsb
		.if	((al=='h')||(al=='H')||(al=='?'))
			mov	cHelp,0FFh
		.elseif	((al=='d')||(al=='D'))
		   .repeat
			mov	dx,si		;DX���I�v�V�����A�h���X
			.if	(cx<dx)		;����������G���[
				JMP	OPTION_ERROR
			.endif
			CALL	ASC2HEX8	;AH��������i���l�j
			mov	si,bx
		   .until	(!(Carry?))
		   mov	cDebug,ah
		.else
			JMP	OPTION_ERROR	;����������G���[
		.endif

	.else
		les	di,ptFilename		;�t�@�C����������|�C���^
		.if	(byte ptr es:[di] != 0)
			JMP	OPTION_ERROR	;�t�@�C�������Q�����Ă���悧�`
		.endif

		dec	si			;�|�C���^��߂�
		mov	dotFlag,0
		.while	(cx>=si)
			lodsb
			.if	(al == '.')
				mov	dotFlag,1
			.elseif	(al < 21h)
				dec	si
				.break		;21h������������I���B
			.endif
			stosb			;�t�@�C�����Z�b�g
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
		mov	al,24h			;
		stosb
	.endif

    .endw

	;-----------------------
	;�t���O�ɉ���������
	;���f�o�b�O
	.if	(cDebug != 0)
		mov	al,cDebug
		mov	CS:[D_Debug],AL		;�ݒ�
	.endif

	;���w���v
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;���t�@�C������
	les	di,ptFilename			;�t�@�C����������|�C���^
	.if	(byte ptr es:[di] != 0)

		;�I�[�v��
		invoke	File_Open,			addr es:[di],	0
		push	ax

		;���[�h
		mov	ds,word ptr CS:[segAKAO_File]
		invoke	File_Load,	ax,addr ds:0

		;�N���[�Y
		pop	ax
		invoke	File_Close,	ax
	.else
		jmp	OPTION_HELP	;�t�@�C�����̎w�肪������΁A
	.endif

	popa
	RET				;RETURN
Op_	endp
;=======================================================================|
;				Start Up				|
;=======================================================================|
_main	proc near

	local	cFilename[134]:BYTE	;�t�@�C����

	;-------------------------------
	;���������I�[�v��
	invoke	ComSmole		;�������̍ŏ���

	invoke	Memory_Open,	01000h	;
	mov	word ptr cs:[segAKAO_File],ax
	mov	es,ax

	;-------------------------------
	;���I�v�V��������
	invoke	Op_,		addr ss:cFilename	;�I�v�V�����ɋL�q���ꂽ�t�@�C�������擾����B

	;-------------------------------
	;���t�R���p�C��
	invoke	UN_MML_COMPAILE		;

	;-------------------------------
	;���������̉��
	invoke	Memory_Close,	es

	ret
_main	endp
;************************************************************************
;*		�I���							*
;************************************************************************
	END
