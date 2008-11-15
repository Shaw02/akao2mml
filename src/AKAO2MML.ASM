;|==============================================================|
;|	ＦＩＮＡＬ　ＦＡＮＴＡＳＹ　VIII			|
;|		逆ＭＭＬコンパイラ				|
;|								|
;|				Programmed By			|
;|					－－－－		|
;|								|
;===============================================================|


assume	cs:code,ds:code,es:code,ss:code

code	segment

.186

	org	0100h

ff8mml_:	
	JMP	START
;************************************************************************
;*									*
;*		定義部							*
;*									*
;************************************************************************
ifdef	ff7	;------------------------
;FINAL FANTASY 7
VOICE_ADDRESS	EQU	0000H		
RIHTM_ADDRESS	EQU	0000H		
MUSIC_ADDRESS	EQU	0014H		
MUSIC_ADDRESSa	equ	+2
endif	;--------------------------------

ifdef	ff8	;------------------------
;FINAL FANTASY 2,7,8
VOICE_ADDRESS	EQU	0030H		
RIHTM_ADDRESS	EQU	0034H		
MUSIC_ADDRESS	EQU	0040H		
MUSIC_ADDRESSa	equ	0
endif	;--------------------------------

;************************************************************************
;*									*
;*		データ部						*
;*									*
;************************************************************************
BSTACK		EQU	0400H		;スタックバッファ
F_ADD		DW	?		;ファイル名格納アドレス
FILE_H		DW	?		;ファイルハンドル
DATSEG		DW	?		;割り当てたメモリのセグメント
;
;	逆ＭＭＬ変換情報
;
INCLUDE	AKAO2MML.INC			;情報
;************************************************************************
;*									*
;*		逆ＭＭＬ部						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		逆ＭＭＬ部メインルーチン			|
;---------------------------------------------------------------|
UN_MML_COMPAILE:		;
	CALL	UC_START	;初期設定
	CALL	UC_MML_OUTPUT	;ＭＭＬ出力部
	CALL	UC_END		;後期設定
	RET			;RETURN
;---------------------------------------------------------------|
;		初期変換					|
;---------------------------------------------------------------|
;	処理							|
;	１．タイトル、作曲、タイムベースの表示			|
;	２．データ解析						|
;		(1) 使用パート数				|
;---------------------------------------------------------------|
MML2MID_HED:
	DB	'#title     "		"',0dh,0ah
	DB	'#copyright "		(c)SQUARE"',0dh,0ah
	DB	'#timebase 48',0dh,0ah
	DB	0dh,0ah
	DB	0dh,0ah
	DB	'Z	EX x41,x10,x42,x12,{x40,x00,x7f,x00},xf7	r1'
	DB	0DH,0AH
	DB	0dh,0ah
	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	_-12 r1',0DH,0AH
	DB	0dh,0ah
	DB	'0A			C1 BR8',0Dh,0ah
	DB	'1A			C2 BR8',0Dh,0ah
	DB	'2A			C3 BR8',0Dh,0ah
	DB	'3A			C4 BR8',0Dh,0ah
	DB	'0B			C5 BR8',0Dh,0ah
	DB	'1B			C6 BR8',0Dh,0ah
	DB	'2B			C7 BR8',0Dh,0ah
	DB	'3B			C8 BR8',0Dh,0ah
	DB	'0C			C9 BR8',0Dh,0ah
	DB	'1C			C10BR8	'
	DB	'EX x41,x10,x42,x12,{x40,x10,x15,0},xF7',0Dh,0Ah
	DB	'2C			C11BR8',0Dh,0ah
	DB	'3C			C12BR8',0Dh,0ah
	DB	'0D			C13BR8',0Dh,0ah
	DB	'1D			C14BR8',0Dh,0ah
	DB	'2D			C15BR8',0Dh,0ah
	DB	'3D			C16BR8',0Dh,0ah
	DB	'0E	EExff,x21,1,1	C1 BR8',0Dh,0ah
	DB	'1E	EExff,x21,1,1	C2 BR8',0Dh,0ah
	DB	'2E	EExff,x21,1,1	C3 BR8',0Dh,0ah
	DB	'3E	EExff,x21,1,1	C4 BR8',0Dh,0ah
	DB	'0F	EExff,x21,1,1	C5 BR8',0Dh,0ah
	DB	'1F	EExff,x21,1,1	C6 BR8',0Dh,0ah
	DB	'2F	EExff,x21,1,1	C7 BR8',0Dh,0ah
	DB	'3F	EExff,x21,1,1	C8 BR8',0Dh,0ah
	DB	'0G	EExff,x21,1,1	C9 BR8',0Dh,0ah
	DB	'1G	EExff,x21,1,1	C10BR8	'
	DB	'EX x41,x10,x42,x12,{x40,x10,x15,0},xF7',0Dh,0Ah
	DB	'2G	EExff,x21,1,1	C11BR8',0Dh,0ah
	DB	'3G	EExff,x21,1,1	C12BR8',0Dh,0ah
	DB	'0H	EExff,x21,1,1	C13BR8',0Dh,0ah
	DB	'1H	EExff,x21,1,1	C14BR8',0Dh,0ah
	DB	'2H	EExff,x21,1,1	C15BR8',0Dh,0ah
	DB	'3H	EExff,x21,1,1	C16BR8',0Dh,0ah
	DB	0dh,0ah
	DB	'0A1A2A3A0B1B2B3B0C1C2C3C0D1D2D3D'
	DB	'0E1E2E3E0F1F2F3F0G1G2G3G0H1H2H3H	v127',0DH,0AH
	DB	0dh,0ah,24h

