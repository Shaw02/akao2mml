;************************************************************************
;*									*
;*		���l�ϊ���						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
	DB	'-'			;����
ASC_8	DB	'$$$$$'			;
HEX2ASC8	proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			;���W�X�^�ۑ�
	MOV	BX,OFFSET ASC_8		
	MOV	AL,'$'			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		

	MOV	BX,OFFSET ASC_8		
	MOV	AL,' '			;
	CMP	AH,100			;
	JC	H2A8L3			;�P�O�O�̈ʂ���H
	
	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,100			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L3:	
	CMP	AL,' '			;AL=" "��������P�O�O�̈ʂ͖�������
	JNZ	H2A8E2			
	CMP	AH,10			;�P�O�̈ʂ���H
	JC	H2A8L2			
	
H2A8E2:	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,10			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L2:	
	ADD	AH,30H			;��̈ʂ͕K������
	MOV	CS:[BX],AH		;
	
	MOV	DX,OFFSET ASC_8		;�A�h���X
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC8	endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(65535)		|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AX���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
	DB	'-'			;����
ASC_16	DB	'$$$$$$$'
HEX2ASC16	proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			

	PUSH	AX			
	MOV	BX,OFFSET ASC_16	
	MOV	AL,'$'			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
	INC	BX			
	MOV	CS:[BX],AL		
;	INC	BX			
;	MOV	CS:[BX],AL		
	POP	AX			

	MOV	BX,OFFSET ASC_16	
	MOV	CL,' '			
	MOV	DX,AX			
	CMP	DX,10000		;�P�O�O�O�O�̈ʂ͂���H
	JC	H2A6L5			
	
	XOR	DX,DX			
	MOV	CX,10000		
	DIV	CX			
	ADD	AL,30H			
	MOV	CL,AL			
	MOV	CS:[BX],CL		
	INC	BX			
H2A6L5:	
	CMP	CL,' '			
	JNZ	H2A6E4			
	CMP	DX,1000			;�P�O�O�O�̈ʂ́H
	JC	H2A6L4			
	
H2A6E4:	MOV	AX,DX			
	XOR	DX,DX			
	MOV	CX,1000			
	DIV	CX			
	ADD	AL,30H			
	MOV	CL,AL			
	MOV	CS:[BX],CL		
	INC	BX			
H2A6L4:	
	CMP	CL,' '			
	JNZ	H2A6E3			
	CMP	DX,100			;�P�O�O�̈�
	JC	H2A6L3			
	
H2A6E3:	MOV	AX,DX			
	XOR	DX,DX			
	MOV	CX,100			
	DIV	CX			
	ADD	AL,30H			
	MOV	CL,AL			
	MOV	CS:[BX],CL		
	INC	BX			
H2A6L3:	
	CMP	CL,' '			
	JNZ	H2A6E2			
	CMP	DX,10			;�P�O�̈ʂ́H
	JC	H2A6L2			

H2A6E2:	MOV	AX,DX			
	XOR	DX,DX			
	MOV	CX,10			
	DIV	CX			
	ADD	AL,30H			
	MOV	CL,AL			
	MOV	CS:[BX],CL		
	INC	BX			
H2A6L2:	
	MOV	AX,DX			
	ADD	AL,30H			
	MOV	CS:[BX],AL		;�P�̈ʂ͕K������
	
	MOV	DX,OFFSET ASC_16	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC16	endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(255)	�i�����t���j	|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
FH2A8		proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			
	
	TEST	AH,80H			
	JZ	F2A8L0			
	NEG	AH			
	CALL	HEX2ASC8		
	DEC	DX			
	PUSH	AX			
	PUSH	BX			
	MOV	BX,DX			
	MOV	AL,'-'			
	MOV	CS:[BX],AL		
	POP	BX			
	POP	AX			
	JMP	F2A8L2			
F2A8L0:	CALL	HEX2ASC8		
	DEC	DX			
	PUSH	AX			
	PUSH	BX			
	MOV	BX,DX			
	MOV	AL,'+'			
	MOV	CS:[BX],AL		
	POP	BX			
	POP	AX			
F2A8L2:	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
FH2A8		endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(65535)�i�����t���j	|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
FH2A16		proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			
	
	TEST	AH,80H			
	JZ	F2A6L0			
	NEG	AX			
	CALL	HEX2ASC16		
	DEC	DX			
	PUSH	AX			
	PUSH	BX			
	MOV	BX,DX			
	MOV	AL,'-'			
	MOV	CS:[BX],AL		
	POP	BX			
	POP	AX			
	JMP	F2A6L2			
