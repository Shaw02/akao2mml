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
;		ax	���蓖�Ă����p���O����			|
;	���Ԃ�l						|
;		ax	���蓖�Ă��������̃Z�O�����g		|
;---------------------------------------------------------------|
Memory_Open	proc	near	uses bx	;

	MOV	bx,ax			;�f�[�^�̈�̊m��

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
;		ax	�J�����郁�����̃Z�O�����g		|
;	���Ԃ�l						|
;		����						|
;---------------------------------------------------------------|
Memory_Close	proc	near	uses ax es

	mov	es,ax			;

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
;		ds:dx	�t�@�C���l�[���̃|�C���^		|
;			0 ��� Read				|
;			1 ��� Write				|
;			2 ��� Randam				|
;	���Ԃ�l						|
;		ax	�n���h��				|
;---------------------------------------------------------------|
File_Create	proc	near		;

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
;		ds:dx	�t�@�C���l�[���̃|�C���^		|
;		al	0 ��� Read				|
;			1 ��� Write				|
;			2 ��� Randam				|
;	���Ԃ�l						|
;		ax	�n���h��				|
;---------------------------------------------------------------|
File_Open	proc	near		;

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
;		ax	�n���h��				|
;	���Ԃ�l						|
;---------------------------------------------------------------|
File_Close	proc	near	uses ax bx

		mov	bx,ax		;bx���n���h��

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
;		ax	�n���h��				|
;		ds:dx	�o�b�t�@�̃A�h���X			|
;	���Ԃ�l						|
;		ax	�ǂݍ��߂��o�C�g��			|
;---------------------------------------------------------------|
File_Load	proc	near	uses bx cx

		mov	bx,ax		;bx���n���h��
		mov	cx,0ffffh	;�S���ǂނ�H
		mov	ah,3fh		;
		int	21h		;

		jnc	File_Load_Ok	;
		call	File_Err	;
File_Load_Ok:				;
		ret			;
File_Load	endp			;
;---------------------------------------------------------------|
;		�t�@�C���̃��C�g				|
;---------------------------------------------------------------|
;	������							|
;		ax	�n���h��				|
;		cx	�������݃o�C�g��			|
;		ds:dx	�o�b�t�@�̃A�h���X			|
;	���Ԃ�l						|
;---------------------------------------------------------------|
File_Write	proc	near	uses bx cx

		mov	bx,ax		;bx���n���h��
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
ComSmoleMessage7	DB	"�v���O�����ɂ�郁�����[���̃f�[�^�[�̔j��B",0DH,0AH,"$"
ComSmoleMessage8	DB	"�\���ȋ󂫃������[�������B",0DH,0AH,"$"
ComSmoleMessage9	DB	"�s���ȃ������[�u���b�N�̎g�p�B",0DH,0AH,"$"
ComSmole	proc	near	uses dx cx
				;�������[�̍ŏ���
	
	MOV	ES,CS:[002CH]	;���Z�O�����g�̊J��
	MOV	AH,49H		;
	INT	21H		;
	
	MOV	AX,CS		;
	MOV	DS,AX		;DS��CS
	MOV	ES,AX		;ES��CS
	MOV	BX,OFFSET CEND+BSTACK
	MOV	CL,4		;
	SHR	BX,CL		;
	INC	BX		;BX���v���O�����̑傫���i�p���O���t�P�ʁj
	MOV	AH,04AH		;
	INT	21H		;�ŏ���

	PUSH	BX		;
	PUSH	AX		;�Ԃ�l�̕ۑ�

	JC	ComSmoleERR	;�G���[���ɔ��
	CLC			;Cy��'L'
	JMP	ComSmoleRET	;RETURN
;===============================================================|
ComSmoleERR:			;�t�@���N�V����4AH �̂d�q�q�n�q
	CMP	AX,07H		;
	JNZ	ComSmoleER8	;ERROR CODE=07H
	MOV	AH,09H		;
	MOV	DX,OFFSET ComSmoleMessage7
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'H'
	JMP	ComSmoleRET	;RETURN
ComSmoleER8:
	CMP	AX,08H		;
	JNZ	ComSmoleER9	;ERROR CODE=08H
	MOV	AH,09H		;
	MOV	DX,OFFSET ComSmoleMessage8
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'L'
	JMP	ComSmoleRET	;RETURN
ComSmoleER9:
	MOV	AH,09H		;ERROR CODE=09H
	MOV	DX,OFFSET ComSmoleMessage9
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'H'
	JMP	ComSmoleRET	;RETURN
;===============================================================|
ComSmoleRET:			;�q�d�s�t�q�m
	POP	AX		;
	POP	BX		;
	RET			;RETURN
ComSmole	endp		;
;---------------------------------------------------------------|
;		�G���[�I��					|
;---------------------------------------------------------------|
;	������							|
;		ax Error Code					|
;---------------------------------------------------------------|
Error_MsgOffset:
	dw	offset	Err_M00
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

		jmp	COMEND			;

		ret
File_Err	endp