UC_START:
	MOV	DX,OFFSET MML2MID_HED	;
	MOV	AH,09H			;
	INT	21H			;
	
	MOV	AX,ES:[MUSIC_ADDRESS]	;使用パート数
	add	ax,MUSIC_ADDRESSa
	SHR	AX,1			;AX←AX/2
	MOV	CS:[UC_PART],AL		;

	RET				;
;---------------------------------------------------------------|
;		後期変換					|
;---------------------------------------------------------------|
;	処理							|
;	１．ＭＭＬ出力部でえた音色のマクロ定義文出力		|
;---------------------------------------------------------------|
UC_END_VOICE_ADD:
		DW	OFFSET UCE_VOICE_0A	
		DW	OFFSET UCE_VOICE_1A	
		DW	OFFSET UCE_VOICE_2A	
		DW	OFFSET UCE_VOICE_3A	
		DW	OFFSET UCE_VOICE_4A	
		DW	OFFSET UCE_VOICE_5A	
		DW	OFFSET UCE_VOICE_6A	
		DW	OFFSET UCE_VOICE_7A	
		DW	OFFSET UCE_VOICE_0B	
		DW	OFFSET UCE_VOICE_1B	
		DW	OFFSET UCE_VOICE_2B	
		DW	OFFSET UCE_VOICE_3B	
		DW	OFFSET UCE_VOICE_4B	
		DW	OFFSET UCE_VOICE_5B	
		DW	OFFSET UCE_VOICE_6B	
		DW	OFFSET UCE_VOICE_7B	
		DW	OFFSET UCE_VOICE_0C	
		DW	OFFSET UCE_VOICE_1C	
		DW	OFFSET UCE_VOICE_2C	
		DW	OFFSET UCE_VOICE_3C	
		DW	OFFSET UCE_VOICE_4C	
		DW	OFFSET UCE_VOICE_5C	
		DW	OFFSET UCE_VOICE_6C	
		DW	OFFSET UCE_VOICE_7C	
		DW	OFFSET UCE_VOICE_0D	
		DW	OFFSET UCE_VOICE_1D	
		DW	OFFSET UCE_VOICE_2D	
		DW	OFFSET UCE_VOICE_3D	
		DW	OFFSET UCE_VOICE_4D	
		DW	OFFSET UCE_VOICE_5D	
		DW	OFFSET UCE_VOICE_6D	
		DW	OFFSET UCE_VOICE_7D	
		DW	OFFSET UCE_VOICE_0E	
		DW	OFFSET UCE_VOICE_1E	
		DW	OFFSET UCE_VOICE_2E	
		DW	OFFSET UCE_VOICE_3E	
		DW	OFFSET UCE_VOICE_4E	
		DW	OFFSET UCE_VOICE_5E	
		DW	OFFSET UCE_VOICE_6E	
		DW	OFFSET UCE_VOICE_7E	
		DW	OFFSET UCE_VOICE_0F	
		DW	OFFSET UCE_VOICE_1F	
		DW	OFFSET UCE_VOICE_2F	
		DW	OFFSET UCE_VOICE_3F	
		DW	OFFSET UCE_VOICE_4F	
		DW	OFFSET UCE_VOICE_5F	
		DW	OFFSET UCE_VOICE_6F	
		DW	OFFSET UCE_VOICE_7F	
