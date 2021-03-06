ifdef	PS1	;------------------------
.const
;****************************************************************
;*								*
;*		プロジェクト名					*
;*								*
;****************************************************************

ifdef		ff7	;------------------------
ProjectName	equ	'FF7MML'
firstAkao	equ	1
comRepeatExit	equ	0F0h	; : コマンド

elseifdef	cd1	;------------------------
ProjectName	equ	'CD1MML'
firstAkao	equ	1
SubCommand	equ	0FCh
comRepeatExit	equ	0FC09h	; : コマンド

elseifdef	PE1	;------------------------
ProjectName	equ	'PE1MML'
midAkao		equ	1
SubCommand	equ	0FCh
comRepeatExit	equ	0FC09h	; : コマンド

else	;	ff8	;------------------------
ProjectName	equ	'FF8MML'
lastAkao	equ	1
SubCommand	equ	0FEh
comRepeatExit	equ	0FE09h	; : コマンド

endif	;--------------------------------



ifndef	lastAkao	;----------------
nlastAkao	equ	1

endif	;--------------------------------

;****************************************************************
;*								*
;*		出力ヘッダ					*
;*								*
;****************************************************************
MML2MID_HED	DB	'#title     ""',0dh,0ah
		DB	'#copyright "(c)SQUARE"',0dh,0ah
		db	0dh,0ah,24h



;****************************************************************
;*								*
;*		FINAL FANTASY 5 データ構造定義			*
;*								*
;*			条件コンパイル用			*
;*								*
;****************************************************************
;---------------------------------------
;◆アドレス関連
ifdef		firstAkao	;----------------
;FINAL FANTASY 7
PARTF_ADDRESS	equ	0010h		
VOICE_ADDRESS	EQU	0000H		
RIHTM_ADDRESS	EQU	0000H		
MUSIC_ADDRESS	EQU	0014H		
MUSIC_ADDRESSa	equ	+2

FixedVoice	equ	1		;音色番号固定
Rhythm12	equ	11		;パーカッション有無 ＆ 割る数
					;無い場合は、定義しない事

elseifdef	midAkao		;----------------
;Parasite Eve
PARTF_ADDRESS	equ	0010h		
VOICE_ADDRESS	EQU	0000H		
RIHTM_ADDRESS	EQU	0000H		
MUSIC_ADDRESS	EQU	0020H		
MUSIC_ADDRESSa	equ	+2

else	;	lastAkao	;----------------
;FINAL FANTASY 2,8,9
PARTF_ADDRESS	equ	0020h		
VOICE_ADDRESS	EQU	0030H		
RIHTM_ADDRESS	EQU	0034H		
MUSIC_ADDRESS	EQU	0040H		
MUSIC_ADDRESSa	equ	0

endif		;--------------------------------



;---------------------------------------
;◆コマンド関連
Music_Note	EQU	099h	;どこまで音譜？
comRepeatStart	equ	0C8h	; [ コマンド
comRepeatEnd	equ	0C9h	; ]n コマンド
comRepeatEnd2	equ	0CAh	; ]2 コマンド



;---------------------------------------
;◆音量・パンポット命令の引数のレンジ
;	定義しない場合	255
;	定義する場合	127	（shl	ah,1を実行）
ExpRange	equ	1	;音量 のレンジ
PanRange	equ	1	;パン のレンジ

;---------------------------------------
;◆テンポ命令の引数の係数
TempoMul	equ	1	;テンポの係数（分子）
TempoDiv	equ	218	;テンポの係数（分母）

;---------------------------------------
;◆テンポ・音量・パン命令の引数wLenghのtype
;Change_tLength	equ	1	;定義でword／未定義でbyte

;---------------------------------------
;◆LFO命令の引数Rateの係数
;LFO_DepthMul	equ	64	;LFO 周期の係数（分子）
;LFO_DepthDiv	equ	50	;LFO 周期の係数（分母）
;
;LFO_PitchCent	equ	100	;半音は100？
;LFO_DepthFirst	equ	1	;LFOは、Depthが最初

;---------------------------------------
;◆LFO命令の引数Rateの係数
;LFO_RateMul	equ	48	;LFO 周期の係数（分子）
;LFO_RateDiv	equ	40	;LFO 周期の係数（分母）

