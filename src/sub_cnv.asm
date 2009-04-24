;=======================================================================|
;									|
;	変換サブルーチン						|
;		10進（ASCII）	─　16進(BIN)				|
;		16進（BIN）	－　10進（ASCII）			|
;		16進（BIN）	－　16進（ASCII）			|
;									|
;					Programmed by			|
;						────		|
;									|
;=======================================================================|
;---------------------------------------------------------------|
;		かけ算ルーチン					|
;---------------------------------------------------------------|
;	引数							|
;		AH←かけられる数				|
;		AL←かける数					|
;	返り値							|
;		AX←答						|
;	コメント						|
;		掛け算命令が無いZ80とかのCPUで使う手法		|
;		8086なんだからMUL命令使えばいいじゃん		|
;		とか思うけど…まぁ、こうなってるからいいか。	|
;		本当に、昔に書いたルーチンなんだなぁ～。	|
;---------------------------------------------------------------|
KAKE8	proc	near			;
	PUSH	CX			;
	PUSH	DX			;レジスタ保存
	XOR	DX,DX			;DX←0000<h>
	MOV	CH,0			;CH←0
	MOV	CL,1			;CL←00000001<h>
KLOOP0:	TEST	AH,CL			;Bit check
	JZ	KLOOP1			;if 'L' then *KLOOP1
	CALL	KADD			;加算処理(DX+AL*2^CL)
KLOOP1:	INC	CH			;CH←CH+1
	SHL	CL,1			;CL Bit shift ←
	JNC	KLOOP0			;CL>128で終了
	MOV	AX,DX			;
	POP	DX			;
	POP	CX			;レジスタ復帰
	RET				;RETURN
KAKE8	endp				;
;		*************************
;		*	加算処理	*
;		*************************
KADD	proc	near			;DX ＝ DX+AL*2^CL
	PUSH	AX			;
	XOR	AH,AH			;AH←00h
	CMP	CH,1			;CH=1ならば加算のみ
	JC	KADD1			;
	PUSH	CX			;
	MOV	CL,CH			;
	SHL	AX,CL			;AX←AX*2^CH
	POP	CX			;
KADD1:	ADD	DX,AX			;DX←DX+AX
	POP	AX			;
	RET				;
KADD	endp
;---------------------------------------------------------------|
;		ASCII CODE→１６進コード(-127～255)		|
;---------------------------------------------------------------|
;	引数							|
;		DS:DX←変換したい文字列先頭アドレス		|
;	返り値							|
;		AH←変換後					|
;		DS:BX←次のアドレス				|
;---------------------------------------------------------------|
HEX_8	DB	00H,00H,00H		;
DHEX8	DB	00H			;
F8FLAG	DB	00H			;
ASC2HEX8	proc	near		;
	PUSH	CX			;
	PUSH	DX			;
	XOR	CX,CX			;CX←0
	MOV	BX,DX			;BX←DX（文字列先頭アドレス）
	MOV	DX,OFFSET HEX_8		;DX←変換用データバッファ
	XOR	AX,AX			;
	MOV	CS:[F8FLAG],AH		;符号フラグのリセット
	MOV	AH,DS:[BX]		;
	CMP	AH,'-'			;
	JNZ	A2H8L0			;
	INC	BX			;
	MOV	AH,0F8H			;Flag
	MOV	CS:[F8FLAG],AH		;Set
A2H8L0:	MOV	AH,DS:[BX]		;
	INC	BX			;
	SUB	AH,30H			;CHR CODE→HEX CODE
	JNC	A2H8L1			;AH<0　だったら一時変換終了
	JMP	A2H8E1			;
A2H8L1:	CMP	AH,10			;
	JC	A2H8L2			;AH>10 だったら一時変換終了
	JMP	A2H8E1			;
A2H8L2:	XCHG	BX,DX			;
	MOV	CS:[BX],AH		;保存
	INC	BX			;
	XCHG	BX,DX			
	INC	CL			;
	CMP	CL,3			;３回変換したら一時変換終了
	JZ	A2H8E0			;（最大３桁( 0~255)）
	JMP	A2H8L0			;
A2H8E1:
	DEC	BX			;
A2H8E0:
	CMP	CL,0			;数値文字（-, 0~9）があった場合
	JNZ	A2H8L3			;ジャンプ
	STC				;それ以外、
	INC	BX			;エラーで戻る
	JMP	A2H8EE			;
