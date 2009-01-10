;************************************************************************
;*									*
;*		メインルーチン						*
;*									*
;************************************************************************
_main	proc near
	CALL	COMSML			;メモリの最小化

	CALL	MEMORY_OPEN		;メモリの確保
	CALL	FILE_OPEN		;ファイルを開く
	CALL	FILE_READ		;ファイルの読み込み
	CALL	FILE_CLOSE		;ファイルを閉じる
	CALL	UN_MML_COMPAILE		;逆ＭＭＬコンパイル部
	CALL	MEMORY_CLOSE		;メモリの解放

	ret
_main	endp