;---------------------------------------
;◆LFO命令の引数Delayの係数
;LFO_DelayMul	equ	48	;LFO 周期の係数（分子）
;LFO_DelayDiv	equ	24	;LFO 周期の係数（分母）

;---------------------------------------
;◆LFO命令の引数Delayの有無
LFO_PanDelay0	equ	1	;パンポットLFOに、引数Delay無し



;=======================================================================|
;			自動解析・検索用情報				|
;-----------------------------------------------------------------------|
;	0	音譜 … タイで繋がれない。				|
;	1-5	制御 … 解析中は特に気にしない（コマンド＋引数のbyte総数）
;	6	制御 … 条件ジャンプ					|
;	7	制御 … END of Channel （無限ループ無し）		|
;	8	制御 … END of Channel （無限ループ有り）		|
;	9	音譜 … タイで繋がれる					|
;=======================================================================|
UCMO_COMMAND_SIZE	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;00h-0Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;10h-1Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;20h-2Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;30h-3Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;40h-4Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;50h-5Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;60h-6Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;70h-7Fh
			DB	0,0,0,0, 9,9,9,9, 9,9,9,9, 9,9,9,0	;80h-8Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,1,1, 1,1,1,1	;90h-9Fh
			DB	7,2,2,2, 3,2,1,1, 2,3,2,3, 2,2,2,2	;A0h-AFh
			DB	3,2,2,1, 4,2,1,2, 4,2,1,2, 3,2,1,2	;B0h-BFh
			DB	2,2,1,1, 1,1,1,1, 1,2,1,1, 1,1,1,1	;C0h-CFh
			DB	1,1,2,2, 1,1,1,1, 2,2,2,1, 2,3,3,3	;D0h-DFh

ifdef		ff7	;------------------------
			DB	1,1,1,1, 1,1,1,1, 3,4,3,4, 3,1,8,4	;E0h-EFh
			DB	4,4,2,1, 3,1,2,3, 2,2,1,1, 3,3,3,1	;F0h-FFh
elseifdef	cd1	;------------------------
			DB	1,1,1,1, 1,1,1,1, 3,4,3,4, 3,1,8,4	;E0h-EFh
			DB	4,4,2,1, 3,1,2,3, 2,2,1,1, 6,3,3,1	;F0h-FFh
elseifdef	PE1	;------------------------
			DB	1,1,1,1, 1,1,1,1, 3,4,3,4, 3,1,8,4	;E0h-EFh
			DB	4,4,2,1, 3,1,2,3, 2,2,1,1, 6,3,3,1	;F0h-FFh
else	;	FF8	;------------------------
			DB	1,1,1,1, 1,1,3,1, 1,1,1,1, 1,1,1,1	;E0h-EFh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 9,0,6,1	;F0h-FFh
endif	;--------------------------------


ifdef	SubCommand	;----------------
SubComSize	db	4	;00	Tempo
		db	5	;01	Tempo Move
		db	4	;02	Reverb
		db	5	;03	Reverb Move
  ifdef	lastAkao	;-------
		db	2	;04	Percussion On
  else	;-----------------------
		db	4	;04	Percussion On
  endif	;-----------------------
		db	2	;05	Percussion Off
		db	4	;06	
		db	5	;07	
		db	4	;08
		db	5	;09	
		db	4	;0A
		db	4	;0B
		db	4	;0C
		db	4	;0D
		db	4	;0E
		db	4	;0F
		db	3	;10
		db	4	;11
		db	4	;12
		db	4	;13
  ifdef	lastAkao	;-------
		db	3	;14	Voice
  else	;-----------------------
		db	4	;14	Voice
  endif	;-----------------------
		db	4	;15
		db	4	;16
		db	4	;17
		db	4	;18
		db	4	;19
		db	4	;1A
		db	4	;1B
		db	3	;1C
		db	2	;1D
		db	2	;1E
		db	2	;1F

endif	;--------------------------------