A2H8L3:					;
	MOV	CH,0			;
	MOV	CS:[DHEX8],CH		;
	MOV	CH,CL			;CH←一時変換で変換した文字数
	MOV	CL,3			;CL←桁計算用
	XCHG	BX,DX			;	3･10^0	2･10^1	1･10^2
A2H8L4:	
	DEC	BX			;
	MOV	AH,CS:[BX]		;
	CALL	A2H8AA			;桁計算
	DEC	CL			;
	DEC	CH			;
	JNZ	A2H8L4			;文字数分
	XCHG	BX,DX			;
	MOV	AH,CS:[DHEX8]		;
	CMP	CS:[F8FLAG],00H		;
	JZ	A2H8L5			;
	NEG	AH			;
A2H8L5:	CLC				;
A2H8EE:	POP	DX			;
	POP	CX			;
	RET				;

;	*	*	*	*	*	*	*	*

A2H8AA:					;
	CMP	CL,1			;CLが	１の場合
	JNZ	A2H8C1			;AX←AH*100
	MOV	AL,100			;
	JMP	A2H8C3			;
A2H8C1:	CMP	CL,2			;	２の場合
	JNZ	A2H8C2			;AX←AH*10
	MOV	AL,10			;
	JMP	A2H8C3			;
A2H8C2:	CMP	CL,3			;	３の場合
	JNZ	A2H8C4			;AX←AH*1
	MOV	AL,1			;
;	JMP	A2H8C3			;
A2H8C3:	CALL	KAKE8			;
	ADD	CS:[DHEX8],AL		;[DHEX8]←[DHEX8]*AX
	RET				;
A2H8C4:	MOV	CL,0			;ＣＬがそれ以外の場合
	XCHG	BX,DX			;エラー
	POP	DX			;
	MOV	DX,OFFSET A2H8EE	;
	PUSH	DX			;
	STC				;
	RET				;
ASC2HEX8	endp			;
;---------------------------------------------------------------|
;		ASCII CODE→１６進コード(-32767～65535)		|
;---------------------------------------------------------------|
;	引数							|
;		DS:DX←変換したい文字列先頭アドレス		|
;	返り値							|
;		AX←変換後					|
;		DS:BX←次のアドレス				|
;---------------------------------------------------------------|
HEX_16	DB	00H,00H,00H,00H,00H	;
DHEX16	DW	0000H			;
F6FLAG	DB	00H			;
ASC2HEX16	proc	near		;
	PUSH	CX			;
	PUSH	DX			;
	XOR	CX,CX			;CX←0
	MOV	BX,DX			;BX←DX（文字列先頭アドレス）
	MOV	DX,OFFSET HEX_16	;DX←変換用データバッファ
	XOR	AX,AX
	MOV	CS:[F6FLAG],AH
	MOV	AH,DS:[BX]
	CMP	AH,'-'
	JNZ	A2H6L0
	INC	BX
	MOV	AH,0F6H
	MOV	CS:[F6FLAG],AH
A2H6L0:	MOV	AH,DS:[BX]		;
	INC	BX			;
	SUB	AH,30H			;CHR CODE→HEX CODE
	JNC	A2H6L1			;AH<0　だったら一時変換終了
	JMP	A2H6E1			;
A2H6L1:	CMP	AH,10			;
	JC	A2H6L2			;AH>10 だったら一時変換終了
	JMP	A2H6E1			;
A2H6L2:	XCHG	BX,DX			
	MOV	CS:[BX],AH		;保存
	INC	BX			;
	XCHG	BX,DX			
	INC	CL			;
	CMP	CL,5			;５回変換したら一時変換終了
	JZ	A2H6E0			;
	JMP	A2H6L0			;
A2H6E1:
	DEC	BX			
A2H6E0:
	CMP	CL,0			
	JNZ	A2H6L3			
	STC				
	INC	BX			
	JMP	A2H6EE			
A2H6L3:					
	XOR	AX,AX			
	MOV	CS:[DHEX16],AX		
	MOV	CH,CL			
	MOV	CL,5			
	XCHG	BX,DX			
