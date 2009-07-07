;|==============================================================|
;|	ＦＩＮＡＬ　ＦＡＮＴＡＳＹ　VIII			|
;|		逆ＭＭＬコンパイラ				|
;|								|
;|				Programmed By			|
;|					Sound Tester:774	|
;|								|
;===============================================================|


.186
.model	tiny,c

.code
;=======================================================================|
;				Start Up				|
;=======================================================================|
	.startup
ff8mml_:	
	lea	AX,[CEND + BSTACK]	;
	MOV	SP,AX			;

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;セグメントがえへへへ。
	MOV	SS,AX			;

	cld

	call	_main
COMEND:
	.exit

;=======================================================================|
;				define					|
;=======================================================================|
;
;	逆ＭＭＬ変換情報
;
BSTACK		EQU	0400H		;スタックバッファ
;
;		コンパイル情報
;
D_Debug		DB	00h		;デバッグフラグ
segAKAO_File	dw	0		;元ファイル用
hAKAO_File	dw	0		;元ファイル用
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
OP_FLAG_DEBUG	DB	0			;デバッグ有無
OP_FLAG_HELP	DB	0			;オプションフラグ－ヘルプ表示
OP_FLAG_FILE	DB	085H	DUP(00H)	;ファイル名（１２８＋４文字分）
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
;****************************************************************
;*		オプションフラグ立て				*
;****************************************************************
OPTION_ERROR_MSG	db	'オプションが不正です。',0dh,0ah,24h
OPTION_ERROR	proc	near
	lea	dx,[OPTION_ERROR_MSG]
	mov	ah,09h
	int	21h
	jmp	COMEND
OPTION_ERROR	endp
;****************************************************************
;*		オプションフラグ立て				*
;****************************************************************
;	使用レジスタ						*
;	ds:si	オプション文字列アドレス			*
;	es:di	フラグ位置					*
;	AX	汎用						*
;	CX	オプション文字列最終アドレス＋１		*
;****************************************************************
OPTION_FLAG	proc	near	uses ax bx cx dx di si ds es

	MOV	AX,CS			;
	MOV	DS,AX			;DS←CS
	MOV	ES,AX			;DS←CS

	MOV	ax,0000H		;
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
			JMP	OPTION_ERROR		;だったらエラー
		.endif

		lodsb

		.if	((al=='h')||(al=='H')||(al=='?'))
			MOV	AH,0FFh			;フラグ立て用。
			lea	di,[OP_FLAG_HELP]	;フラグアドレス
			call	OP_FLAG_SET
		.elseif	((al=='d')||(al=='D'))
			lea	di,[OP_FLAG_DEBUG]
			call	OP_Number_SET
		.else
			JMP	OPTION_ERROR		;無かったらエラー
		.endif

	.else
		lea	di,[OP_FLAG_FILE]	;ファイル
		call	OP_FILE_SET
	.endif

	.endw

	ret
OPTION_FLAG	endp
;----------------------------------------------------------------
OP_Number_SET	proc	near	uses ax bx dx
	.repeat
		mov	dx,si			;DX←オプションアドレス
		.if	(cx<dx)
			JMP	OPTION_ERROR	;無かったらエラー
		.endif
		CALL	ASC2HEX8		;AH←文字列（数値）
		mov	si,bx
	.until	(!(Carry?))
	call	OP_FLAG_SET
	ret
OP_Number_SET	endp
;----------------------------------------------------------------
OP_FLAG_SET	proc	near
	mov	[di],ah			;フラグセット
	ret
OP_FLAG_SET	endp
;----------------------------------------------------------------
OP_FILE_SET	proc	near	uses ax

	local	dotFlag:BYTE

	mov	al,[di]
	.if	(al!=0)
		JMP	OPTION_ERROR	;ファイル名が２つ書いてあるよぉ～
	.endif

	dec	si			;ポインタ一つ戻す
	mov	dotFlag,0

	.while	(cx>=si)
		lodsb
		.if	(al<21h)
			dec	si
			.break		;21h未満だったら終わり。
		.elseif	(al=='.')
			mov	dotFlag,1
		.endif
		stosb
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
	mov	al,24h
	stosb

	ret
OP_FILE_SET	endp
;****************************************************************
OPTION_DEBUG	proc	near	uses ax	;
	MOV	AL,CS:[OP_FLAG_DEBUG]	;
	MOV	CS:[D_Debug],AL		;設定
	RET				;RETURN
OPTION_DEBUG	endp			;
;****************************************************************
OPTION_HELP	proc	near
	lea	DX,[OP_HELP]		;表示
	MOV	AH,09H			;
	INT	21H			;
	JMP	COMEND			;プログラム終了
OPTION_HELP	endp			;
;****************************************************************
OPTION_FILE	proc	near	uses ax dx

;●ファイルのオープン
	MOV	al,0			;Read mode
	lea	dx,[OP_FLAG_FILE]	;DX←ファイル名アドレス
	call	File_Open		;
	mov	word ptr cs:[hAKAO_File],ax

;●ファイルのロード
	PUSH	DS			;
	MOV	ax,word ptr CS:[hAKAO_File]
	push	word ptr CS:[segAKAO_File]
	pop	DS			;
	MOV	dx,0000H		;
	call	File_Load		;
	POP	DS			;

;●ファイルのクローズ
	MOV	ax,WORD PTR CS:[hAKAO_File]
	call	File_Close		;

	RET				;RETURN
OPTION_FILE	endp			;
;****************************************************************
;*		オプション処理					*
;****************************************************************
Op_	proc	near	uses ax

	CALL	OPTION_FLAG		;フラグ立て
	MOV	AL,0			;チェック用

OP_L01:	CMP	CS:[OP_FLAG_DEBUG],AL	;一分音符分割数
	JZ	OP_L02			;
	CALL	OPTION_DEBUG		;

OP_L02:	CMP	CS:[OP_FLAG_HELP],AL	;ヘルプ表示
	JZ	OP_L03			;
	CALL	OPTION_HELP		;

OP_L03:	CMP	CS:[OP_FLAG_FILE],AL	;ファイル読み込み
	JZ	OP_L04			;
	CALL	OPTION_FILE		;
	jmp	OP_LEE			;

OP_L04:	jmp	COMEND			;ファイル名の指定が無ければ、

OP_LEE:	
	RET				;RETURN
Op_	endp
;=======================================================================|
;				Start Up				|
;=======================================================================|
_main	proc near

	call	ComSmole		;メモリの最小化

	mov	ax,01000h		;
	call	Memory_Open		;
	mov	word ptr cs:[segAKAO_File],ax

	call	Op_

	CALL	UN_MML_COMPAILE		;逆ＭＭＬコンパイル部

	mov	ax,word ptr cs:[segAKAO_File]
	call	Memory_Close		;メモリの解放

	ret
_main	endp
;************************************************************************
;*		終わり							*
;************************************************************************
CEND:
	END
