;************************************************************************
;*									*
;*		���C�����[�`��						*
;*									*
;************************************************************************
_main	proc near
	MOV	AX,OFFSET CEND + BSTACK	;
	MOV	SP,AX			;

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;�Z�O�����g�����ււցB
	MOV	SS,AX			;

	CALL	COMSML			;�������̍ŏ���

	CALL	MEMORY_OPEN		;�������̊m��
	CALL	FILE_OPEN		;�t�@�C�����J��
	CALL	FILE_READ		;�t�@�C���̓ǂݍ���
	CALL	FILE_CLOSE		;�t�@�C�������
	CALL	UN_MML_COMPAILE		;�t�l�l�k�R���p�C����
	CALL	MEMORY_CLOSE		;�������̉��
COMEND:					;
	STI				;���荞�݋���
	MOV	AX,04C00H		;
	INT	21H			;MS-DOS RET
_main	endp