;=======================================================================|
;		逆ＭＭＬ情報						|
;-----------------------------------------------------------------------|
;	（最初に変換アドレス＋１されている。）				|
;	00h	変換終了						|
;	10h	符号無しＢｙｔｅ変換	アドレス＋１			|
;	11h	符号有りＢｙｔｅ変換	アドレス＋１			|
;	12h	符号無しＷｏｒｄ変換	アドレス＋１			|
;	13h	符号有りＷｏｒｄ変換	アドレス＋１			|
;	20h	文字列出力　'$'まで出力する。				|
;	21h	次の発音はタイで繋がれるか検索				|
;	24h	次のコードの出力					|
;	80h	パート終了						|
;	F0h	アドレス＋１	（未解析コマンドの引き数）		|
;	FFh	次に示すアドレスをコールする				|
;=======================================================================|
UC_D00	DB	' c1$',21h,00h		;音程
UC_D01	DB	' c2$',21h,00h
UC_D02	DB	' c4$',21h,00h
UC_D03	DB	' c8$',21h,00h
UC_D04	DB	' c16$',21h,00h
UC_D05	DB	' c32$',21h,00h
UC_D06	DB	' c64$',21h,00h
UC_D07	DB	' c6$',21h,00h
UC_D08	DB	' c12$',21h,00h
UC_D09	DB	' c24$',21h,00h
UC_D0A	DB	' c48$',21h,00h
UC_D0B	DB	' c+1$',21h,00h
UC_D0C	DB	' c+2$',21h,00h
UC_D0D	DB	' c+4$',21h,00h
UC_D0E	DB	' c+8$',21h,00h
UC_D0F	DB	' c+16$',21h,00h
UC_D10	DB	' c+32$',21h,00h
UC_D11	DB	' c+64$',21h,00h
UC_D12	DB	' c+6$',21h,00h
UC_D13	DB	' c+12$',21h,00h
UC_D14	DB	' c+24$',21h,00h
UC_D15	DB	' c+48$',21h,00h
UC_D16	DB	' d1$',21h,00h
UC_D17	DB	' d2$',21h,00h
UC_D18	DB	' d4$',21h,00h
UC_D19	DB	' d8$',21h,00h
UC_D1A	DB	' d16$',21h,00h
UC_D1B	DB	' d32$',21h,00h
UC_D1C	DB	' d64$',21h,00h
UC_D1D	DB	' d6$',21h,00h
UC_D1E	DB	' d12$',21h,00h
UC_D1F	DB	' d24$',21h,00h
UC_D20	DB	' d48$',21h,00h
UC_D21	DB	' d+1$',21h,00h
UC_D22	DB	' d+2$',21h,00h
UC_D23	DB	' d+4$',21h,00h
UC_D24	DB	' d+8$',21h,00h
UC_D25	DB	' d+16$',21h,00h
UC_D26	DB	' d+32$',21h,00h
UC_D27	DB	' d+64$',21h,00h
UC_D28	DB	' d+6$',21h,00h
UC_D29	DB	' d+12$',21h,00h
UC_D2A	DB	' d+24$',21h,00h
UC_D2B	DB	' d+48$',21h,00h
UC_D2C	DB	' e1$',21h,00h
UC_D2D	DB	' e2$',21h,00h
UC_D2E	DB	' e4$',21h,00h
UC_D2F	DB	' e8$',21h,00h
UC_D30	DB	' e16$',21h,00h
UC_D31	DB	' e32$',21h,00h
UC_D32	DB	' e64$',21h,00h
UC_D33	DB	' e6$',21h,00h
UC_D34	DB	' e12$',21h,00h
UC_D35	DB	' e24$',21h,00h
UC_D36	DB	' e48$',21h,00h
UC_D37	DB	' f1$',21h,00h
UC_D38	DB	' f2$',21h,00h
UC_D39	DB	' f4$',21h,00h
UC_D3A	DB	' f8$',21h,00h
UC_D3B	DB	' f16$',21h,00h
UC_D3C	DB	' f32$',21h,00h
UC_D3D	DB	' f64$',21h,00h
UC_D3E	DB	' f6$',21h,00h
UC_D3F	DB	' f12$',21h,00h
UC_D40	DB	' f24$',21h,00h
UC_D41	DB	' f48$',21h,00h
UC_D42	DB	' f+1$',21h,00h
UC_D43	DB	' f+2$',21h,00h
UC_D44	DB	' f+4$',21h,00h
UC_D45	DB	' f+8$',21h,00h
UC_D46	DB	' f+16$',21h,00h
UC_D47	DB	' f+32$',21h,00h
UC_D48	DB	' f+64$',21h,00h
UC_D49	DB	' f+6$',21h,00h
UC_D4A	DB	' f+12$',21h,00h
UC_D4B	DB	' f+24$',21h,00h
UC_D4C	DB	' f+48$',21h,00h
UC_D4D	DB	' g1$',21h,00h
UC_D4E	DB	' g2$',21h,00h
UC_D4F	DB	' g4$',21h,00h
UC_D50	DB	' g8$',21h,00h
UC_D51	DB	' g16$',21h,00h
UC_D52	DB	' g32$',21h,00h
UC_D53	DB	' g64$',21h,00h
UC_D54	DB	' g6$',21h,00h
UC_D55	DB	' g12$',21h,00h
UC_D56	DB	' g24$',21h,00h
UC_D57	DB	' g48$',21h,00h
UC_D58	DB	' g+1$',21h,00h
UC_D59	DB	' g+2$',21h,00h
UC_D5A	DB	' g+4$',21h,00h
UC_D5B	DB	' g+8$',21h,00h
UC_D5C	DB	' g+16$',21h,00h
UC_D5D	DB	' g+32$',21h,00h
UC_D5E	DB	' g+64$',21h,00h
UC_D5F	DB	' g+6$',21h,00h
UC_D60	DB	' g+12$',21h,00h
UC_D61	DB	' g+24$',21h,00h
UC_D62	DB	' g+48$',21h,00h
UC_D63	DB	' a1$',21h,00h
UC_D64	DB	' a2$',21h,00h
UC_D65	DB	' a4$',21h,00h
UC_D66	DB	' a8$',21h,00h
UC_D67	DB	' a16$',21h,00h
UC_D68	DB	' a32$',21h,00h
UC_D69	DB	' a64$',21h,00h
UC_D6A	DB	' a6$',21h,00h
UC_D6B	DB	' a12$',21h,00h
UC_D6C	DB	' a24$',21h,00h
UC_D6D	DB	' a48$',21h,00h
UC_D6E	DB	' a+1$',21h,00h
UC_D6F	DB	' a+2$',21h,00h
UC_D70	DB	' a+4$',21h,00h
UC_D71	DB	' a+8$',21h,00h
UC_D72	DB	' a+16$',21h,00h
UC_D73	DB	' a+32$',21h,00h
UC_D74	DB	' a+64$',21h,00h
UC_D75	DB	' a+6$',21h,00h
UC_D76	DB	' a+12$',21h,00h
UC_D77	DB	' a+24$',21h,00h
UC_D78	DB	' a+48$',21h,00h
UC_D79	DB	' b1$',21h,00h
UC_D7A	DB	' b2$',21h,00h
UC_D7B	DB	' b4$',21h,00h
UC_D7C	DB	' b8$',21h,00h
UC_D7D	DB	' b16$',21h,00h
UC_D7E	DB	' b32$',21h,00h
UC_D7F	DB	' b64$',21h,00h
UC_D80	DB	' b6$',21h,00h
UC_D81	DB	' b12$',21h,00h
UC_D82	DB	' b24$',21h,00h
UC_D83	DB	' b48$',21h,00h
UC_D84	DB	' r1$',21h,00h		;タイで繋がれる
UC_D85	DB	' r2$',21h,00h		;同上	
UC_D86	DB	' r4$',21h,00h		;同上	
UC_D87	DB	' r8$',21h,00h		;同上	
UC_D88	DB	' r16$',21h,00h		;同上	
UC_D89	DB	' r32$',21h,00h		;同上	
UC_D8A	DB	' r64$',21h,00h		;同上	
UC_D8B	DB	' r6$',21h,00h		;同上	
UC_D8C	DB	' r12$',21h,00h		;同上	
UC_D8D	DB	' r24$',21h,00h		;同上	
UC_D8E	DB	' r48$',21h,00h		;同上	
UC_D8F	DB	' r1$',21h,00h
UC_D90	DB	' r2$',21h,00h
UC_D91	DB	' r4$',21h,00h
UC_D92	DB	' r8$',21h,00h
UC_D93	DB	' r16$',21h,00h
UC_D94	DB	' r32$',21h,00h
UC_D95	DB	' r64$',21h,00h
UC_D96	DB	' r6$',21h,00h
UC_D97	DB	' r12$',21h,00h
UC_D98	DB	' r24$',21h,00h
UC_D99	DB	' r48$',21h,00h
UC_D9A	DB	' /*9A*/$',00h
UC_D9B	DB	' /*9B*/$',00h
UC_D9C	DB	' /*9C*/$',00h
UC_D9D	DB	' /*9D*/$',00h
UC_D9E	DB	' /*9E*/$',00h
UC_D9F	DB	' /*9F*/$',00h

