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
include	lib_dos.inc


.data
;
;	�t�l�l�k�ϊ����
;
;		�R���p�C�����
;
iOffset		dw	0		;Offset Address

iType		db	6

;=======================================================================|
;				Start Up				|
;=======================================================================|
.code
	.startup

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;�Z�O�����g�����ււցB
	MOV	SS,AX			;
	MOV	SP,offset DGROUP:stack
	invoke	ComSmole,	sp

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
	DB	"LZS2BIN [/?] [filename1]",0DH,0AH
	DB	0DH,0AH
	DB	"   filename1	Source LZS filename",0DH,0AH
	DB	"  /T<value>	LZS Type (Length of data bit)",0DH,0AH
	DB	"  		  4 : FINAL FANTASY 7",0DH,0AH
	DB	"  		  6 : Chokobo's Dungeon (Default)",0DH,0AH
	DB	"  /O<value>	Offset Address upper 8bit",0DH,0AH
	DB	"  		  (0 to 255, default = 0)",0DH,0AH
	DB	"  /?		Display help",0DH,0AH
	DB	024H
.code
OPTION_HELP	proc	near

	push	cs
	pop	ds
	lea	dx,[OP_HELP]
	mov	ah,09h
	int	21h

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

	local	dotFlag:BYTE		;�t�@�C�����̊g���q�̗L��
	local	cHelp:BYTE		;�w���v�\���̗L��

	pusha

	;-----------------------
	;�t���O����
	xor	ax,ax			;ax �� 0
	les	di,ptFilename		;
	stosb				;�擪�ɂ����A0�����Ă����B
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
		;-----------------------
		.if	((al=='h')||(al=='H')||(al=='?'))
			mov	cHelp,0FFh
		;-----------------------
		.elseif	((al=='o')||(al=='O'))
			.repeat
			   mov	dx,si		;DX���I�v�V�����A�h���X
			   .if	(cx<dx)		;����������G���[
				JMP	OPTION_ERROR
			   .endif
			   CALL	ASC2HEX8	;AH��������i���l�j
			   mov	si,bx
			.until	(!(Carry?))
			xor	al,al
			mov	CS:[iOffset],ax		;�I�t�Z�b�g�A�h���X
		;-----------------------
		.elseif	((al=='t')||(al=='T'))
			.repeat
			   mov	dx,si		;DX���I�v�V�����A�h���X
			   .if	(cx<dx)		;����������G���[
				JMP	OPTION_ERROR
			   .endif
			   CALL	ASC2HEX8	;AH��������i���l�j
			   mov	si,bx
			.until	(!(Carry?))
			mov	CS:[iType],ah
		;-----------------------
		.else
			JMP	OPTION_ERROR	;����������G���[
		;-----------------------
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
	;���w���v
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;���t�@�C������
	les	di,ptFilename			;�t�@�C����������|�C���^
	.if	(byte ptr es:[di] == 0)
		jmp	OPTION_HELP	;�t�@�C�����̎w�肪������΁A
	.endif

	popa
	RET				;RETURN
Op_	endp

;=======================================================================|
;				��					|
;-----------------------------------------------------------------------|
;	������								|
;		hLZS	LZS�t�@�C���̃n���h��				|
;		hBIN	BIN�t�@�C���̃n���h��				|
;		es	�X���C�h�����p�̃�����				|
;	�����W�X�^�g�p							|
;		ds:si	�t�@�C���ǂݍ��ݗp�̃o�b�t�@			|
;		es:di	�X���C�h�����̏������݃|�C���^			|
;		ax, dx	�ėp						|
;		bx	hLZS						|
;		cx	�J�E���^�p					|
;=======================================================================|

decomp_min	equ	3

de_compress	proc	near,
		hLZS:WORD,
		hBIN:WORD

	local	iLzsSize:SDWORD		;LZS�t�@�C���̃T�C�Y

	local	iSlideOffset:WORD	;�Q�ƃA�h���X	�ψ�
	local	iSlideMask:WORD		;�Q�ƃA�h���X	bit mask�p	dx���W�X�^�Œ�
	local	iLengthMask:WORD	;�f�[�^��	bit mask�p

	local	iLengthShift:BYTE	;�f�[�^��	�V�t�g��
	local	iSlideShiftAH:BYTE	;�Q�ƃA�h���X	�V�t�g��

	local	cLZSbuff[2]:BYTE

	pusha

	;===============================
	;���ϐ��ݒ�
	push	ss
	pop	ds
	lea	si, cLZSbuff
	xor	di, di			;ES:DI	BIN file�̃|�C���^
	mov	dx, cs:[iOffset]	

	mov	bx, hLZS

	invoke	File_Seek,	bx, 0, di::dx		;�|�C���^���炷


	;===============================
	;��lzs�t�@�C���̃T�C�Y���擾�@���@�ݒ�
	.if	(cs:[iType] == 4)
		;---------------
		;��FF7 & Saga
		invoke	File_Load_S,	bx, 4, ds::si
		mov	ax, word ptr ds:[si + 0]
		mov	dx, word ptr ds:[si + 2]

		mov	cl,	4		;�@Length �̕�
		mov	ch,	12		;�@Slide  �̕�
		mov	iLengthShift,	8	;�@0000 1111 0000 0000
		mov	iSlideShiftAH,	4	;�@~~~~ ��������炷�B
	.else
		;---------------
		;���`���R�{�̕s�v�c�ȃ_���W����
		invoke	File_Load_S,	bx, 2, ds::si
		mov	ax, word ptr ds:[si + 0]
		sub	ax,2
		xor	dx, dx

		mov	cl,	6		;�@Length �̕�
		mov	ch,	10		;�@Slide  �̕�
		mov	iLengthShift,	10	;�@1111 1100 0000 0000
		mov	iSlideShiftAH,	0	;�@�@�@�@ ~~ ���炵�͕K�v�����B
	.endif
	mov	word ptr iLzsSize[0],ax		;�T�C�Y�̏�������
	mov	word ptr iLzsSize[2],dx		;�T�C�Y�̏�������

	mov	ax,0001h
	shl	ax,cl
	dec	ax
	mov	iLengthMask,	ax	; (1 << Length��) - 1
	add	ax, decomp_min
	mov	iSlideOffset,	ax	; (1 << Length��) - 1

	mov	ax,0001h
	mov	cl,ch
	shl	ax,cl
	dec	ax
	mov	iSlideMask, ax

	;===============================
	;����
	.repeat
	   invoke	File_Load_S,	bx, 1, ds::si
	   mov		al, byte ptr ds:[si + 0]
	   sub		word ptr iLzsSize[0],1		;
	   sbb		word ptr iLzsSize[2],0		;
	   mov		cx, 8
	   .repeat
		shr	al,1
		push	ax
		;-----------------------
		.if	(carry?)	;Not ���k
			mov	dx, 1
			invoke	File_Load_S,	bx, dx, ds::si
			invoke	File_Write,	hBIN, dx, ds::si
			mov	al, byte ptr ds:[si + 0]
			and	di, iSlideMask
			stosb
		;-----------------------
		.else			;
			invoke	File_Load_S,	bx, 2, ds::si
			mov	ax, word ptr ds:[si + 0]
			push	ds
			push	si
			push	cx	;���W�X�^�ۑ�
			;---------------
			;���`���R�{�̕s�v�c�ȃ_���W����
			;�E���  6bit ���A�f�[�^��
			mov	dx, ax
			mov	cl, iLengthShift
			shr	dx, cl
			and	dx, iLengthMask
			add	dx, decomp_min

			;�E���� 10bit ���A����Offset
			mov	cl, iSlideShiftAH
			.if	(cl != 0)
			  shr	ah, cl
			.endif
			push	es
			pop	ds	;DS �� ES
			mov	si, ax
			add	si, iSlideOffset
			.repeat
				and	di, iSlideMask
				and	si, iSlideMask
				invoke	File_Write,	hBIN, 1, ds::si
				movsb
				dec	dx
			.until	(zero?)
			pop	cx	;���W�X�^���A
			pop	si
			pop	ds
			mov	dx,2
		;-----------------------
		.endif
		pop	ax
		sub	word ptr iLzsSize[0], dx	;
		sbb	word ptr iLzsSize[2], 0		;
		.break	.if	(carry?)
		mov	dx, word ptr iLzsSize[0]	;
		or	dx, word ptr iLzsSize[2]	;
		.break	.if	(zero?)
	   .untilcxz
	mov	dx, word ptr iLzsSize[0]	;
	or	dx, word ptr iLzsSize[2]	;
	.until	((zero?) || (word ptr iLzsSize[2] == 0FFFFh))

	popa
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
	invoke	Memory_Open,	01000h	;����(BIN)
	mov	es,ax


	;-------------------------------
	;���I�v�V��������
	lea	di, cFilename
	invoke	Op_,				ss::di	;�I�v�V�����ɋL�q���ꂽ�t�@�C�������擾����B


	;-------------------------------
	;���t�@�C������
	invoke	Change_Current_Directory,	ss::di

	;�I�[�v��
	invoke	File_Open,			ss::di, 0
	mov	cx, ax			;hLZS

	mov	Ext[0], 'B'		;
	mov	Ext[1], 'I'		;�g���q��"BIN"
	mov	Ext[2], 'N'		;
	invoke	ChangeExt,			ss::di, addr ss:Ext
	invoke	File_Create,			ss::di, 0
	mov	bx, ax			;hBIN


	;-------------------------------
	;����
	invoke	de_compress,	cx, bx


	;-------------------------------
	;���t�@�C���E�N���[�Y
	invoke	File_Close,	bx	;hBIN
	invoke	File_Close,	cx	;hLZS


	;-------------------------------
	;���������̉��
	invoke	Memory_Close,	es

	ret
_main	endp
;************************************************************************
;*		�I���							*
;************************************************************************
	END
