;************************************************************************
;*									*
;*		メインルーチン						*
;*									*
;************************************************************************
_main	proc near
	MOV	AX,OFFSET CEND + BSTACK	;
	MOV	SP,AX			;

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;セグメントがえへへへ。
	MOV	SS,AX			;

	CALL	COMSML			;メモリの最小化

	CALL	MEMORY_OPEN		;メモリの確保
	CALL	FILE_OPEN		;ファイルを開く
	CALL	FILE_READ		;ファイルの読み込み
	CALL	FILE_CLOSE		;ファイルを閉じる
	CALL	UN_MML_COMPAILE		;逆ＭＭＬコンパイル部
	CALL	MEMORY_CLOSE		;メモリの解放
COMEND:					;
	STI				;割り込み許可
	MOV	AX,04C00H		;
	INT	21H			;MS-DOS RET
_main	endp