F2A6L0:
	CALL	HEX2ASC16		
	DEC	DX			
	PUSH	AX			
	PUSH	BX			
	MOV	BX,DX			
	MOV	AL,'+'			
	MOV	CS:[BX],AL		
	POP	BX			
	POP	AX			
F2A6L2:	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
FH2A16		endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
H2A8		proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			
	MOV	BX,OFFSET ASC_8		
	MOV	CH,' '			
	MOV	CS:[BX],CH		
	INC	BX			
	
	MOV	AL,' '			
	CMP	AH,100			
	JC	H2A8L03			
	
	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,100			
	DIV	CH			
	ADD	AL,30H			
H2A8L03:MOV	CS:[BX],AL		
	INC	BX			
	
	CMP	AL,' '			
	JNZ	H2A8E02			
	CMP	AH,10			
	JC	H2A8L02			
	
H2A8E02:MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,10			
	DIV	CH			
	ADD	AL,30H			
H2A8L02:MOV	CS:[BX],AL		

	INC	BX			
	
	ADD	AH,30H			
	MOV	CS:[BX],AH		
	
	MOV	DX,OFFSET ASC_8		
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
H2A8		endp
;************************************************************************
;*									*
;*		�t�@�C���A�N�Z�X�֌W���[�`��				*
;*									*
;************************************************************************
F_ADD		DW	?		;�t�@�C�����i�[�A�h���X
FILE_H		DW	?		;�t�@�C���n���h��
;---------------------------------------------------------------|
;		�t�@�C���̃I�[�v��				|
;---------------------------------------------------------------|
FILE_OPEN	proc	near		;
	MOV	BX,0081H		;
	MOV	CH,CS:[BX - 1]		;
	ADD	BL,CH			;
	MOV	CS:[BX],BH		;
	MOV	BX,0081H		;
FLOOP:	CMP	CH,0			;
	JNZ	FL001			;
	JMP	FILE_NAME_NOTHING	;
FL001:	DEC	CH			;
	INC	BX			;
	CMP	BYTE PTR CS:[BX],21H	;
	JC	FLOOP			;
	MOV	DX,BX			;
	MOV	CS:[F_ADD],BX		;�t�@�C�����擪�A�h���X�̕ۑ�

FLOP1:	CMP	CH,0			;�g���q�w��̂Ȃ��ꍇ
	JNZ	FL012			;'.SND'�Ƃ���B
	MOV	AH,'.'			;
	MOV	CS:[BX],AH		;
	INC	BX			;
	MOV	AH,'S'			;
	MOV	CS:[BX],AH		;
	INC	BX			;
	MOV	AH,'N'			;
	MOV	CS:[BX],AH		;
	INC	BX			;
	MOV	AH,'D'			;
	MOV	CS:[BX],AH		;
	INC	BX			;
	MOV	AH,00			;
	MOV	CS:[BX],AH		;
	
	JMP	FL020			;
FL012:	DEC	CH			;
	INC	BX			;
	CMP	BYTE PTR CS:[BX],'.'	;
	JNZ	FLOP1			;

FL020:	MOV	AX,3D00H		;�t�@�C���̃I�[�v��
	INT	21H			;
	JNC	FL002			;
	JMP	FILE_OPEN_ERROR		;
FL002:	MOV	WORD PTR CS:[FILE_H],AX	;
	RET				;
FILE_OPEN	endp
;---------------------------------------------------------------|
;		�t�@�C�����������]���iOPN Data�j		|
;---------------------------------------------------------------|
FILE_READ	proc	near		;
	PUSH	DS			;
	MOV	AX,CS:[DATSEG]		;
	MOV	DS,AX			;
	MOV	DX,0000H		;
	MOV	CX,0FFFFH		;
	MOV	BX,WORD PTR CS:[FILE_H]	;
	MOV	AH,3FH			;
	INT	21H			;
	POP	DS			;
	JNC	FL003			;
	JMP	FILE_READ_ERROR		;
FL003:	RET				;
FILE_READ	endp
;---------------------------------------------------------------|
;		�t�@�C���̃N���[�Y				|
;---------------------------------------------------------------|
FILE_CLOSE	proc	near		;
	MOV	BX,WORD PTR CS:[FILE_H]	;
	MOV	AH,3EH			;
	INT	21H			;
	JNC	FL004			;
	JMP	FILE_CLOSE_ERROR	;
FL004:	RET				;
FILE_CLOSE	endp
;************************************************************************
;*									*
;*		�������֌W						*
;*									*
;************************************************************************
DATSEG		DW	?		;���蓖�Ă��������̃Z�O�����g
;---------------------------------------------------------------|
;		�������m�ہiOPN Data�j				|
;---------------------------------------------------------------|
MEMORY_OPEN	proc	near		;
	MOV	AH,48H			;
	MOV	BX,1000H		;64KByte �̃f�[�^�̈�̊m��
	INT	21H			;
	JNC	NOPERR			;���蓖�Ď��s���ɔ�ԁB
	JMP	MEMORY_OPEN_ERROR	;
NOPERR:	MOV	CS:[DATSEG],AX		;���蓖�Ă��Z�O�����g�A�h���X�̕ۑ��B
	MOV	ES,AX			;
	RET				;
MEMORY_OPEN	endp
;---------------------------------------------------------------|
;		�������J���iOPN Data�j				|
;---------------------------------------------------------------|
MEMORY_CLOSE	proc	near		;
	MOV	AX,CS:[DATSEG]		;
	MOV	ES,AX			;�Z�O�����g��ǂށB
	MOV	AH,49H			;
	INT	21H			;�f�[�^�̈�̊J��
	JNC	MCLRET			;
	JMP	MEMORY_CLOSE_ERROR	;
MCLRET:	RET				;
MEMORY_CLOSE	endp			
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
SMLME7	DB	"�v���O�����ɂ�郁�����[���̃f�[�^�[�̔j��B",0DH,0AH,"$"
SMLME8	DB	"�\���ȋ󂫃������[�������B",0DH,0AH,"$"
SMLME9	DB	"�s���ȃ������[�u���b�N�̎g�p�B",0DH,0AH,"$"
COMSML	proc	near		;�������[�̍ŏ���
	PUSH	DX		;
	PUSH	CX		;���W�X�^�̕ۑ�
	
	MOV	ES,CS:[002CH]		;���Z�O�����g�̊J��
	MOV	AH,49H			;
	INT	21H			;
	
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
	JC	SMLERR		;�G���[���ɔ��
	CLC			;Cy��'L'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLERR:				;�t�@���N�V����4AH �̂d�q�q�n�q
	CMP	AX,07H		;
	JNZ	SMLER8		;ERROR CODE=07H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME7
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'H'
	JMP	SMLRET		;RETURN
SMLER8:
	CMP	AX,08H		;
	JNZ	SMLER9		;ERROR CODE=08H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME8
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'L'
	JMP	SMLRET		;RETURN
SMLER9:
	MOV	AH,09H		;ERROR CODE=09H
	MOV	DX,OFFSET SMLME9
	INT	21H		;���b�Z�[�W�̕\��
	STC			;Cy��'H'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLRET:				;�q�d�s�t�q�m
	POP	AX		;
	POP	BX		;
	POP	CX		;���W�X�^�[�̕��A
	POP	DX		;
	RET			;RETURN
COMSML	endp
;---------------------------------------------------------------|
;		�G���[����					|
;---------------------------------------------------------------|
FILE_OPEN_ERR_MES	DB	'File not found',0DH,0AH,'$'
FILE_NAME_NOTHING_MES	DB	'FF8MML filename[.snd] [>filename.mml]',0DH,0AH,'$'
FILE_READ_ERR_MES	DB	'�t�@�C����ǂ߂܂���ł����B',0DH,0AH,24H
FILE_CLOSE_ERR_MES	DB	'�t�@�C���N���[�Y�Ɏ��s���܂���',0DH,0AH,'$'
MEMORY_OPEN_ERR_MES	DB	'������������܂���B',0DH,0AH,24H
MEMORY_CLOSE_ERR_MES	DB	'�������̉���Ɏ��s���܂���',0DH,0AH,'$'
PRINT:					;
	PUSH	CS			;
	POP	DS			;DS��CS
	MOV	AH,09H			;
	INT	21H			;�\��
	JMP	COMEND			;
FILE_OPEN_ERROR:
	MOV	DX,OFFSET FILE_OPEN_ERR_MES
	JMP	PRINT
FILE_NAME_NOTHING:
	MOV	DX,OFFSET FILE_NAME_NOTHING_MES
	JMP	PRINT
FILE_READ_ERROR:
	MOV	DX,OFFSET FILE_READ_ERR_MES
	JMP	PRINT
FILE_CLOSE_ERROR:
	MOV	DX,OFFSET FILE_CLOSE_ERR_MES
	JMP	PRINT
MEMORY_OPEN_ERROR:
	MOV	DX,OFFSET MEMORY_OPEN_ERR_MES
	JMP	PRINT
MEMORY_CLOSE_ERROR:
	MOV	DX,OFFSET MEMORY_CLOSE_ERR_MES
	JMP	PRINT
