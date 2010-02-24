;|==============================================================|
;|								|
;|	ＬＺＳ de_compress					|
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
;	逆ＭＭＬ変換情報
;
;		コンパイル情報
;
iOffset		dw	0		;補正

segLZS_File	dw	0		;元LZSファイル用
hLZS_File	dw	0		;元LZSファイル用

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
	MOV	ES,AX			;セグメントがえへへへ。
	MOV	SS,AX			;

	cld

	call	_main
COMEND:
	.exit	0

;---------------------------------------------------------------|
;		エラー処理					|
;---------------------------------------------------------------|
;引数								|
;	dx	表示文字列（エラー内容）			|
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
;・汎用サブルーチン
include	sub_dos.asm
include	sub_cnv.asm

;************************************************************************
;*									*
;*		メインルーチン						*
;*									*
;************************************************************************
;===============================================================|
;								|
;		オプション処理					|
;								|
;===============================================================|
;****************************************************************
;*		エラー						*
;****************************************************************
.const
OPTION_ERROR_MSG	db	'オプションが不正です。',0dh,0ah,24h
.code
OPTION_ERROR	proc	near
	lea	dx,[OPTION_ERROR_MSG]
	jmp	PRINT_ERR
OPTION_ERROR	endp

;****************************************************************
;*		ヘルプ						*
;****************************************************************
.const
OP_HELP	DB	0DH,0AH
	DB	"SQUARE's LZS de-compless",0DH,0AH
	DB	"		Programmed by  内蔵音源をmidi変換するスレの889",0DH,0AH
	db	"		Special Thanks    同スレの住人達",0DH,0AH
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
	lea	DX,[OP_HELP]		;表示
	MOV	AH,09H			;
	INT	21H			;
	.exit	0
OPTION_HELP	endp			;

;****************************************************************
;*		オプション処理					*
;****************************************************************
;●引数								*
;	ptFilename	ファイル名を入れるポインタ		*
;●返り値							*
;	ptFilename[]	オプション文字列で指定されたファイル名	*
;●使用レジスタ							*
;	ds:si		オプション文字列アドレス		*
;	es:di		ptFilename				*
;	ax		汎用					*
;	cx		オプション文字列最終アドレス＋１	*
;****************************************************************
.code
Op_	proc	near	uses ds es,
		ptFilename:DWORD	;ファイル名を入れるポインタ

	local	cOffset:BYTE		;デバッグの設定有無
	local	cHelp:BYTE		;ヘルプ表示の有無
	local	dotFlag:BYTE		;ファイル名の拡張子の有無

	pusha

	;-----------------------
	;フラグ立て
	xor	ax,ax			;ax ← 0
	les	di,ptFilename		;
	stosb				;先頭にだけ、0を入れておく。
	mov	cOffset,al		;
	mov	cHelp,al		;
	mov	dotFlag,al		;

	push	cs			;
	pop	ds			;DS←CS
	MOV	si,0080H		;BX←オプション文字列先頭アドレス－１
	lodsb				;AL←オプション文字数
	ADD	ax,si			;
	MOV	cx,ax			;CX←オープション文字列最終番地

    .while	(cx>=si)

	lodsb

	.if	(al<21h)
		.continue

	.elseif	((al=='/')||(al=='-'))
		.if	(cx<si)
			JMP	OPTION_ERROR	;だったらエラー
		.endif

		lodsb
		.if	((al=='h')||(al=='H')||(al=='?'))
			mov	cHelp,0FFh
		.elseif	((al=='o')||(al=='O'))
		   .repeat
			mov	dx,si		;DX←オプションアドレス
			.if	(cx<dx)		;無かったらエラー
				JMP	OPTION_ERROR
			.endif
			CALL	ASC2HEX8	;AH←文字列（数値）
			mov	si,bx
		   .until	(!(Carry?))
		   mov	cOffset,ah
		.else
			JMP	OPTION_ERROR	;無かったらエラー
		.endif

	.else
		les	di,ptFilename		;ファイル名を入れるポインタ
		.if	(byte ptr es:[di] != 0)
			JMP	OPTION_ERROR	;ファイル名が２つ書いてあるよぉ～
		.endif

		dec	si			;ポインタ一つ戻す
		mov	dotFlag,0
		.while	(cx>=si)
			lodsb
			.if	(al == '.')
				mov	dotFlag,1
			.elseif	(al < 21h)
				dec	si
				.break		;21h未満だったら終わり。
			.endif
			stosb			;ファイル名セット
		.endw

		.if	(dotFlag==0)		;拡張子が定義されなかったら定義
			mov	al,'.'
			stosb
			mov	al,'L'		;".SND"にする。一応、大文字で。
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
	;フラグに応じた処理
	;●デバッグ
	.if	(cOffset != 0)
		xor	ax,ax
		mov	ah,cOffset
		mov	CS:[iOffset],ax		;設定
	.endif

	;●ヘルプ
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;●ファイル処理
	les	di,ptFilename			;ファイル名があるポインタ
	.if	(byte ptr es:[di] != 0)

		invoke	Change_Current_Directory,	addr es:[di]

		;オープン
		invoke	File_Open,			addr es:[di],	0
		mov	word ptr cs:[hLZS_File],ax
		push	ax

		;ロード
		mov	ds,word ptr CS:[segLZS_File]
		invoke	File_Load_S,	ax,addr ds:0,2000h

		;クローズ
		pop	ax
		invoke	File_Close,	ax
	.else
		jmp	OPTION_HELP	;ファイル名の指定が無ければ、
	.endif

	popa
	RET				;RETURN