UCE_VOICE_0A	DB	'0a	k127	H0,2	@48',0dh,0ah,24h
UCE_VOICE_1A	DB	'1a	k127	H0,3	@1 ',0dh,0ah,24h
UCE_VOICE_2A	DB	'2a	k127	H0,3	@2 ',0dh,0ah,24h
UCE_VOICE_3A	DB	'3a	k127	H0,3	@3 ',0dh,0ah,24h
UCE_VOICE_4A	DB	'4a	k127	H0,3	@4 ',0dh,0ah,24h
UCE_VOICE_5A	DB	'5a	k127	H0,3	@5 ',0dh,0ah,24h
UCE_VOICE_6A	DB	'6a	k127	H0,3	@6 ',0dh,0ah,24h
UCE_VOICE_7A	DB	'7a	k127	H0,3	@7 ',0dh,0ah,24h
UCE_VOICE_0B	DB	'0b	k127	H0,3	@8 ',0dh,0ah,24h
UCE_VOICE_1B	DB	'1b	k127	H0,3	@9 ',0dh,0ah,24h
UCE_VOICE_2B	DB	'2b	k127	H0,3	@10',0dh,0ah,24h
UCE_VOICE_3B	DB	'3b	k127	H0,3	@11',0dh,0ah,24h
UCE_VOICE_4B	DB	'4b	k127	H0,3	@12',0dh,0ah,24h
UCE_VOICE_5B	DB	'5b	k127	H0,3	@13',0dh,0ah,24h
UCE_VOICE_6B	DB	'6b	k127	H0,3	@14',0dh,0ah,24h
UCE_VOICE_7B	DB	'7b	k127	H0,3	@15',0dh,0ah,24h
UCE_VOICE_0C	DB	'0c	k127	H0,3	@',24h
UCE_VOICE_1C	DB	'1c	k127	H0,3	@',24h
UCE_VOICE_2C	DB	'2c	k127	H0,3	@',24h
UCE_VOICE_3C	DB	'3c	k127	H0,3	@',24h
UCE_VOICE_4C	DB	'4c	k127	H0,3	@',24h
UCE_VOICE_5C	DB	'5c	k127	H0,3	@',24h
UCE_VOICE_6C	DB	'6c	k127	H0,3	@',24h
UCE_VOICE_7C	DB	'7c	k127	H0,3	@',24h
UCE_VOICE_0D	DB	'0d	k127	H0,3	@',24h
UCE_VOICE_1D	DB	'1d	k127	H0,3	@',24h
UCE_VOICE_2D	DB	'2d	k127	H0,3	@',24h
UCE_VOICE_3D	DB	'3d	k127	H0,3	@',24h
UCE_VOICE_4D	DB	'4d	k127	H0,3	@',24h
UCE_VOICE_5D	DB	'5d	k127	H0,3	@',24h
UCE_VOICE_6D	DB	'6d	k127	H0,3	@',24h
UCE_VOICE_7D	DB	'7d	k127	H0,3	@',24h
UCE_VOICE_0E	DB	'0e	k127	H0,3	@',24h
UCE_VOICE_1E	DB	'1e	k127	H0,3	@',24h
UCE_VOICE_2E	DB	'2e	k127	H0,3	@',24h
UCE_VOICE_3E	DB	'3e	k127	H0,3	@',24h
UCE_VOICE_4E	DB	'4e	k127	H0,3	@',24h
UCE_VOICE_5E	DB	'5e	k127	H0,3	@',24h
UCE_VOICE_6E	DB	'6e	k127	H0,3	@',24h
UCE_VOICE_7E	DB	'7e	k127	H0,3	@',24h
UCE_VOICE_0F	DB	'0f	k127	H0,3	@',24h
UCE_VOICE_1F	DB	'1f	k127	H0,3	@',24h
UCE_VOICE_2F	DB	'2f	k127	H0,3	@',24h
UCE_VOICE_3F	DB	'3f	k127	H0,3	@',24h
UCE_VOICE_4F	DB	'4f	k127	H0,3	@',24h
UCE_VOICE_5F	DB	'5f	k127	H0,3	@',24h
UCE_VOICE_6F	DB	'6f	k127	H0,3	@',24h
UCE_VOICE_7F	DB	'7f	k127	H0,3	@',24h
UCE_VOICE_cr	db	0dh,0ah,24h
UC_END:		
	XOR	CX,CX			;CL←0
	MOV	BX,VOICE_ADDRESS	;従属音色情報アドレス
	cmp	bx,0
	JZ	UC_END_L1		;無かったら終わり。
	MOV	DX,ES:[BX]		;
	CMP	DX,0000H		;従属音色有り？
	JZ	UC_END_L1		;無かったら終わり。
	ADD	BX,DX			;BX←従属音色情報先頭アドレス
