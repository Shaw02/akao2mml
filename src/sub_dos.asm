;=======================================================================|
;									|
;		MS-DOS function call sub routine			|
;									|
;=======================================================================|
;****************************************************************
;								*
;			メモリ関連				*
;								*
;****************************************************************
;---------------------------------------------------------------|
;		メモリ確保					|
;---------------------------------------------------------------|
;	●引数							|
;		ParaSize	割り当てたいパラグラム		|
;	●返り値						|
;		ax		割り当てたメモリのセグメント	|
;---------------------------------------------------------------|
Memory_Open	proc	near	uses bx cx di es,
	ParaSize:word

	MOV	bx,ParaSize		;データ領域の確保

	MOV	AH,48H			;
	INT	21H			;

	JNC	Memory_Open_Err		;割り当て失敗時に飛ぶ。
	call	File_Err		;
Memory_Open_Err:			;

	RET				;
Memory_Open	endp			;
;---------------------------------------------------------------|
;		メモリ開放					|
;---------------------------------------------------------------|
;	●引数							|
;		CloseSegment	開放するメモリのセグメント	|
;	●返り値						|
;		無し						|
;---------------------------------------------------------------|
Memory_Close	proc	near	uses ax es,
	CloseSegment:word

	mov	es,CloseSegment		;

	MOV	AH,49H			;
	INT	21H			;データ領域の開放

	JNC	Memory_Close_Err	;
	call	File_Err		;
Memory_Close_Err:			;

	RET				;
Memory_Close	endp			;
;****************************************************************
;								*
;			ファイル関連				*
;								*
;****************************************************************
;---------------------------------------------------------------|
;		ファイルの作成					|
;---------------------------------------------------------------|
;	●引数							|
;		cFilename	ファイルネームのポインタ	|
;		iAttr		ファイル属性			|
;	●返り値						|
;		ax	ハンドル				|
;---------------------------------------------------------------|
File_Create	proc	near	uses cx dx ds,
		cFilename:dword,
		iAttr:word

		lds	dx,cFilename
		mov	cx,iAttr
		mov	ah,3ch		;
		int	21h		;

		jnc	File_Create_Ok	;
		call	File_Err	;
File_Create_Ok:				;
		ret			;
File_Create	endp			;
;---------------------------------------------------------------|
;		ファイルのオープン				|
;---------------------------------------------------------------|
;	●引数							|
;		cFilename	ファイルネームのポインタ	|
;		cMode		0 ･･･ Read			|
;				1 ･･･ Write			|
;				2 ･･･ Randam			|
;	●返り値						|
;		ax	ハンドル				|
;---------------------------------------------------------------|
File_Open	proc	near	uses cx dx ds,
		cFilename:dword,
		cMode:byte

		lds	dx,cFilename
		mov	al,cMode

		mov	ah,3dh		;
		int	21h		;

		jnc	File_Open_Ok	;
		call	File_Err	;
File_Open_Ok:				;
		ret			;
File_Open	endp			;
;---------------------------------------------------------------|
;		ファイルのクローズ				|
;---------------------------------------------------------------|
;	●引数							|
;		hFile	ハンドル				|
;	●返り値						|
;		無し						|
;---------------------------------------------------------------|
File_Close	proc	near	uses ax bx,
		hFile:word

		mov	bx,hFile	;bx←ハンドル

		mov	ah,3eh		;
		int	21h		;

		jnc	File_Close_Ok	;
		call	File_Err	;
File_Close_Ok:				;
		ret			;
File_Close	endp			;
;---------------------------------------------------------------|
;		ファイルのロード				|
;---------------------------------------------------------------|
;	●引数							|
;		hFile	ハンドル				|
;		cBuff	バッファのアドレス			|
;	●返り値						|
;		ax	読み込めたバイト数			|
;---------------------------------------------------------------|
File_Load	proc	near	uses bx cx dx ds,
		hFile:word,
		cBuff:dword

		lds	dx,dword ptr cBuff
		mov	cx,0FFFFh	;全部読むよ？
		mov	bx,hFile	;bx←ハンドル
		mov	ah,3fh		;
		int	21h		;

		jnc	File_Load_Ok	;
		call	File_Err	;