UC_DA0	DB	0FFh
	dw	offset UC_End
	db	00h			;終了

UC_DA1	DB	24h,24h,0FFH		;音色	'$'の出力
	DW	OFFSET UC_VOICE_OUTPUT	;	マクロ番号出力
	DB	00h			;	使用マクロ記憶

UC_DA2	DB	0ffH			;次の音符の音長指定
	DW	OFFSET UC_Step
	DB	00h

UC_DA3	DB	' v$',0FFh		;音量（ただしリニア）
	DW	OFFSET UC_Volume	
	DB	00h			

UC_DA4	DB	' UB1,$',0ffh		;ポルタメント
	dw	offset UC_portamento	;
	db	00h			;

UC_DA5	DB	' o$',0FFh		;オクターブ
	DW	offset UC_Octave	
	DB	0

UC_DA6	DB	' >$',00h		;オクターブアップ
UC_DA7	DB	' <$',00h		;オクターブダウン

UC_DA8	DB	' E$',0FFh		;expression
	DW	OFFSET UC_SAVE_E	
	DB	00h

UC_DA9	DB	0FFh			;expression move
	DW	OFFSET UC_Expression
	DB	00h

UC_DAA	DB	' p$',0FFh		;panpot
	DW	OFFSET UC_SAVE_P
	DB	00h

