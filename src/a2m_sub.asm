;************************************************************************
;*									*
;*		数値変換部						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		１６進数コード～ASCII CODE(255)			|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１０進のアスキーコードに変換	|
;	引数							|
;		AH←変換したい数値				|
;	返り値							|
;		DX←変換した文字列の先頭アドレス		|
;---------------------------------------------------------------|
	DB	'-'			;符号
ASC_8	DB	'$$$$$'			;
HEX2ASC8	proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			;レジスタ保存
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
	JC	H2A8L3			;１００の位ある？
	
	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,100			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L3:	
	CMP	AL,' '			;AL=" "だったら１００の位は無かった
	JNZ	H2A8E2			
	CMP	AH,10			;１０の位ある？
	JC	H2A8L2			
	
H2A8E2:	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,10			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L2:	
	ADD	AH,30H			;一の位は必ず書く
	MOV	CS:[BX],AH		;
	
	MOV	DX,OFFSET ASC_8		;アドレス
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC8	endp
;---------------------------------------------------------------|
;		１６進数コード～ASCII CODE(65535)		|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１０進のアスキーコードに変換	|
;	引数							|
;		AX←変換したい数値				|
;	返り値							|
;		DX←変換した文字列の先頭アドレス		|
;---------------------------------------------------------------|
	DB	'-'			;符号
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
	CMP	DX,10000		;１００００の位はある？
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
	CMP	DX,1000			;１０００の位は？
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
	CMP	DX,100			;１００の位
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
	CMP	DX,10			;１０の位は？
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
	MOV	CS:[BX],AL		;１の位は必ず書く
	
	MOV	DX,OFFSET ASC_16	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC16	endp
;---------------------------------------------------------------|
;		１６進数コード～ASCII CODE(255)	（符号付き）	|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１０進のアスキーコードに変換	|
;	引数							|
;		AH←変換したい数値				|
;	返り値							|
;		DX←変換した文字列の先頭アドレス		|
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
;		１６進数コード～ASCII CODE(65535)（符号付き）	|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１０進のアスキーコードに変換	|
;	引数							|
;		AH←変換したい数値				|
;	返り値							|
;		DX←変換した文字列の先頭アドレス		|
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
;		１６進数コード～ASCII CODE(255)			|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１０進のアスキーコードに変換	|
;	引数							|
;		AH←変換したい数値				|
;	返り値							|
;		DX←変換した文字列の先頭アドレス		|
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
;*		ファイルアクセス関係ルーチン				*
;*									*
;************************************************************************
F_ADD		DW	?		;ファイル名格納アドレス
FILE_H		DW	?		;ファイルハンドル
;---------------------------------------------------------------|
;		ファイルのオープン				|
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
	MOV	CS:[F_ADD],BX		;ファイル名先頭アドレスの保存

FLOP1:	CMP	CH,0			;拡張子指定のない場合
	JNZ	FL012			;'.SND'とする。
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

FL020:	MOV	AX,3D00H		;ファイルのオープン
	INT	21H			;
	JNC	FL002			;
	JMP	FILE_OPEN_ERROR		;
FL002:	MOV	WORD PTR CS:[FILE_H],AX	;
	RET				;
FILE_OPEN	endp
;---------------------------------------------------------------|
;		ファイル→メモリ転送（OPN Data）		|
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
;		ファイルのクローズ				|
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
;*		メモリ関係						*
;*									*
;************************************************************************
DATSEG		DW	?		;割り当てたメモリのセグメント
;---------------------------------------------------------------|
;		メモリ確保（OPN Data）				|
;---------------------------------------------------------------|
MEMORY_OPEN	proc	near		;
	MOV	AH,48H			;
	MOV	BX,1000H		;64KByte のデータ領域の確保
	INT	21H			;
	JNC	NOPERR			;割り当て失敗時に飛ぶ。
	JMP	MEMORY_OPEN_ERROR	;
NOPERR:	MOV	CS:[DATSEG],AX		;割り当てたセグメントアドレスの保存。
	MOV	ES,AX			;
	RET				;