UC_END_L0:
	MOV	AX,ES:[BX]		;読み込み
	CMP	AX,0FFFFH		;最後？
	JZ	UC_END_L1		;
	cmp	cx,16			;
	jz	UC_END_L1		;16個変換したら最後
	
	PUSH	BX			;
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'の表示
	MOV	DL,24H			;
	INT	21H			;
	MOV	DX,CS:[BX]		;DX←出力すべき文字列のアドレス
	MOV	AH,09H			;
	INT	21H			;出力
	POP	BX			;
	
	INC	BX			;
	INC	BX			;アドレスインクリメント
	INC	CX			;
	JMP	UC_END_L0		;
UC_END_L1:

	XOR	CX,CX			;CL←0
	MOV	BX,OFFSET UC_VOICE	;
UC_END_L2:
	MOV	AL,CS:[BX]		;AL←音色登録情報
	CMP	AL,0FFh			;情報終了検査
	JZ	UC_END_LE		;
	cmp	cx,32			;
	jz	UC_END_L1		;32個変換したら最後

	PUSH	BX			;
	push	ax
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,32			;
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'の表示
	MOV	DL,24H			;
	INT	21H			;
	MOV	DX,CS:[BX]		;DX←出力すべき文字列のアドレス
	MOV	AH,09H			;
	INT	21H			;出力
	pop	ax
	mov	ah,al
	call	hex2asc8
	MOV	AH,09H			;
	INT	21H			;出力

	mov	dx,offset UCE_VOICE_cr
	MOV	AH,09H			;
	INT	21H			;出力

	POP	BX			;
	INC	BX			;
	INC	CX			;
	JMP	UC_END_L2		;
UC_END_LE:
	RET
;---------------------------------------------------------------|
;		ＭＭＬ出力部					|
;---------------------------------------------------------------|
;	処理							|
;	１．ＭＭＬ出力						|
;	２．使用されている音色番号の記憶			|
;---------------------------------------------------------------|
UC_PART		DB	?			;パート数
UC_CR		DB	0Dh,0Ah,24h
UC_PART_ASC	DB	'0A	$'	;1ch
		DB	'1A	$'	;2ch
		DB	'2A	$'	;3ch
		DB	'3A	$'	;4ch
		DB	'0B	$'	;5ch
		DB	'1B	$'	;6ch
		DB	'2B	$'	;7ch
		DB	'3B	$'	;8ch
		DB	'0C	$'	;9ch
		DB	'1C	$'	;10ch
		DB	'2C	$'	;11ch
		DB	'3C	$'	;12ch
		DB	'0D	$'	;13ch
		DB	'1D	$'	;14ch
		DB	'2D	$'	;15ch
		DB	'3D	$'	;16ch
		DB	'0E	$'	;1ch
		DB	'1E	$'	;2ch
		DB	'2E	$'	;3ch
		DB	'3E	$'	;4ch
		DB	'0F	$'	;5ch
		DB	'1F	$'	;6ch
		DB	'2F	$'	;7ch
		DB	'3F	$'	;8ch
		DB	'0G	$'	;9ch
		DB	'1G	$'	;10ch
		DB	'2G	$'	;11ch
		DB	'3G	$'	;12ch
		DB	'0H	$'	;13ch
		DB	'1H	$'	;14ch
		DB	'2H	$'	;15ch
		DB	'3H	$'	;16ch