UC_DAB	DB	0FFh			;panpot move
	DW	OFFSET UC_Panpot
	DB	00h

UC_DAC	DB	' /*AC,$',010h,' */$',00h	;不明
UC_DAD	DB	' /*AD(AL),$',010h,' */$',00h	;不明
UC_DAE	DB	' /*AE(DL),$',010h,' */$',00h	;不明
UC_DAF	DB	' /*AF(SL),$',010h,' */$',00h	;不明
UC_DB0	DB	' /*B0,$',010h,' ,$',010h,' */$',00h		;
UC_DB1	DB	' /*B1(SR),$',010h,' */$',00h	;不明
UC_DB2	DB	' /*B2(RR),$',010h,' */$',00h	;不明
UC_DB3	DB	' /*B3*/$',00h					;エンベロープ

UC_DB4	DB	' IW$',0FFh					;LFO
	dw	offset UC_LFO_PitchBend				;
	db	00h						;

UC_DB5	DB	' IW$',0FFh					;LFO Depth
	dw	offset UC_LFO_PitchBendDepth			;
	db	00h						;

UC_DB6	DB	' IW0$',00h					;LFO off

UC_DB7	DB	' /*B7,$',010h,' */$',00h			;

UC_DB8	DB	' IE$',0ffh					;
	dw	offset UC_LFO_Expression			;
	db	00h						;

UC_DB9	DB	' IE$',0ffh					;
	dw	offset UC_LFO_ExpressionDepth			;
	db	00h						;

UC_DBA	DB	' IE0$',00h					;

UC_DBB	DB	' /*BB,$',010h,' */$',00h			;

UC_DBC	DB	' IP$',0ffh					;
	dw	offset UC_LFO_Panpot				;
	db	' $',00h					;

UC_DBD	DB	' IP$',0ffh					;
	dw	offset UC_LFO_PanpotDepth			;
	db	' $',00h					;

UC_DBE	DB	' IP0$',00h					;

UC_DBF	DB	' /*BF,$',010h,' */$',00h			;

UC_DC0	DB	' _$',11h,00h
UC_DC1	DB	' __$',11h,00h

UC_DC2	DB	' y91,100$',00h		;Reverb on
UC_DC3	DB	' y91,0$',00h		;Reverb off

