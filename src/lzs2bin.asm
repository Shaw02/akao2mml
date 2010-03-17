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
include	lib_dos.inc


.data
;
;	逆ＭＭＬ変換情報
;
;		コンパイル情報
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
	MOV	ES,AX			;セグメントがえへへへ。
	MOV	SS,AX			;
	MOV	SP,offset DGROUP:stack
	invoke	ComSmole,	sp

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

	local	dotFlag:BYTE		;ファイル名の拡張子の有無
	local	cHelp:BYTE		;ヘルプ表示の有無

	pusha

	;-----------------------
	;フラグ立て
	xor	ax,ax			;ax ← 0
	les	di,ptFilename		;
	stosb				;先頭にだけ、0を入れておく。
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
		;-----------------------
		.if	((al=='h')||(al=='H')||(al=='?'))
			mov	cHelp,0FFh
		;-----------------------
		.elseif	((al=='o')||(al=='O'))
			.repeat
			   mov	dx,si		;DX←オプションアドレス
			   .if	(cx<dx)		;無かったらエラー
				JMP	OPTION_ERROR
			   .endif
			   CALL	ASC2HEX8	;AH←文字列（数値）
			   mov	si,bx
			.until	(!(Carry?))
			xor	al,al
			mov	CS:[iOffset],ax		;オフセットアドレス
		;-----------------------
		.elseif	((al=='t')||(al=='T'))
			.repeat
			   mov	dx,si		;DX←オプションアドレス
			   .if	(cx<dx)		;無かったらエラー
				JMP	OPTION_ERROR
			   .endif
			   CALL	ASC2HEX8	;AH←文字列（数値）
			   mov	si,bx
			.until	(!(Carry?))
			mov	CS:[iType],ah
		;-----------------------
		.else
			JMP	OPTION_ERROR	;無かったらエラー
		;-----------------------
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
	;●ヘルプ
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;●ファイル処理
	les	di,ptFilename			;ファイル名があるポインタ
	.if	(byte ptr es:[di] == 0)
		jmp	OPTION_HELP	;ファイル名の指定が無ければ、
	.endif

	popa
	RET				;RETURN
Op_	endp

;=======================================================================|
;				解凍					|
;-----------------------------------------------------------------------|
;	■引数								|
;		hLZS	LZSファイルのハンドル				|
;		hBIN	BINファイルのハンドル				|
;		es	スライド辞書用のメモリ				|
;	■レジスタ使用							|
;		ds:si	ファイル読み込み用のバッファ			|
;		es:di	スライド辞書の書き込みポインタ			|
;		ax, dx	汎用						|
;		bx	hLZS						|
;		cx	カウンタ用					|
;=======================================================================|

decomp_min	equ	3

de_compress	proc	near,
		hLZS:WORD,
		hBIN:WORD

	local	iLzsSize:SDWORD		;LZSファイルのサイズ

	local	iSlideOffset:WORD	;参照アドレス	変位
	local	iSlideMask:WORD		;参照アドレス	bit mask用	dxレジスタ固定
	local	iLengthMask:WORD	;データ長	bit mask用

	local	iLengthShift:BYTE	;データ長	シフト量
	local	iSlideShiftAH:BYTE	;参照アドレス	シフト量

	local	cLZSbuff[2]:BYTE

	pusha

	;===============================
	;■変数設定
	push	ss
	pop	ds
	lea	si, cLZSbuff
	xor	di, di			;ES:DI	BIN fileのポインタ
	mov	dx, cs:[iOffset]	

	mov	bx, hLZS

	invoke	File_Seek,	bx, 0, di::dx		;ポインタずらす


	;===============================
	;■lzsファイルのサイズを取得　＆　設定
	.if	(cs:[iType] == 4)
		;---------------
		;●FF7 & Saga
		invoke	File_Load_S,	bx, 4, ds::si
		mov	ax, word ptr ds:[si + 0]
		mov	dx, word ptr ds:[si + 2]

		mov	cl,	4		;　Length の幅
		mov	ch,	12		;　Slide  の幅
		mov	iLengthShift,	8	;　0000 1111 0000 0000
		mov	iSlideShiftAH,	4	;　~~~~ これをずらす。
	.else
		;---------------
		;●チョコボの不思議なダンジョン
		invoke	File_Load_S,	bx, 2, ds::si
		mov	ax, word ptr ds:[si + 0]
		sub	ax,2
		xor	dx, dx

		mov	cl,	6		;　Length の幅
		mov	ch,	10		;　Slide  の幅
		mov	iLengthShift,	10	;　1111 1100 0000 0000
		mov	iSlideShiftAH,	0	;　　　　 ~~ ずらしは必要無し。
	.endif
	mov	word ptr iLzsSize[0],ax		;サイズの書き込み
	mov	word ptr iLzsSize[2],dx		;サイズの書き込み

	mov	ax,0001h
	shl	ax,cl
	dec	ax
	mov	iLengthMask,	ax	; (1 << Length幅) - 1
	add	ax, decomp_min
	mov	iSlideOffset,	ax	; (1 << Length幅) - 1

	mov	ax,0001h
	mov	cl,ch
	shl	ax,cl
	dec	ax
	mov	iSlideMask, ax

	;===============================
	;■解凍
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
		.if	(carry?)	;Not 圧縮
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
			push	cx	;レジスタ保存
			;---------------
			;●チョコボの不思議なダンジョン
			;・上位  6bit が、データ長
			mov	dx, ax
			mov	cl, iLengthShift
			shr	dx, cl
			and	dx, iLengthMask
			add	dx, decomp_min

			;・下位 10bit が、辞書Offset
			mov	cl, iSlideShiftAH
			.if	(cl != 0)
			  shr	ah, cl
			.endif
			push	es
			pop	ds	;DS ← ES
			mov	si, ax
			add	si, iSlideOffset
			.repeat
				and	di, iSlideMask
				and	si, iSlideMask
				invoke	File_Write,	hBIN, 1, ds::si
				movsb
				dec	dx
			.until	(zero?)
			pop	cx	;レジスタ復帰
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

	local	Ext[3]:BYTE		;拡張子　変更用
	local	cFilename[134]:BYTE	;ファイル名

	;-------------------------------
	;■メモリオープン
	invoke	Memory_Open,	01000h	;辞書(BIN)
	mov	es,ax


	;-------------------------------
	;■オプション処理
	lea	di, cFilename
	invoke	Op_,				ss::di	;オプションに記述されたファイル名を取得する。


	;-------------------------------
	;■ファイル生成
	invoke	Change_Current_Directory,	ss::di

	;オープン
	invoke	File_Open,			ss::di, 0
	mov	cx, ax			;hLZS

	mov	Ext[0], 'B'		;
	mov	Ext[1], 'I'		;拡張子は"BIN"
	mov	Ext[2], 'N'		;
	invoke	ChangeExt,			ss::di, addr ss:Ext
	invoke	File_Create,			ss::di, 0
	mov	bx, ax			;hBIN


	;-------------------------------
	;■解凍
	invoke	de_compress,	cx, bx


	;-------------------------------
	;■ファイル・クローズ
	invoke	File_Close,	bx	;hBIN
	invoke	File_Close,	cx	;hLZS


	;-------------------------------
	;■メモリの解放
	invoke	Memory_Close,	es

	ret
_main	endp
;************************************************************************
;*		終わり							*
;************************************************************************
	END