File_Load_Ok:				;
		ret			;
File_Load	endp			;
;---------------------------------------------------------------|
;		ファイルのロード				|
;---------------------------------------------------------------|
;	●引数							|
;		hFile	ハンドル				|
;		cBuff	バッファのアドレス			|
;	●返り値						|
;		ax	読み込めたバイト数			|
;---------------------------------------------------------------|
File_Load_S	proc	near	uses bx cx dx ds,
		hFile:word,
		cBuff:dword,
		iSize:word

		lds	dx,dword ptr cBuff
		mov	cx,iSize	;全部読むよ？
		mov	bx,hFile	;bx←ハンドル
		mov	ah,3fh		;
		int	21h		;

		jnc	File_Load_S_Ok	;
		call	File_Err	;
File_Load_S_Ok:				;
		ret			;
File_Load_S	endp			;
;---------------------------------------------------------------|
;		ファイルのライト				|
;---------------------------------------------------------------|
;	●引数							|
;		hFile	ハンドル				|
;		iSize	書き込みバイト数			|
;		cBuff	バッファのアドレス			|
;	●返り値						|
;		無し						|
;---------------------------------------------------------------|
File_Write	proc	near	uses ax bx cx dx ds,
		hFile:word,
		iSize:word,
		cBuff:dword

		lds	dx,dword ptr cBuff
		mov	cx,iSize	;cx←サイズ
		mov	bx,hFile	;bx←ハンドル
		mov	ah,040h		;
		int	21h		;

		jnc	File_Write_Ok	;
		call	File_Err	;
File_Write_Ok:				;
		ret			;
File_Write	endp			;
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
ComSmole	proc	near	uses dx cx ds es	;メモリーの最小化
	
	MOV	ES,CS:[002CH]	;環境セグメントの開放
	MOV	AH,49H		;
	INT	21H		;
	.if	(carry?)
	jmp	File_Err
	.endif

	MOV	AX,CS		;
	MOV	DS,AX		;DS←CS
	MOV	ES,AX		;ES←CS
	mov	bx, offset DGROUP:STACK
	shr	bx, 4
	MOV	AH,04AH		;
	INT	21H		;最小化
	.if	(carry?)
	jmp	File_Err
	.endif

	ret			;RETURN
ComSmole	endp		;
;---------------------------------------------------------------|
;		ファイル名の拡張子変更				|
;---------------------------------------------------------------|
;	●引数							|
;		cFilename	拡張子付きファイル名		|
;		cExt		変更後の拡張子(3文字で)		|
;	●返り値						|
;		cFilename	拡張子変更後　ファイル名	|
;---------------------------------------------------------------|
ChangeExt	proc	near	uses ax cx si di ds es,
	cFilename:dword,
	cExt:dword

	les	di,cFilename
	lds	si,cExt

	mov	al,'.'			;
	mov	cx,085h			;
	repnz	scasb			;拡張子を捜す

	mov	cx,3			;
	rep	movsb			;
	mov	al,0			;
	stosb				;
	mov	al,24h			;
	stosb				;書き換える

	ret