Op_	endp
;=======================================================================|
;				解凍					|
;-----------------------------------------------------------------------|
;	■引数
;		ds	LZS ファイルが読み込まれているセグメント
;		es	BIN 内容を生成するメモリのセグメント
;	■返値
;		si	LZS	ファイルのポインタ
;		di	BIN	ファイルのポインタ
;=======================================================================|
de_compress	proc	near

	local	iLzsSize:WORD

	;===============================
	;■変数設定
	xor	di,di
	xor	ax,ax
	mov	cx,8000h
   rep	stosw			;先ず、メモリ空間を０クリア

	xor	di,di		;ES:DI	BIN fileのポインタ
	mov	si,cs:[iOffset]

	;===============================
	;■lzsファイルのサイズを取得
	;---------------
	;●チョコボの不思議なダンジョン
	lodsw			;FF7は、DWROD型(32bit)。
	add	ax,si
	mov	iLzsSize,ax	;サイズの書き込み



	;===============================
	;■解凍
	.while	(si < iLzsSize)
	   lodsb
	   mov	cx,8
	   .repeat
		shr	al,1
		push	ax
		;-----------------------
		.if	(carry?)	;Not 圧縮
			movsb
		;-----------------------
		.else			;
			lodsw		;データ読み込み

			push	ds
			push	si
			push	cx	;レジスタ保存

			;---------------
			;●チョコボの不思議なダンジョン
			;・上位  6bit が、データ長
			mov	cx,ax
			shr	cx,10		;FF7は、8 回シフト
			and	cx,0003Fh	;FF7は、0000Fh で論理積
			add	cx,3

			;・下位 10bit が、辞書Offset
			and	ax,003FFh	;FF7は、ahレジスタを4回左シフトするだけ。
			mov	bx,di
			sub	bx,ax
			sub	bx,0042h	;FF7は、12h（何故、42hなのだろう？）
			and	bx,003FFh	;FF7は、00FFFh
			mov	si,di
			sub	si,bx

			;---------------
			push	es
			pop	ds	;DS ← ES
		rep	movsb		;辞書からコピー

			pop	cx	;レジスタ復帰
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

	local	Ext[3]:BYTE		;拡張子　変更用
	local	cFilename[134]:BYTE	;ファイル名

	;-------------------------------
	;■メモリオープン
	call	ComSmole		;メモリの最小化

	invoke	Memory_Open,	01000h	;LZSファイル
	mov	word ptr cs:[segLZS_File],ax
	mov	ds,ax

	invoke	Memory_Open,	01000h	;BINファイル
	mov	word ptr cs:[segBIN_File],ax
	mov	es,ax


	;-------------------------------
	;■オプション処理
	invoke	Op_,		addr ss:cFilename	;オプションに記述されたファイル名を取得する。


	;-------------------------------
	;■解凍
	invoke	de_compress		;


	;-------------------------------
	;■保存
	mov	Ext[0],'B'		;
	mov	Ext[1],'I'		;拡張子は"BIN"
	mov	Ext[2],'N'		;
	invoke	ChangeExt,	addr ss:cFilename,addr ss:Ext
	invoke	File_Create,	addr ss:cFilename,0
	invoke	File_Write,	ax,di,addr es:0
	invoke	File_Close,	ax

	;-------------------------------
	;■メモリの解放
	invoke	Memory_Close,	es
	invoke	Memory_Close,	ds

	ret
_main	endp
;************************************************************************
;*		終わり							*
;************************************************************************
	END