UC_DC4	DB	' /*C4(Non)*/$',00h	;Noise on
UC_DC5	DB	' /*C5(Noff)*/$',00h	;Noise off
UC_DC6	DB	' /*C6(Mon)*/$',00h	;modulation on
UC_DC7	DB	' /*C7(Moff)*/$',00h	;modulation off

UC_DC8	DB	0FFh
	DW	OFFSET Loop_Start
	DB	00h

UC_DC9	DB	0FFh
	DW	OFFSET Loop_End
	DB	00h

UC_DCA	DB	0FFh
	DW	OFFSET Loop_End2
	DB	00h

UC_DCB	DB	' /*CB*/$',00h

UC_DCC	DB	' /*P*/$',00h		;スラー開始
UC_DCD	DB	' /*X*/$',00h		;スラー終了

UC_DCE	DB	' /*CE*/$',00h
UC_DCF	DB	' /*CF*/$',00h
UC_DD0	DB	' /*D0*/$',00h
UC_DD1	DB	' /*D1*/$',00h
UC_DD2	DB	' /*D2,$',010h,' */$',00h	;不明
UC_DD3	DB	' /*D3,$',010h,' */$',00h	;不明
UC_DD4	DB	' /*D4*/$',00h
UC_DD5	DB	' /*D5*/$',00h
UC_DD6	DB	' /*D6*/$',00h
UC_DD7	DB	' /*D7*/$',00h

UC_DD8	DB	' BW$',0FFh		;ディチューン
	DW	offset UC_Detune
	DB	00h

UC_DD9	DB	' BW$',11h,00h		;相対ディチューン

UC_DDA	DB	' /*DA,$',010h,' */$',00h	;不明
UC_DDB	DB	' /*DB*/$',00h
UC_DDC	DB	' /*DC,$',010h,' */$',00h	;不明
UC_DDD	DB	' /*DD,$',012h,' */$',00h	;
UC_DDE	DB	' /*DE,$',012h,' */$',00h	;
UC_DDF	DB	' /*DF,$',012h,' */$',00h	;不明

ifdef	nlastAkao	;------------------------
UC_DE0	DB	' /*E0*/$',80h,00h
UC_DE1	DB	' /*E1*/$',80h,00h
UC_DE2	DB	' /*E2*/$',80h,00h
UC_DE3	DB	' /*E3*/$',80h,00h
UC_DE4	DB	' /*E4*/$',80h,00h
UC_DE5	DB	' /*E5*/$',80h,00h
UC_DE6	DB	' /*E6*/$',80h,00h
UC_DE7	DB	' /*E7*/$',80h,00h

UC_DE8	DB	0FFh				;テンポ(FF7)
	dw	offset UC_Tempo			;
	db	00h				;

UC_DE9	DB	0FFh				;相対テンポ(FF7)
	dw	offset UC_RelativeTempo		;
	db	00h				;

UC_DEA	DB	0FFh				;リバーブ
	dw	offset UC_Reverb		;
	db	00h				;

UC_DEB	DB	0FFh				;相対リバーブ
	dw	offset UC_RelativeReverb	;
	db	00h				;

ifdef	firstAkao	;---------------
UC_DEC	DB	0ffh
	dw	offset UC_Rhythm_on
	db	0
UC_DED	db	0ffh
	dw	offset UC_Rhythm_off
	db	0				;パーカッション off
else	;-------------------------------
UC_DEC	DB	0ffh
	dw	offset UC_PercussionOn
	db	0
UC_DED	db	0ffh
	dw	offset UC_PercussionOff
	db	0				;パーカッション off
endif	;-------------------------------

UC_DEE	DB	0FFh				;無限ループ(FF7)
	dw	offset UC_PermanentLoop	;
	db	00h				;

UC_DEF	DB	' /*EF,$',010h,' ,$',010h,' ,$',010h,' */$',00h	;

UC_DF0	DB	0FFh				;ループ抜け
	dw	offset Loop_Exit		;
	db	00h				;

UC_DF1	DB	' /*F1,$',010h,' ,$',010h,' ,$',010h,' */$',00h	;

UC_DF2	DB	24h,24h,0FFH			;音色	'$'の出力
	DW	OFFSET UC_VOICE_OUTPUT		;	マクロ番号出力
	DB	00h				;	使用マクロ記憶