ChangeExt	endp
;---------------------------------------------------------------|
;		カレントディレクトリの変更			|
;---------------------------------------------------------------|
;	●引数							|
;		cDirname	ディレクトリ名			|
;---------------------------------------------------------------|
.const
Current_Directory_Mess1	DB	'カレントディレクトリを',24h
Current_Directory_Mess2	DB	'に変更しました。',0dh,0ah,24h
.code
Change_Current_Directory	proc	near	uses ds es,
		cDirname:dword
	local	Current_Directory[128]:byte

	pusha

	;-------------------------------
	;カレントディレクトリあるか？
	lds	si,cDirname
	push	ss
	pop	es
	lea	di,[Current_Directory]
	xor	cx,cx
	xor	bx,bx
	push	si
	.repeat
	   lodsb
	   .if		(al=='\')
		mov	bx,cx	;一番最後の'\'をbxに記憶する。
	   .endif
	   inc	cx
	.until	(al<21h)
	pop	si

	;-------------------------------
	;カレントディレクトリ名を設定
	.if	(bx>0)
		mov	cx,bx
		cld
		rep	movsb
		mov	al,00H
		stosb
		mov	al,24H
		stosb

		;-------------------------------
		;カレントディレクトリを変更する。
		push	ss
		pop	ds
		lea	dx,[Current_Directory]
		mov	ah,3BH			;
		int	21h			;
		.if	(carry?)
		jmp	File_Err
		.endif
		push	cs
		pop	ds
		lea	dx,[Current_Directory_Mess1]
		mov	ah,09H			;
		int	21h			;

		push	ss			;
		pop	ds			;
		lea	dx,[Current_Directory]	;
		mov	ah,09H			;
		int	21h			;

		push	cs			;
		pop	ds			;
		lea	dx,[Current_Directory_Mess2]
		mov	ah,09H			;
		int	21h			;
	.endif
	;-------------------------------
	;終了

	popa
	ret				;
Change_Current_Directory	endp
;---------------------------------------------------------------|
;		エラー終了					|
;---------------------------------------------------------------|
;	●引数							|
;		ax Error Code					|
;---------------------------------------------------------------|
.const
Error_MsgOffset	dw	offset	Err_M00
		dw	offset	Err_M01
		dw	offset	Err_M02
		dw	offset	Err_M03
		dw	offset	Err_M04
		dw	offset	Err_M05
		dw	offset	Err_M06
		dw	offset	Err_M07
		dw	offset	Err_M08
		dw	offset	Err_M09
		dw	offset	Err_M0A
		dw	offset	Err_M0B
		dw	offset	Err_M0C
		dw	offset	Err_M0D
		dw	offset	Err_M0E
		dw	offset	Err_M0F

Err_M00	db	'Err=0x00:正常',0dh,0ah,24h
Err_M01	db	'Err=0x01:無効な機能コードです。',0dh,0ah,24h
Err_M02	db	'Err=0x02:ファイルが存在しません。',0dh,0ah,24h
Err_M03	db	'Err=0x03:指定されたパスが無効です',0dh,0ah,24h
Err_M04	db	'Err=0x04:オープンされているファイルが多いです。',0dh,0ah,24h
Err_M05	db	'Err=0x05:アクセスが拒否されました。',0dh,0ah,24h
Err_M06	db	'Err=0x06:指定されたファイルは、現在オープンされていません。',0dh,0ah,24h
Err_M07	db	'Err=0x07:Memory Control Blockが破壊されています。',0dh,0ah,24h
Err_M08	db	'Err=0x08:十分な大きさのメモリがありません。',0dh,0ah,24h
Err_M09	db	'Err=0x09:指定されたメモリーは、割り当てられていません。',0dh,0ah,24h
Err_M0A	db	'Err=0x0A:環境変数が32kByte以上あります。',0dh,0ah,24h
Err_M0B	db	'Err=0x0B:指定されたファイルのexeヘッダーが正しくありません。',0dh,0ah,24h
Err_M0C	db	'Err=0x0C:ファイルアクセスコードが0～2の範囲外です',0dh,0ah,24h
Err_M0D	db	'Err=0x0D:指定されたデバイスは無効です。',0dh,0ah,24h
Err_M0E	db	'Err=0x0E:？',0dh,0ah,24h
Err_M0F	db	'Err=0x0F:指定されたドライブ番号は無効です。',0dh,0ah,24h
.code
File_Err	proc	near

		push	ds
		push	dx
		push	ax
		mov	bx,offset Error_MsgOffset
		shl	ax,1			;
		add	bx,ax			;
		mov	dx,cs:[bx]		;
		push	cs			;
		pop	ds			;

		mov	AH,09H			;
		int	21H			;
		pop	ax
		pop	dx
		pop	ds

	.if	((ax==02h)||(ax==03h)||(ax==0Bh)||(ax==0Ch))
		mov	AH,09H			;
		int	21H			;
	.endif

		.exit
File_Err	endp
