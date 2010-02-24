;|==============================================================|
;|								|
;|	�k�y�r de_compress					|
;|								|
;|				Programmed By			|
;|					Sound Tester:774	|
;|								|
;===============================================================|


.186
.model	tiny,stdcall

.dosseg

.stack	1000h

;=======================================================================|
;				define					|
;=======================================================================|
.data
;
;	�t�l�l�k�ϊ����
;
;		�R���p�C�����
;
iOffset		dw	0		;�␳

segLZS_File	dw	0		;��LZS�t�@�C���p
hLZS_File	dw	0		;��LZS�t�@�C���p

segBIN_File	dw	0
hBIN_File	dw	0

;=======================================================================|
;				Start Up				|
;=======================================================================|
.code
	.startup

	MOV	SP,DGROUP:stack

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;�Z�O�����g�����ււցB
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
	DB	"SQUARE's LZS de-compless",0DH,0AH
	DB	"		Programmed by  ����������midi�ϊ�����X����889",0DH,0AH
	db	"		Special Thanks    ���X���̏Z�l�B",0DH,0AH
	DB	0DH,0AH
	DB	"LZS2BIN [/?] [filename1] [>filename2]",0DH,0AH
	DB	0DH,0AH
	DB	"   filename1	Source LZS filename",0DH,0AH
	DB	"  >filename2	Output BIN filename",0DH,0AH
	DB	"  /O		Offset Address upper 8bit",0DH,0AH
	DB	"    value	  (0 to 255, default = 0)",0DH,0AH
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

	local	cOffset:BYTE		;�f�o�b�O�̐ݒ�L��
	local	cHelp:BYTE		;�w���v�\���̗L��
	local	dotFlag:BYTE		;�t�@�C�����̊g���q�̗L��

	pusha

	;-----------------------
	;�t���O����
	xor	ax,ax			;ax �� 0
	les	di,ptFilename		;
	stosb				;�擪�ɂ����A0�����Ă����B
	mov	cOffset,al		;
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
		.elseif	((al=='o')||(al=='O'))
		   .repeat
			mov	dx,si		;DX���I�v�V�����A�h���X
			.if	(cx<dx)		;����������G���[
				JMP	OPTION_ERROR
			.endif
			CALL	ASC2HEX8	;AH��������i���l�j
			mov	si,bx
		   .until	(!(Carry?))
		   mov	cOffset,ah
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
			mov	al,'L'		;".SND"�ɂ���B�ꉞ�A�啶���ŁB
			stosb
			mov	al,'Z'
			stosb
			mov	al,'S'
			stosb
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
	.if	(cOffset != 0)
		xor	ax,ax
		mov	ah,cOffset
		mov	CS:[iOffset],ax		;�ݒ�
	.endif

	;���w���v
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;���t�@�C������
	les	di,ptFilename			;�t�@�C����������|�C���^
	.if	(byte ptr es:[di] != 0)

		invoke	Change_Current_Directory,	addr es:[di]

		;�I�[�v��
		invoke	File_Open,			addr es:[di],	0
		mov	word ptr cs:[hLZS_File],ax
		push	ax

		;���[�h
		mov	ds,word ptr CS:[segLZS_File]
		invoke	File_Load_S,	ax,addr ds:0,2000h

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
;				��					|
;-----------------------------------------------------------------------|
;	������
;		ds	LZS �t�@�C�����ǂݍ��܂�Ă���Z�O�����g
;		es	BIN ���e�𐶐����郁�����̃Z�O�����g
;	���Ԓl
;		si	LZS	�t�@�C���̃|�C���^
;		di	BIN	�t�@�C���̃|�C���^
;=======================================================================|
de_compress	proc	near

	local	iLzsSize:WORD

	;===============================
	;���ϐ��ݒ�
	xor	di,di
	xor	ax,ax
	mov	cx,8000h
   rep	stosw			;�悸�A��������Ԃ��O�N���A

	xor	di,di		;ES:DI	BIN file�̃|�C���^
	mov	si,cs:[iOffset]

	;===============================
	;��lzs�t�@�C���̃T�C�Y���擾
	;---------------
	;���`���R�{�̕s�v�c�ȃ_���W����
	lodsw			;FF7�́ADWROD�^(32bit)�B
	add	ax,si
	mov	iLzsSize,ax	;�T�C�Y�̏�������



	;===============================
	;����
	.while	(si < iLzsSize)
	   lodsb
	   mov	cx,8
	   .repeat
		shr	al,1
		push	ax
		;-----------------------
		.if	(carry?)	;Not ���k
			movsb
		;-----------------------
		.else			;
			lodsw		;�f�[�^�ǂݍ���

			push	ds
			push	si
			push	cx	;���W�X�^�ۑ�

			;---------------
			;���`���R�{�̕s�v�c�ȃ_���W����
			;�E���  6bit ���A�f�[�^��
			mov	cx,ax
			shr	cx,10		;FF7�́A8 ��V�t�g
			and	cx,0003Fh	;FF7�́A0000Fh �Ř_����
			add	cx,3

			;�E���� 10bit ���A����Offset
			and	ax,003FFh	;FF7�́Aah���W�X�^��4�񍶃V�t�g���邾���B
			mov	bx,di
			sub	bx,ax
			sub	bx,0042h	;FF7�́A12h�i���́A42h�Ȃ̂��낤�H�j
			and	bx,003FFh	;FF7�́A00FFFh
			mov	si,di
			sub	si,bx

			;---------------
			push	es
			pop	ds	;DS �� ES
		rep	movsb		;��������R�s�[

			pop	cx	;���W�X�^���A
			pop	si
			pop	ds
		;-----------------------
		.endif
		pop	ax
	   .untilcxz
	.endw

	ret
de_compress	endp
;=======================================================================|
;				Start Up				|
;=======================================================================|
_main	proc	near

	local	Ext[3]:BYTE		;�g���q�@�ύX�p
	local	cFilename[134]:BYTE	;�t�@�C����

	;-------------------------------
	;���������I�[�v��
	call	ComSmole		;�������̍ŏ���

	invoke	Memory_Open,	01000h	;LZS�t�@�C��
	mov	word ptr cs:[segLZS_File],ax
	mov	ds,ax

	invoke	Memory_Open,	01000h	;BIN�t�@�C��
	mov	word ptr cs:[segBIN_File],ax
	mov	es,ax


	;-------------------------------
	;���I�v�V��������
	invoke	Op_,		addr ss:cFilename	;�I�v�V�����ɋL�q���ꂽ�t�@�C�������擾����B


	;-------------------------------
	;����
	invoke	de_compress		;


	;-------------------------------
	;���ۑ�
	mov	Ext[0],'B'		;
	mov	Ext[1],'I'		;�g���q��"BIN"
	mov	Ext[2],'N'		;
	invoke	ChangeExt,	addr ss:cFilename,addr ss:Ext
	invoke	File_Create,	addr ss:cFilename,0
	invoke	File_Write,	ax,di,addr es:0
	invoke	File_Close,	ax

	;-------------------------------
	;���������̉��
	invoke	Memory_Close,	es
	invoke	Memory_Close,	ds

	ret
_main	endp
;************************************************************************
;*		�I���							*
;************************************************************************
	END