A2H6L4:	
	DEC	BX			
	XOR	AH,AH			
	MOV	AL,CS:[BX]		
	CALL	A2H6AA			
	DEC	CL			
	DEC	CH			
	JNZ	A2H6L4			
	XCHG	BX,DX			
	MOV	AX,CS:[DHEX16]		
	CMP	CS:[F6FLAG],00H		
	JZ	A2H6L5			
	NEG	AX			
A2H6L5:	CLC				
A2H6EE:	POP	DX			
	POP	CX			
	RET				

;	*	*	*	*	*	*	*	*

A2H6AA:					
	PUSH	DX			
	CMP	CL,1			
	JNZ	A2H6C1			
	MOV	DX,10000		
	JMP	A2H6C5			
A2H6C1:	CMP	CL,2			
	JNZ	A2H6C2			
	MOV	DX,1000			
	JMP	A2H6C5			
A2H6C2:	CMP	CL,3			
	JNZ	A2H6C3			
	MOV	DX,100			
	JMP	A2H6C5			
A2H6C3:	CMP	CL,4			
	JNZ	A2H6C4			
	MOV	DX,10			
	JMP	A2H6C5			
A2H6C4:	CMP	CL,5			
	JNZ	A2H6C6			
	MOV	DX,1			
;	JMP	A2H6C5			
A2H6C5:	MUL	DX			
	POP	DX			
	ADD	CS:[DHEX16],AX		
	RET				
A2H6C6:	MOV	CL,0			
	POP	DX			
	XCHG	BX,DX			
	POP	DX			
	MOV	DX,OFFSET A2H6EE	
	PUSH	DX			
	STC				
	RET				
ASC2HEX16	endp			
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
;		スペースで、右揃え				|
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
;---------------------------------------------------------------|
;		１６進数コード～ASCII CODE(FF)			|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１６進のアスキーコードに変換	|
;	引数							|
;		AL←変換したい数値				|
;	返り値							|
;		CS:DX←変換した文字列の先頭アドレス		|
;	コメント						|
;		この書き方は、書いたの近頃だ。			|
;---------------------------------------------------------------|
dat2hex8_Print	db	'00$'
dat2hex8	proc	near	uses ax

		mov	ah,al		;
		shr	al,4		;ah←下位4bit
		and	ax,0f0fh	;al←上位4bit

		cmp	al,0ah		;
		jc	dat2hex8_Low	;下位4bitは0x0A以下？
		add	al,7		;
dat2hex8_Low:				;
		cmp	ah,0ah		;
		jc	dat2hex8_Hi	;上位4bitは0x0A以下？
		add	ah,7		;
dat2hex8_Hi:				;
		add	ax,3030h	;

		mov	word ptr cs:[dat2hex8_Print],ax

		push	cs		;
		pop	ds		;ds:dx←far &(dat2hex8_Print)
		mov	dx,offset dat2hex8_Print

		ret			;
dat2hex8	endp			;

;---------------------------------------------------------------|
;		１６進数コード～ASCII CODE(FF)			|
;---------------------------------------------------------------|
;	処理							|
;		１６進コードを１６進のアスキーコードに変換	|
;	引数							|
;		ax←変換したい数値				|
;	返り値							|
;		CS:DX←変換した文字列の先頭アドレス		|
;	コメント						|
;		この書き方は、書いたの近頃だ。			|
;---------------------------------------------------------------|
dat2hex16_Print	db	'0000$'
dat2hex16	proc	near	uses ax

		mov	dx,ax		;
		shr	ax,4		; ax <- ---- FEDC BA98 7654
		and	dx,0f0fh	; dx <- ---- BA98 ---- 3210
		and	ax,0f0fh	; ax <- ---- FEDC ---- 7654

		.if	(dl>9)
			add	dl,7
		.endif

		.if	(dh>9)
			add	dh,7
		.endif

		.if	(al>9)
			add	al,7
		.endif

		.if	(ah>9)
			add	ah,7
		.endif

		add	dx,3030h
		add	ax,3030h

		xchg	dl,ah

		mov	word ptr cs:[dat2hex16_Print + 2],ax
		mov	ax,dx
		mov	word ptr cs:[dat2hex16_Print + 0],ax

		push	cs		;
		pop	ds		;ds:dx←far &(dat2hex8_Print)
		mov	dx,offset dat2hex16_Print

		ret			;
dat2hex16	endp			;