UC_DF3	DB	' /*F3*/$',00h
UC_DF4	DB	' /*F4,$',010h,' ,$',010h,' */$',00h	;不明
UC_DF5	DB	' /*F5*/$',00h
UC_DF6	DB	' /*F6,$',010h,' */$',00h	;不明
UC_DF7	DB	' /*F7,$',010h,' ,$',010h,' */$',00h	;不明
UC_DF8	DB	' /*F8,$',010h,' */$',00h	;不明
UC_DF9	DB	' /*F9,$',010h,' */$',00h	;不明
UC_DFA	DB	' /*FA*/$',80h,00h
UC_DFB	DB	' /*FB*/$',80h,00h

ifdef	ff7	;------------------------
UC_DFC	DB	0FFh				;拡張音色
	DW	offset UC_VoiceEx		;
	DB	00h				;
else	;--------------------------------
UC_DFC	DB	0FFh
	DW	OFFSET UCDFF_LSTART
	DB	00h
endif	;--------------------------------

UC_DFD	DB	0ffh				;拍子
	dw	offset UC_Beat			;
	db	0				;

UC_DFE	DB	0ffh				;リハーサル番号
	dw	offset UC_Measures		;
	db	0				;

UC_DFF	DB	' /*FF*/$',80h,00h

else	;(lastAkao)--------------------------------
UC_DE0	DB	' /*E0*/$',00h
UC_DE1	DB	' /*E1,$',010h,' */$',00h	;不明
UC_DE2	DB	' /*E2*/$',00h
UC_DE3	DB	' /*E3*/$',00h
UC_DE4	DB	' /*E4*/$',00h
UC_DE5	DB	' /*E5*/$',00h
UC_DE6	DB	' /*E6,$',010h,' ,$',010h,' */$',00h	
UC_DE7	DB	' /*E7*/$',00h
UC_DE8	DB	' /*E8*/$',00h
UC_DE9	DB	' /*E9*/$',00h
UC_DEA	DB	' /*EA*/$',00h
UC_DEB	DB	' /*EB*/$',00h
UC_DEC	DB	' /*EC*/$',00h
UC_DED	DB	' /*ED*/$',00h
UC_DEE	DB	' /*EE*/$',00h
UC_DEF	DB	' /*EF*/$',00h

UC_DF0	DB	' c%$',10h,21h,00h
UC_DF1	DB	' c+%$',10h,21h,00h
UC_DF2	DB	' d%$',10h,21h,00h
UC_DF3	DB	' d+%$',10h,21h,00h
UC_DF4	DB	' e%$',10h,21h,00h
UC_DF5	DB	' f%$',10h,21h,00h
UC_DF6	DB	' f+%$',10h,21h,00h
UC_DF7	DB	' g%$',10h,21h,00h
UC_DF8	DB	' g+%$',10h,21h,00h
UC_DF9	DB	' a%$',10h,21h,00h
UC_DFA	DB	' a+%$',10h,21h,00h
UC_DFB	DB	' b%$',10h,21h,00h
UC_DFC	DB	' r%$',10h,21h,00h	;タイで繋がれる。
UC_DFD	DB	' r%$',10h,21h,00h

UC_DFE	DB	0FFh
	DW	OFFSET UCDFF_LSTART
	DB	00h

UC_DFF	DB	' /*FF*/$',00h		;不明
endif	;--------------------------------



;****************************************************************
;*		シーケンス					*
;****************************************************************
;===============================================================
;	0xFE系コマンドの処理	(AKAO32)
;===============================================================

.const
ifdef	lastAkao	;----------------
UCDFF_Mst	DB	'/*FE,$'
else	
UCDFF_Mst	DB	'/*FC,$'
endif	;--------------------------------
UCDFF_Med	DB	'*/$'

.code
UCDFF_unknown	proc	near	uses cx,
		iLoop:WORD

		mov	cx,iLoop

		push	ax
		lea	DX,[UCDFF_Mst]
		MOV	AH,09H		;
		INT	21H		;
		pop	ax

		mov	ah,al
		call	hex2asc8
		MOV	AH,09H		;
		INT	21H		;

		.while	(cx > 0)
		MOV	DL,2CH		;','の出力
		MOV	AH,02H		;
		INT	21H		;

		MOV	AH,ES:[BX]	;
		INC	BX		;
		call	hex2asc8
		MOV	AH,09H		;
		INT	21H		;
		dec	cx
		.endw

		lea	DX,[UCDFF_Med]
		MOV	AH,09H		;
		INT	21H		;

		ret