;
;			検索情報
;	0　	( Search End )
;	1-4	Address Add
;	8	If 0FE06h THEN Search END
;	9	Output '&$' ( and Search END )
;
UCMO_COMMAND_SIZE:				;
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;00h-0Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;10h-1Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;20h-2Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;30h-3Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;40h-4Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;50h-5Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;60h-6Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;70h-7Fh
	DB	0,0,0,0, 9,9,9,9, 9,9,9,9, 9,9,9,0	;80h-8Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,1,1, 1,1,1,1	;90h-9Fh
	DB	0,2,2,2, 3,2,1,1, 2,3,2,3, 2,2,2,2	;A0h-AFh
	DB	1,2,2,1, 4,2,1,1, 4,2,1,1, 3,2,1,1	;B0h-BFh
	DB	1,1,1,1, 1,1,1,1, 1,2,1,1, 1,1,1,1	;C0h-CFh
	DB	1,1,1,1, 1,1,1,1, 2,1,2,1, 1,1,3,1	;D0h-DFh
ifdef	ff7	;------------------------
	DB	0,0,0,0, 0,0,0,0, 3,1,1,1, 1,1,8,1	;E0h-EFh
	DB	1,1,1,1, 1,1,1,1, 1,1,0,0, 0,3,3,0	;F0h-FFh
endif	;--------------------------------
ifdef	ff8	;------------------------
	DB	1,1,1,1, 1,1,3,1, 1,1,1,1, 1,1,1,1	;E0h-EFh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 9,0,8,1	;F0h-FFh
endif	;--------------------------------
UCMO_ComStartFlag:
	db	0
UCMO_TAI_OUTPUT:			;
	DB	'&$'			;
UCMO_LOOP_OUTPUT:			;
	DB	'/*L1*/[$'		;
UCMO_LOOP_OUTPUT2:			;
	DB	'/*L2*/[$'		;
UC_MML_OUTPUT:
	MOV	CL,CS:[UC_PART]		;CL←使用パート数
	MOV	CH,0			;CH←現在のパート
UCMO_L00:
	PUSH	CX			;
	XOR	DX,DX			;
	MOV	DL,CH			;
	SHL	DX,1			;
	PUSH	DX			;アドレス計算用
	SHL	DX,1			;
	ADD	DX,OFFSET UC_PART_ASC	;AX←UC_PART_ASC + CH * 4
	MOV	AH,09H			;
	INT	21H			;パート表示

	POP	AX			;AX←パート番号＊２
	ADD	AX,MUSIC_ADDRESS	;AX←パート情報＋AX
	MOV	BX,AX			;
	MOV	BX,ES:[BX]		;BX←演奏アドレス（相対）
	add	bx,MUSIC_ADDRESSa	;
	ADD	BX,AX			;BX←演奏アドレス
	CALL	UCMO_LOOP_SEARCH	;
UCMO_L01:
	mov	byte ptr cs:[UCMO_ComStartFlag],1

	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS]	;ループアドレスリセット
	CMP	AX,BX				;同一？
	JNZ	UCMO_L01_1			;
	MOV	DX,OFFSET UCMO_LOOP_OUTPUT	;
	MOV	AH,09H				;
	INT	21H				;
UCMO_L01_1:
	cmp	cs:[UCMOLS_LOOP_flag],01h	;
	jnz	UCMO_L01_2
	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS2]	;ループアドレスリセット
	CMP	AX,BX				;同一？
	JNZ	UCMO_L01_2			;
	MOV	DX,OFFSET UCMO_LOOP_OUTPUT2	;
	MOV	AH,09H				;
	INT	21H				;
