;=======================================================================|
;									|
;		MS-DOS function call sub routine			|
;									|
;=======================================================================|
;****************************************************************
;								*
;			�������֘A				*
;								*
;****************************************************************
;---------------------------------------------------------------|
;		�������m��					|
;---------------------------------------------------------------|
;	������							|
;		ParaSize	���蓖�Ă����p���O����		|
;	���Ԃ�l						|
;		ax		���蓖�Ă��������̃Z�O�����g	|
;---------------------------------------------------------------|
Memory_Open	proc	near	uses bx cx di es,
	ParaSize:word

	MOV	bx,ParaSize		;�f�[�^�̈�̊m��

	MOV	AH,48H			;
	INT	21H			;

	JNC	Memory_Open_Err		;���蓖�Ď��s���ɔ�ԁB
	call	File_Err		;
Memory_Open_Err:			;

	RET				;
Memory_Open	endp			;
;---------------------------------------------------------------|
;		�������J��					|
;---------------------------------------------------------------|
;	������							|
;		CloseSegment	�J�����郁�����̃Z�O�����g	|
;	���Ԃ�l						|
;		����						|
;---------------------------------------------------------------|
Memory_Close	proc	near	uses ax es,
	CloseSegment:word

	mov	es,CloseSegment		;

	MOV	AH,49H			;
	INT	21H			;�f�[�^�̈�̊J��

	JNC	Memory_Close_Err	;
	call	File_Err		;
Memory_Close_Err:			;

	RET				;
Memory_Close	endp			;
;****************************************************************
;								*
;			�t�@�C���֘A				*
;								*
;****************************************************************
;---------------------------------------------------------------|
;		�t�@�C���̍쐬					|
;---------------------------------------------------------------|
;	������							|
;		cFilename	�t�@�C���l�[���̃|�C���^	|
;		iAttr		�t�@�C������			|
;	���Ԃ�l						|
;		ax	�n���h��				|
;---------------------------------------------------------------|
File_Create	proc	near	uses cx dx ds,
		cFilename:dword,
		iAttr:word

		lds	dx,cFilename
		mov	cx,iAttr
		mov	ah,3ch		;
		int	21h		;

		jnc	File_Create_Ok	;
		call	File_Err	;
File_Create_Ok:				;
		ret			;
File_Create	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃I�[�v��				|
;---------------------------------------------------------------|
;	������							|
;		cFilename	�t�@�C���l�[���̃|�C���^	|
;		cMode		0 ��� Read			|
;				1 ��� Write			|
;				2 ��� Randam			|
;	���Ԃ�l						|
;		ax	�n���h��				|
;---------------------------------------------------------------|
File_Open	proc	near	uses cx dx ds,
		cFilename:dword,
		cMode:byte

		lds	dx,cFilename
		mov	al,cMode

		mov	ah,3dh		;
		int	21h		;

		jnc	File_Open_Ok	;
		call	File_Err	;
File_Open_Ok:				;
		ret			;
File_Open	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃N���[�Y				|
;---------------------------------------------------------------|
;	������							|
;		hFile	�n���h��				|
;	���Ԃ�l						|
;		����						|
;---------------------------------------------------------------|
File_Close	proc	near	uses ax bx,
		hFile:word

		mov	bx,hFile	;bx���n���h��

		mov	ah,3eh		;
		int	21h		;

		jnc	File_Close_Ok	;
		call	File_Err	;
File_Close_Ok:				;
		ret			;
File_Close	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃��[�h				|
;---------------------------------------------------------------|
;	������							|
;		hFile	�n���h��				|
;		cBuff	�o�b�t�@�̃A�h���X			|
;	���Ԃ�l						|
;		ax	�ǂݍ��߂��o�C�g��			|
;---------------------------------------------------------------|
File_Load	proc	near	uses bx cx dx ds,
		hFile:word,
		cBuff:dword

		lds	dx,dword ptr cBuff
		mov	cx,0FFFFh	;�S���ǂނ�H
		mov	bx,hFile	;bx���n���h��
		mov	ah,3fh		;
		int	21h		;

		jnc	File_Load_Ok	;
		call	File_Err	;
File_Load_Ok:				;
		ret			;
File_Load	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃��[�h				|
;---------------------------------------------------------------|
;	������							|
;		hFile	�n���h��				|
;		cBuff	�o�b�t�@�̃A�h���X			|
;	���Ԃ�l						|
;		ax	�ǂݍ��߂��o�C�g��			|
;---------------------------------------------------------------|
File_Load_S	proc	near	uses bx cx dx ds,
		hFile:word,
		cBuff:dword,
		iSize:word

		lds	dx,dword ptr cBuff
		mov	cx,iSize	;�S���ǂނ�H
		mov	bx,hFile	;bx���n���h��
		mov	ah,3fh		;
		int	21h		;

		jnc	File_Load_S_Ok	;
		call	File_Err	;
File_Load_S_Ok:				;
		ret			;
File_Load_S	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃��C�g				|
;---------------------------------------------------------------|
;	������							|
;		hFile	�n���h��				|
;		iSize	�������݃o�C�g��			|
;		cBuff	�o�b�t�@�̃A�h���X			|
;	���Ԃ�l						|
;		����						|
;---------------------------------------------------------------|
File_Write	proc	near	uses ax bx cx dx ds,
		hFile:word,
		iSize:word,
		cBuff:dword

		lds	dx,dword ptr cBuff
		mov	cx,iSize	;cx���T�C�Y
		mov	bx,hFile	;bx���n���h��
		mov	ah,040h		;
		int	21h		;

		jnc	File_Write_Ok	;
		call	File_Err	;
File_Write_Ok:				;
		ret			;
File_Write	endp			;
;---------------------------------------------------------------|
;								|
;		�b�n�l�t�@�C���̃������[�ŏ���			|
;---------------------------------------------------------------|
;	����							|
;		�b�n�l�v���O�������s���Ƀ������[��		|
;		�ŏ����ɂ���					|
;	����							|
;		����						|
;	�Ԃ�l							|
;		DS��CS						|
;	��	Cy��'L' �̂Ƃ��B�i����I���j			|
;		BX���ύX�����������[�̑傫���B			|
;	��	Cy��'H' �̂Ƃ��B�i�G���[�j			|
;		BX���ύX�ł���ő�̑傫��			|
;		AX��INT21H ̧ݸ���4AH�Q��			|
;---------------------------------------------------------------|
ComSmole	proc	near	uses dx cx ds es	;�������[�̍ŏ���
	
	MOV	ES,CS:[002CH]	;���Z�O�����g�̊J��
	MOV	AH,49H		;
	INT	21H		;
	.if	(carry?)
	jmp	File_Err
	.endif

	MOV	AX,CS		;
	MOV	DS,AX		;DS��CS
	MOV	ES,AX		;ES��CS
	mov	bx, offset DGROUP:STACK
	shr	bx, 4
	MOV	AH,04AH		;
	INT	21H		;�ŏ���
	.if	(carry?)
	jmp	File_Err
	.endif

	ret			;RETURN
ComSmole	endp		;
;---------------------------------------------------------------|
;		�t�@�C�����̊g���q�ύX				|
;---------------------------------------------------------------|
;	������							|
;		cFilename	�g���q�t���t�@�C����		|
;		cExt		�ύX��̊g���q(3������)		|
;	���Ԃ�l						|
;		cFilename	�g���q�ύX��@�t�@�C����	|
;---------------------------------------------------------------|
ChangeExt	proc	near	uses ax cx si di ds es,
	cFilename:dword,
	cExt:dword

	les	di,cFilename
	lds	si,cExt

	mov	al,'.'			;
	mov	cx,085h			;
	repnz	scasb			;�g���q��{��

	mov	cx,3			;
	rep	movsb			;
	mov	al,0			;
	stosb				;
	mov	al,24h			;
	stosb				;����������

	ret
ChangeExt	endp
;---------------------------------------------------------------|
;		�J�����g�f�B���N�g���̕ύX			|
;---------------------------------------------------------------|
;	������							|
;		cDirname	�f�B���N�g����			|
;---------------------------------------------------------------|
.const
Current_Directory_Mess1	DB	'�J�����g�f�B���N�g����',24h
Current_Directory_Mess2	DB	'�ɕύX���܂����B',0dh,0ah,24h
.code
Change_Current_Directory	proc	near	uses ds es,
		cDirname:dword
	local	Current_Directory[128]:byte

	pusha

	;-------------------------------
	;�J�����g�f�B���N�g�����邩�H
	lds	si,cDirname
	push	ss
	pop	es
	lea	di,[Current_Directory]
	xor	cx,cx
	xor	bx,bx
	push	si
	.repeat
	   lodsb
	   .if		(al=='\')
		mov	bx,cx	;��ԍŌ��'\'��bx�ɋL������B
	   .endif
	   inc	cx
	.until	(al<21h)
	pop	si

	;-------------------------------
	;�J�����g�f�B���N�g������ݒ�
	.if	(bx>0)
		mov	cx,bx
		cld
		rep	movsb
		mov	al,00H
		stosb
		mov	al,24H
		stosb

		;-------------------------------
		;�J�����g�f�B���N�g����ύX����B
		push	ss
		pop	ds
		lea	dx,[Current_Directory]
		mov	ah,3BH			;
		int	21h			;
		.if	(carry?)
		jmp	File_Err
		.endif
		push	cs
		pop	ds
		lea	dx,[Current_Directory_Mess1]
		mov	ah,09H			;
		int	21h			;

		push	ss			;
		pop	ds			;
		lea	dx,[Current_Directory]	;
		mov	ah,09H			;
		int	21h			;

		push	cs			;
		pop	ds			;
		lea	dx,[Current_Directory_Mess2]
		mov	ah,09H			;
		int	21h			;
	.endif
	;-------------------------------
	;�I��

	popa
	ret				;
Change_Current_Directory	endp
;---------------------------------------------------------------|
;		�G���[�I��					|
;---------------------------------------------------------------|
;	������							|
;		ax Error Code					|
;---------------------------------------------------------------|
.const
Error_MsgOffset	dw	offset	Err_M00
		dw	offset	Err_M01
		dw	offset	Err_M02
		dw	offset	Err_M03
		dw	offset	Err_M04
		dw	offset	Err_M05
		dw	offset	Err_M06
		dw	offset	Err_M07
		dw	offset	Err_M08
		dw	offset	Err_M09
		dw	offset	Err_M0A
		dw	offset	Err_M0B
		dw	offset	Err_M0C
		dw	offset	Err_M0D
		dw	offset	Err_M0E
		dw	offset	Err_M0F

Err_M00	db	'Err=0x00:����',0dh,0ah,24h
Err_M01	db	'Err=0x01:�����ȋ@�\�R�[�h�ł��B',0dh,0ah,24h
Err_M02	db	'Err=0x02:�t�@�C�������݂��܂���B',0dh,0ah,24h
Err_M03	db	'Err=0x03:�w�肳�ꂽ�p�X�������ł�',0dh,0ah,24h
Err_M04	db	'Err=0x04:�I�[�v������Ă���t�@�C���������ł��B',0dh,0ah,24h
Err_M05	db	'Err=0x05:�A�N�Z�X�����ۂ���܂����B',0dh,0ah,24h
Err_M06	db	'Err=0x06:�w�肳�ꂽ�t�@�C���́A���݃I�[�v������Ă��܂���B',0dh,0ah,24h
Err_M07	db	'Err=0x07:Memory Control Block���j�󂳂�Ă��܂��B',0dh,0ah,24h
Err_M08	db	'Err=0x08:�\���ȑ傫���̃�����������܂���B',0dh,0ah,24h
Err_M09	db	'Err=0x09:�w�肳�ꂽ�������[�́A���蓖�Ă��Ă��܂���B',0dh,0ah,24h
Err_M0A	db	'Err=0x0A:���ϐ���32kByte�ȏ゠��܂��B',0dh,0ah,24h
Err_M0B	db	'Err=0x0B:�w�肳�ꂽ�t�@�C����exe�w�b�_�[������������܂���B',0dh,0ah,24h
Err_M0C	db	'Err=0x0C:�t�@�C���A�N�Z�X�R�[�h��0�`2�͈̔͊O�ł�',0dh,0ah,24h
Err_M0D	db	'Err=0x0D:�w�肳�ꂽ�f�o�C�X�͖����ł��B',0dh,0ah,24h
Err_M0E	db	'Err=0x0E:�H',0dh,0ah,24h
Err_M0F	db	'Err=0x0F:�w�肳�ꂽ�h���C�u�ԍ��͖����ł��B',0dh,0ah,24h
.code
File_Err	proc	near

		push	ds
		push	dx
		push	ax
		mov	bx,offset Error_MsgOffset
		shl	ax,1			;
		add	bx,ax			;
		mov	dx,cs:[bx]		;
		push	cs			;
		pop	ds			;

		mov	AH,09H			;
		int	21H			;
		pop	ax
		pop	dx
		pop	ds

	.if	((ax==02h)||(ax==03h)||(ax==0Bh)||(ax==0Ch))
		mov	AH,09H			;
		int	21H			;
	.endif

		.exit
File_Err	endp
