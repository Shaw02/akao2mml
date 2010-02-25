;|==============================================================|
;|	ＦＩＮＡＬ　ＦＡＮＴＡＳＹ　VIII			|
;|		逆ＭＭＬコンパイラ				|
;|								|
;|				Programmed By			|
;|					Sound Tester:774	|
;|								|
;===============================================================|


.186
.model	tiny,stdcall

.dosseg

.stack	01000h


;=======================================================================|
;				define					|
;=======================================================================|
.data
;
;	逆ＭＭＬ変換情報
;
;		コンパイル情報
;
D_Debug		DB	00h		;デバッグフラグ
segAKAO_File	dw	0		;元ファイル用
;=======================================================================|
;				Start Up				|
;=======================================================================|
.code
	.startup

	MOV	SP,offset DGROUP:stack

	MOV	AX,CS			;
	MOV	DS,AX			;
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

;・ゲーム毎の設定
include	def_ff4.asm		;SPC FINAL FANTASY 4
include	def_ff5.asm		;SPC FINAL FANTASY 4
include	def_ff6.asm		;SPC FINAL FANTASY 5
include	def_sd2.asm		;SPC 聖剣伝説 2
include	def_rs1.asm		;SPC Romancing Saga 1
include	def_rs2.asm		;SPC Romancing Saga 2
include	def_rs3.asm		;SPC Romancing Saga 3
include	def_ps1.asm		;PS  common
include	def_com.asm		;General

include	def_sfc.asm		;SPC general (統合中)
include	def_ps.asm		;PS  general (統合中)

;・逆コンパイル　メイン
include	a2m_uc.asm

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
ifdef	SPC	;------------------------
	DB	"AKAO (SQUARE SFC SOFT)  UnMML Compiler for MML2MID",0DH,0AH
endif	;--------------------------------
ifdef	PS1	;------------------------
	db	"AKAO (SQUARE SPlaystation's SOFT)  UnMML Compiler for MML2MID",0DH,0AH
endif	;--------------------------------
	DB	"		Programmed by  内蔵音源をmidi変換するスレの889",0DH,0AH
	db	"		Special Thanks    同スレの住人達",0DH,0AH
	DB	0DH,0AH
	DB	ProjectName," [/?] [filename1] [>filename2]",0DH,0AH
	DB	0DH,0AH
ifdef	SPC	;------------------------
	DB	"   filename1	Source SPC filename",0DH,0AH
endif	;--------------------------------
ifdef	PS1	;------------------------
	DB	"   filename1	Source SND filename",0DH,0AH
endif	;--------------------------------
	DB	"  >filename2	Output MML filename",0DH,0AH
	DB	"  /D		Set the debug mode (0 to 255)",0DH,0AH
	db	"  mode		 bit0(+  1) : Do not using repeat command : [, :, ]",0DH,0AH
ifdef	FF8	;------------------------
	db	"		 bit2(+  2) : Instrument no out same as VGMtrans.",0DH,0AH
endif	;--------------------------------
;	db	"		 bit2(+  4) : reserve",0DH,0AH
;	db	"		 bit3(+  8) : reserve",0DH,0AH
;	db	"		 bit4(+ 16) : reserve",0DH,0AH
;	db	"		 bit5(+ 32) : reserve",0DH,0AH
;	db	"		 bit6(+ 64) : reserve",0DH,0AH
;	db	"		 bit7(+128) : ヒッポロ系ニャポーン",0DH,0AH
	db	"		 default = 0",0dh,0ah
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

	local	cDebug:BYTE		;デバッグの設定有無
	local	cHelp:BYTE		;ヘルプ表示の有無
	local	dotFlag:BYTE		;ファイル名の拡張子の有無

	pusha

	;-----------------------
	;フラグ立て
	xor	ax,ax			;ax ← 0
	les	di,ptFilename		;
	stosb				;先頭にだけ、0を入れておく。
	mov	cDebug,al		;
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
		.elseif	((al=='d')||(al=='D'))
		   .repeat
			mov	dx,si		;DX←オプションアドレス
			.if	(cx<dx)		;無かったらエラー
				JMP	OPTION_ERROR
			.endif
			CALL	ASC2HEX8	;AH←文字列（数値）
			mov	si,bx
		   .until	(!(Carry?))
		   mov	cDebug,ah
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
ifdef	SPC	;------------------------
			mov	al,'S'		;".SPC"にする。一応、大文字で。
			stosb	
			mov	al,'P'
			stosb
			mov	al,'C'
			stosb
endif	;--------------------------------
ifdef	PS1	;------------------------
			mov	al,'S'		;".SND"にする。一応、大文字で。
			stosb
			mov	al,'N'
			stosb
			mov	al,'D'
			stosb
endif	;--------------------------------
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
	.if	(cDebug != 0)
		mov	al,cDebug
		mov	CS:[D_Debug],AL		;設定
	.endif

	;●ヘルプ
	.if	(cHelp != 0)
		jmp	OPTION_HELP		;
	.endif

	;●ファイル処理
	les	di,ptFilename			;ファイル名があるポインタ
	.if	(byte ptr es:[di] != 0)

		;オープン
		invoke	File_Open,			addr es:[di],	0
		push	ax

		;ロード
		mov	ds,word ptr CS:[segAKAO_File]
		invoke	File_Load,	ax,addr ds:0

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
;				Start Up				|
;=======================================================================|
_main	proc near

	local	cFilename[134]:BYTE	;ファイル名

	;-------------------------------
	;■メモリオープン
	invoke	ComSmole		;メモリの最小化

	invoke	Memory_Open,	01000h	;
	mov	word ptr cs:[segAKAO_File],ax
	mov	es,ax

	;-------------------------------
	;■オプション処理
	invoke	Op_,		addr ss:cFilename	;オプションに記述されたファイル名を取得する。

	;-------------------------------
	;■逆コンパイル
	invoke	UN_MML_COMPAILE		;

	;-------------------------------
	;■メモリの解放
	invoke	Memory_Close,	es

	ret
_main	endp
;************************************************************************
;*		終わり							*
;************************************************************************
	END