MEMORY_OPEN	endp
;---------------------------------------------------------------|
;		メモリ開放（OPN Data）				|
;---------------------------------------------------------------|
MEMORY_CLOSE	proc	near		;
	MOV	AX,CS:[DATSEG]		;
	MOV	ES,AX			;セグメントを読む。
	MOV	AH,49H			;
	INT	21H			;データ領域の開放
	JNC	MCLRET			;
	JMP	MEMORY_CLOSE_ERROR	;
MCLRET:	RET				;
MEMORY_CLOSE	endp			
;---------------------------------------------------------------|
;								|
;		ＣＯＭファイルのメモリー最小化			|
;---------------------------------------------------------------|
;	処理							|
;		ＣＯＭプログラム実行時にメモリーを		|
;		最小限にする					|
;	引数							|
;		無し						|
;	返り値							|
;		DS←CS						|
;	◎	Cy←'L' のとき。（正常終了）			|
;		BX←変更したメモリーの大きさ。			|
;	◎	Cy←'H' のとき。（エラー）			|
;		BX←変更できる最大の大きさ			|
;		AX←INT21H ﾌｧﾝｸｼｮﾝ4AH参照			|
;---------------------------------------------------------------|
SMLME7	DB	"プログラムによるメモリー中のデーターの破壊。",0DH,0AH,"$"
SMLME8	DB	"十分な空きメモリーが無い。",0DH,0AH,"$"
SMLME9	DB	"不正なメモリーブロックの使用。",0DH,0AH,"$"
COMSML	proc	near		;メモリーの最小化
	PUSH	DX		;
	PUSH	CX		;レジスタの保存
	
	MOV	ES,CS:[002CH]		;環境セグメントの開放
	MOV	AH,49H			;
	INT	21H			;
	
	MOV	AX,CS		;
	MOV	DS,AX		;DS←CS
	MOV	ES,AX		;ES←CS
	MOV	BX,OFFSET CEND+BSTACK
	MOV	CL,4		;
	SHR	BX,CL		;
	INC	BX		;BX←プログラムの大きさ（パラグラフ単位）
	MOV	AH,04AH		;
	INT	21H		;最小化
	PUSH	BX		;
	PUSH	AX		;返り値の保存
	JC	SMLERR		;エラー時に飛ぶ
	CLC			;Cy←'L'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLERR:				;ファンクション4AH のＥＲＲＯＲ
	CMP	AX,07H		;
	JNZ	SMLER8		;ERROR CODE=07H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME7
	INT	21H		;メッセージの表示
	STC			;Cy←'H'
	JMP	SMLRET		;RETURN
SMLER8:
	CMP	AX,08H		;
	JNZ	SMLER9		;ERROR CODE=08H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME8
	INT	21H		;メッセージの表示
	STC			;Cy←'L'
	JMP	SMLRET		;RETURN
SMLER9:
	MOV	AH,09H		;ERROR CODE=09H
	MOV	DX,OFFSET SMLME9
	INT	21H		;メッセージの表示
	STC			;Cy←'H'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLRET:				;ＲＥＴＵＲＮ
	POP	AX		;
	POP	BX		;
	POP	CX		;レジスターの復帰
	POP	DX		;
	RET			;RETURN
COMSML	endp
;---------------------------------------------------------------|
;		エラー処理					|
;---------------------------------------------------------------|
FILE_OPEN_ERR_MES	DB	'File not found',0DH,0AH,'$'
FILE_NAME_NOTHING_MES	DB	'FF8MML filename[.snd] [>filename.mml]',0DH,0AH,'$'
FILE_READ_ERR_MES	DB	'ファイルを読めませんでした。',0DH,0AH,24H
FILE_CLOSE_ERR_MES	DB	'ファイルクローズに失敗しました',0DH,0AH,'$'
MEMORY_OPEN_ERR_MES	DB	'メモリが足りません。',0DH,0AH,24H
MEMORY_CLOSE_ERR_MES	DB	'メモリの解放に失敗しました',0DH,0AH,'$'
PRINT:					;
	PUSH	CS			;
	POP	DS			;DS←CS
	MOV	AH,09H			;
	INT	21H			;表示
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