UCMO_L01_2:
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント
	SHL	AX,1			;
	PUSH	BX			;
	MOV	BX,OFFSET UC_DATA_ADDRESS
	ADD	BX,AX			;BX←変換情報アドレス格納アドレス
	MOV	DX,CS:[BX]		;DX←変換情報アドレス
	POP	BX			;
	jmp	UCMO_L03
UCMO_L02:
	mov	byte ptr cs:[UCMO_ComStartFlag],0
UCMO_L03:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;変換情報読み込み
	INC	BX			;
	XCHG	BX,DX			;

	CMP	AL,00h			
	JZ	UCMO_L01		
UCML_L10:
	CMP	AL,10h			
	JNZ	UCMO_L11		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント
	CALL	HEX2ASC8		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L11:
	CMP	AL,11h			
	JNZ	UCMO_L12		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント
	CALL	FH2A8			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L12:
	CMP	AL,12h			
	JNZ	UCMO_L13		
	PUSH	DX			;
	MOV	AX,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント
	INC	BX			;ポインタインクリメント
	CALL	HEX2ASC8		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L13:
	CMP	AL,13h			
	JNZ	UCMO_L20		
	PUSH	DX			;
	MOV	AX,ES:[BX]		;データ読み込み
	INC	BX			;ポインタインクリメント
	INC	BX			;ポインタインクリメント
	CALL	FH2A8			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L20:
	CMP	AL,20h			;
	JNZ	UCMO_L21		;

	cmp	byte ptr cs:[UCMO_ComStartFlag],1
	jnz	UCMO_L20_2

	;----------------------------------------
	mov	ah,es:[bx-1]		;コマンドが0x9A未満だったら
	cmp	ah,9ah			;
	jnc	UCMO_L20_2		;

	mov	ah,byte ptr cs:[UC_Step_work]
	cmp	ah,0			;音長設定の有無チェック
	jz	UCMO_L20_2		;

	XCHG	BX,DX			;
	push	dx

	mov	dl,cs:[bx]		;1文字表示
	mov	ah,02h			;
	int	21h			;

	mov	dl,'%'
	mov	ah,02h			;
	int	21h			;

	mov	ah,byte ptr cs:[UC_Step_work]
	call	hex2asc8
	mov	ah,09h
	int	21h			;

	mov	byte ptr cs:[UC_Step_work],0

	pop	dx			;
	XCHG	BX,DX			;

	jmp	UCMO_L20_1
	;----------------------------------------
UCMO_L20_2:
	PUSH	DX			;
	MOV	AH,09H			;表示
	INT	21H			;
	POP	DX			;
UCMO_L20_1:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;変換情報読み込み
	INC	BX			;
	XCHG	BX,DX			;
	CMP	AL,'$'			;
	JNZ	UCMO_L20_1		;
	JMP	UCMO_L02		;
UCMO_L21:
	CMP	AL,21h			;
	JZ	UCMO_L21_0		;
	JMP	UCMO_L24		;
UCMO_L21_0:				;
	PUSH	BX			;
	PUSH	DX			;
UCMO_L21_1:				;
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み　曲
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;データ読み込み　解析情報
	XCHG	BX,DX			;
	CMP	AL,0			;０：解析終了
	JZ	UCMO_L21_E		;
	CMP	AL,9			;９：次の音程とタイで繋ぐ。
	JNZ	UCMO_L21_2		;
	MOV	DX,OFFSET UCMO_TAI_OUTPUT
	MOV	AH,09H			;
	INT	21H			;
	JMP	UCMO_L21_E		;
UCMO_L21_2:				;
	CMP	AL,8			;
	JNZ	UCMO_L21_3		;
	MOV	AX,ES:[BX]		;
	CMP	AX,006FEH		;
	JZ	UCMO_L21_E		;
	CMP	AX,004FEH		;
	JNZ	UCMO_L21_2_1		;
	ADD	BX,2			;
	JMP	UCMO_L21_1		;
UCMO_L21_2_1:				;
	ADD	BX,4			;
	JMP	UCMO_L21_1		;
UCMO_L21_3:				;
	MOV	AH,0			;
	ADD	BX,AX			;
	JMP	UCMO_L21_1		;
UCMO_L21_E:				;
	POP	DX			;
	POP	BX			;
	JMP	UCMO_L02		;
