;************************************************************************
;*									*
;*		���C�����[�`��						*
;*									*
;************************************************************************
_main	proc near
	CALL	COMSML			;�������̍ŏ���

	CALL	MEMORY_OPEN		;�������̊m��
	CALL	FILE_OPEN		;�t�@�C�����J��
	CALL	FILE_READ		;�t�@�C���̓ǂݍ���
	CALL	FILE_CLOSE		;�t�@�C�������
	CALL	UN_MML_COMPAILE		;�t�l�l�k�R���p�C����
	CALL	MEMORY_CLOSE		;�������̉��

	ret
_main	endp