UCDFF_unknown	endp

;===============================================================
UCDFF_unknown0	proc	near
		invoke	UCDFF_unknown	,0
		ret
UCDFF_unknown0	endp

;===============================================================
UCDFF_unknown1	proc	near
		invoke	UCDFF_unknown	,1
		ret
UCDFF_unknown1	endp

;===============================================================
UCDFF_unknown2	proc	near
		invoke	UCDFF_unknown	,2
		ret
UCDFF_unknown2	endp

;===============================================================
.const
UCDFF_Addr	dw	offset	UC_Tempo		;0x00	Tempo
UCDFF_Addr_01	dw	offset	UC_RelativeTempo	;0x01	Tempo（相対）
UCDFF_Addr_02	dw	offset	UC_Reverb		;0x02	Reverb
UCDFF_Addr_03	dw	offset	UC_RelativeReverb	;0x03	Reverb（相対）
ifdef	firstAkao	;------------------------
UCDFF_Addr_04	dw	offset	UC_Rhythm_on		;0x04	Perc on
UCDFF_Addr_05	dw	offset	UC_Rhythm_off		;0x05	Perc off
else	;----------------------------------------
UCDFF_Addr_04	dw	offset	UC_PercussionOn		;0x04	パーカッション on
UCDFF_Addr_05	dw	offset	UC_PercussionOff	;0x05	パーカッション off
endif	;----------------------------------------
UCDFF_Addr_06	dw	offset	UC_PermanentLoop	;0x06	無条件ジャンプ
UCDFF_Addr_07	dw	offset	UC_ConditionalJump	;0x07	条件ジャンプ
UCDFF_Addr_08	dw	offset	UCDFF_unknown2		;0x08	
UCDFF_Addr_09	dw	offset	Loop_Exit		;0x09	
UCDFF_Addr_0A	dw	offset	UCDFF_unknown2
UCDFF_Addr_0B	dw	offset	UCDFF_unknown2
UCDFF_Addr_0C	dw	offset	UCDFF_unknown2
UCDFF_Addr_0D	dw	offset	UCDFF_unknown2
UCDFF_Addr_0E	dw	offset	UCDFF_unknown2
UCDFF_Addr_0F	dw	offset	UCDFF_unknown2
UCDFF_Addr_10	dw	offset	UCDFF_unknown1
UCDFF_Addr_11	dw	offset	UCDFF_unknown2
UCDFF_Addr_12	dw	offset	UCDFF_unknown2
UCDFF_Addr_13	dw	offset	UCDFF_unknown2
UCDFF_Addr_14	dw	offset	UC_VoiceEx		;0x14	音色
UCDFF_Addr_15	dw	offset	UC_Beat			;0x15	拍子
UCDFF_Addr_16	dw	offset	UC_Measures		;0x16	リハーサル番号
UCDFF_Addr_17	dw	offset	UCDFF_unknown2
UCDFF_Addr_18	dw	offset	UCDFF_unknown2
UCDFF_Addr_19	dw	offset	UCDFF_unknown2
UCDFF_Addr_1A	dw	offset	UCDFF_unknown2
UCDFF_Addr_1B	dw	offset	UCDFF_unknown2
UCDFF_Addr_1C	dw	offset	UCDFF_unknown1
UCDFF_Addr_1D	dw	offset	UCDFF_unknown0
UCDFF_Addr_1E	dw	offset	UCDFF_unknown0
UCDFF_Addr_1F	dw	offset	UCDFF_unknown0

.code
UCDFF_LSTART	proc	near
	xor	ax,ax
	MOV	AL,ES:[BX]	;データ読み込み
	INC	BX		;

	.if	(al < 20h)
		push	bx
		push	ax
		shl	ax, 1
		mov	bx, ax
		mov	dx, cs:[UCDFF_Addr + bx]
		pop	ax
		pop	bx
		call	dx
	.else
		invoke	UCDFF_unknown,	2
	.endif

	ret
UCDFF_LSTART	endp

;===============================================================
endif	;--------------------------------