UCMO_L24:
	CMP	AL,24h			;
	JNZ	UCMO_LF0		;
	XCHG	BX,DX			;
	PUSH	DX			;
	MOV	AH,02H			;
	MOV	DL,CS:[BX]		;表示情報読み込み
	INT	21H			;表示
	INC	BX			;
	POP	DX			;
	XCHG	BX,DX			;
	JMP	UCMO_L02		;
UCMO_LF0:
	CMP	AL,0F0h			
	JNZ	UCMO_LFF		
	INC	BX			;ポインタインクリメント
	JMP	UCMO_L02		;
UCMO_LFF:
	CMP	AL,0FFh			;
	JNZ	UCMO_LQQ		;
	PUSH	DX			;
	PUSH	BX			;
	MOV	BX,DX			;
	MOV	DX,CS:[BX]		;
	POP	BX			;
	CALL	DX			;
	POP	DX			;
	INC	DX			;
	INC	DX			;
	JMP	UCMO_L02		;
UCMO_LQQ:
	MOV 	DX,OFFSET UC_CR		;
	MOV	AH,09H	 		;
	INT	21H			;改行
	MOV	DX,OFFSET UC_CR		;
	MOV	AH,09H			;
	INT	21H			;改行

	POP	CX			;
	INC	CH			;パート番号インクリメント
	CMP	CL,CH			;パート終了？
	JZ	UCMO_END		;
	JMP	UCMO_L00		;
UCMO_END:				;
	RET				;RETURN
;---------------------------------------------------------------|
;		無限ループ解析					|
;---------------------------------------------------------------|
;	処理							|
;		無限ループアドレスを検索する。			|
;---------------------------------------------------------------|
UCMOLS_START_ADDRESS	DW	?
UCMOLS_LOOP_ADDRESS	DW	0000H
UCMOLS_LOOP_ADDRESS2	DW	0000H
UCMOLS_LOOP_flag	DB	00
UCMOLS_LOOP_flag1	DB	00
UCMOLS_LOOP_flag2	DB	00
UCMOLS_LOOP_bxwork	dw	0000h
UCMO_LOOP_SEARCH:
	PUSH	BX				;
	PUSH	CX				;レジスタ保存

UCMOL_0:MOV	AX,BX				;
	MOV	CS:[UCMOLS_START_ADDRESS],AX	;先頭アドレス保存
	XOR	AX,AX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;ループアドレスリセット
	mov	byte ptr cs:[UCMOLS_LOOP_flag],00h
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],00h
	mov	byte ptr cs:[UCMOLS_LOOP_flag2],00h

UCMOL_1:XOR	AX,AX			;
	MOV	AL,ES:[BX]		;データ読み込み　曲
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	MOV	AH,AL			;AH←コマンド
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;データ読み込み　解析情報
	XCHG	BX,DX			;
	CMP	AL,0			;
	JZ	UCMOL_KEY		;
	CMP	AL,9			;
	JZ	UCMOL_KEY		;
	JMP	UCMOL_2			;
UCMOL_KEY:
	MOV	AL,1			;・0F?h以外のコマンド
	CMP	AH,0F0h			;AL←1
	JC	UCMOL_K			;・0F?hのコマンド
	MOV	AL,2			;AL←2
UCMOL_K:CMP	AH,0A0h			;・0A0hのコマンド
	JNZ	UCMOL_2			;パート終了
	JMP	UCMOL_EE		;

UCMOL_2:CMP	AL,8			;
	JNZ	UCMOL_3			;
ifdef	ff7	;------------------------
	ADD	BX,1				;
	MOV	AX,ES:[BX]			;
	ADD	bx,2
	TEST	AX,AX				;
	JZ	UCMOL_EE			;If AX=0 Then Return
	ADD	AX,BX				;AX←ループ先アドレス
	MOV	BX,AX				;BX←AX
	jmp	UCMOL_E3
endif	;--------------------------------
ifdef	ff8	;------------------------
	MOV	AX,ES:[BX]		;
	CMP	AX,007FEH		;
	JZ	UCMOL_7			;
	CMP	AX,006FEH		;
	JZ	UCMOL_E			;
	CMP	AX,004FEH		;
	JNZ	UCMOL_2_1		;
	ADD	BX,2			;
	JMP	UCMOL_1			;
UCMOL_2_1:				;
	ADD	BX,4			;
	JMP	UCMOL_1			;
endif	;--------------------------------
UCMOL_3:				;
	MOV	AH,0			;
	ADD	BX,AX			;
	JMP	UCMOL_1			;
UCMOL_7:				;
	mov	byte ptr cs:[UCMOLS_LOOP_flag],01h
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],01h
	mov	byte ptr cs:[UCMOLS_LOOP_flag2],01h
	add	bx,5			;
	jmp	UCMOL_1			;
UCMOL_E:				;
	mov	ax,bx
	mov	word ptr cs:[UCMOLS_LOOP_bxwork],ax
	MOV	DX,BX				;DX←FE06hコマンドのアドレス
	ADD	BX,2				;
	MOV	AX,ES:[BX]			;
	TEST	AX,AX				;
	JZ	UCMOL_EE			;If AX=0 Then Return
	ADD	AX,BX				;AX←ループ先アドレス
	MOV	BX,AX				;BX←AX
	CMP	DX,AX				;AX < DX ?
	JNC	UCMOL_E1			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E1:
	MOV	DX,CS:[UCMOLS_START_ADDRESS]	;DX←先頭アドレス
	CMP	AX,DX				;AX <= DX
	JNC	UCMOL_E2			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E2:
	cmp	byte ptr cs:[UCMOLS_LOOP_flag1],01h	;
	jnz	UCMOL_E3			;
	MOV	AX,BX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS2],AX	;ループアドレスリセット
	mov	byte ptr cs:[UCMOLS_LOOP_flag1],00h	;

	mov	ax,word ptr cs:[UCMOLS_LOOP_bxwork]
	mov	bx,ax				;
	add	bx,4				;
	JMP	UCMOL_1				;
UCMOL_E3:
	MOV	AX,BX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;ループアドレスリセット
UCMOL_EE:
	POP	CX			;
	POP	BX			;
	RET
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
HEX2ASC8:
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
HEX2ASC16:
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
FH2A8:
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
FH2A16:
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
H2A8:
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
;************************************************************************
;*									*
;*		ファイルアクセス関係ルーチン				*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		ファイルのオープン				|
;---------------------------------------------------------------|
FILE_OPEN:				;
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
;---------------------------------------------------------------|
;		ファイル→メモリ転送（OPN Data）		|
;---------------------------------------------------------------|
FILE_READ:				;
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
;---------------------------------------------------------------|
;		ファイルのクローズ				|
;---------------------------------------------------------------|
FILE_CLOSE:				;
	MOV	BX,WORD PTR CS:[FILE_H]	;
	MOV	AH,3EH			;
	INT	21H			;
	JNC	FL004			;
	JMP	FILE_CLOSE_ERROR	;
FL004:	RET				;
;************************************************************************
;*									*
;*		メモリ関係						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		メモリ確保（OPN Data）				|
;---------------------------------------------------------------|
MEMORY_OPEN:				;
	MOV	AH,48H			;
	MOV	BX,1000H		;64KByte のデータ領域の確保
	INT	21H			;
	JNC	NOPERR			;割り当て失敗時に飛ぶ。
	JMP	MEMORY_OPEN_ERROR	;
NOPERR:	MOV	CS:[DATSEG],AX		;割り当てたセグメントアドレスの保存。
	MOV	ES,AX			;
	RET				;
;---------------------------------------------------------------|
;		メモリ開放（OPN Data）				|
;---------------------------------------------------------------|
MEMORY_CLOSE:				;
	MOV	AX,CS:[DATSEG]		;
	MOV	ES,AX			;セグメントを読む。
	MOV	AH,49H			;
	INT	21H			;データ領域の開放
	JNC	MCLRET			;
	JMP	MEMORY_CLOSE_ERROR	;
MCLRET:	RET				;
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
COMSML:				;メモリーの最小化
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
;************************************************************************
;*									*
;*		メインルーチン						*
;*									*
;************************************************************************
START:	
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
CEND:
CODE	ENDS
	END	ff8mml_
