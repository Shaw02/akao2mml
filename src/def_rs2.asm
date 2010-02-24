ifdef	rs2	;------------------------
.const
;****************************************************************
;*								*
;*		プロジェクト名					*
;*								*
;****************************************************************
ProjectName	equ	'RS2MML'



;****************************************************************
;*								*
;*		出力ヘッダ					*
;*								*
;****************************************************************
MML2MID_HED	DB	'#title     "Romancing Saga 2  "',0dh,0ah
		DB	'#copyright "　　(c)SQUARE"',0dh,0ah
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
MUSIC_START	EQU	1D00h	;データの位置	無い場合は、定義しない事
MUSIC_EOF	EQU	1D02h	;データの位置	無い場合は、定義しない事
MUSIC_ADDRESS	EQU	1D04h	;ヘッダーの位置
MUSIC_DATA	EQU	1D24h	;データの位置

;---------------------------------------
;◆コマンド関連
Music_Note	EQU	0C3h	;どこまで音譜？
comRepeatStart	equ	0E2h	; [ コマンド
comRepeatExit	equ	0F6h	; : コマンド
comRepeatEnd	equ	0E3h	; ] コマンド

;Rhythm12	equ	14	;パーカッション有無 ＆ 割る数
				;無い場合は、定義しない事

;---------------------------------------
;◆音量・パンポット命令の引数のレンジ
;	定義しない場合	255
;	定義する場合	127	（shl	ah,1を実行）
;ExpRange	equ	1	;音量 のレンジ
;PanRange	equ	1	;パン のレンジ

;---------------------------------------
;◆テンポ命令の引数の係数
TempoMul	equ	60000	;テンポの係数（分子）
TempoDiv	equ	55296	;テンポの係数（分母）

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
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;80h-8Fh
			DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;90h-9Fh
			DB	0,0,0,0, 0,0,0,0, 9,9,9,9, 9,9,9,9	;A0h-AFh
			DB	9,9,9,9, 9,9,0,0, 0,0,0,0, 0,0,0,0	;B0h-BFh
			DB	0,0,0,0, 2,3,2,3, 3,4,1,4, 1,3,1,2	;C0h-CFh
			DB	1,1,1,1, 1,1,2,1, 1,2,2,2, 2,2,2,2	;D0h-DFh
			DB	2,1,2,1, 1,1,1,1, 2,2,2,7, 1,1,1,1	;E0h-EFh
			DB	2,3,2,3, 3,1,4,8, 2,2,1,1, 1,1,1,1	;F0h-FFh

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
UC_D00	DB	' c1$' ,21h,0
UC_D01	DB	' c2$' ,21h,0
UC_D02	DB	' c3$' ,21h,0
UC_D03	DB	' c4.$',21h,0
UC_D04	DB	' c4$' ,21h,0
UC_D05	DB	' c6$' ,21h,0
UC_D06	DB	' c8.$',21h,0
UC_D07	DB	' c8$' ,21h,0
UC_D08	DB	' c12$',21h,0
UC_D09	DB	' c16$',21h,0
UC_D0A	DB	' c24$',21h,0
UC_D0B	DB	' c32$',21h,0
UC_D0C	DB	' c48$',21h,0
UC_D0D	DB	' c64$',21h,0

UC_D0E	DB	' c+1$' ,21h,0
UC_D0F	DB	' c+2$' ,21h,0
UC_D10	DB	' c+3$' ,21h,0
UC_D11	DB	' c+4.$',21h,0
UC_D12	DB	' c+4$' ,21h,0
UC_D13	DB	' c+6$' ,21h,0
UC_D14	DB	' c+8.$',21h,0
UC_D15	DB	' c+8$' ,21h,0
UC_D16	DB	' c+12$',21h,0
UC_D17	DB	' c+16$',21h,0
UC_D18	DB	' c+24$',21h,0
UC_D19	DB	' c+32$',21h,0
UC_D1A	DB	' c+48$',21h,0
UC_D1B	DB	' c+64$',21h,0

UC_D1C	DB	' d1$' ,21h,0
UC_D1D	DB	' d2$' ,21h,0
UC_D1E	DB	' d3$' ,21h,0
UC_D1F	DB	' d4.$',21h,0
UC_D20	DB	' d4$' ,21h,0
UC_D21	DB	' d6$' ,21h,0
UC_D22	DB	' d8.$',21h,0
UC_D23	DB	' d8$' ,21h,0
UC_D24	DB	' d12$',21h,0
UC_D25	DB	' d16$',21h,0
UC_D26	DB	' d24$',21h,0
UC_D27	DB	' d32$',21h,0
UC_D28	DB	' d48$',21h,0
UC_D29	DB	' d64$',21h,0

UC_D2A	DB	' d+1$' ,21h,0
UC_D2B	DB	' d+2$' ,21h,0
UC_D2C	DB	' d+3$' ,21h,0
UC_D2D	DB	' d+4.$',21h,0
UC_D2E	DB	' d+4$' ,21h,0
UC_D2F	DB	' d+6$' ,21h,0
UC_D30	DB	' d+8.$',21h,0
UC_D31	DB	' d+8$' ,21h,0
UC_D32	DB	' d+12$',21h,0
UC_D33	DB	' d+16$',21h,0
UC_D34	DB	' d+24$',21h,0
UC_D35	DB	' d+32$',21h,0
UC_D36	DB	' d+48$',21h,0
UC_D37	DB	' d+64$',21h,0

UC_D38	DB	' e1$' ,21h,0
UC_D39	DB	' e2$' ,21h,0
UC_D3A	DB	' e3$' ,21h,0
UC_D3B	DB	' e4.$',21h,0
UC_D3C	DB	' e4$' ,21h,0
UC_D3D	DB	' e6$' ,21h,0
UC_D3E	DB	' e8.$',21h,0
UC_D3F	DB	' e8$' ,21h,0
UC_D40	DB	' e12$',21h,0
UC_D41	DB	' e16$',21h,0
UC_D42	DB	' e24$',21h,0
UC_D43	DB	' e32$',21h,0
UC_D44	DB	' e48$',21h,0
UC_D45	DB	' e64$',21h,0

UC_D46	DB	' f1$' ,21h,0
UC_D47	DB	' f2$' ,21h,0
UC_D48	DB	' f3$' ,21h,0
UC_D49	DB	' f4.$',21h,0
UC_D4A	DB	' f4$' ,21h,0
UC_D4B	DB	' f6$' ,21h,0
UC_D4C	DB	' f8.$',21h,0
UC_D4D	DB	' f8$' ,21h,0
UC_D4E	DB	' f12$',21h,0
UC_D4F	DB	' f16$',21h,0
UC_D50	DB	' f24$',21h,0
UC_D51	DB	' f32$',21h,0
UC_D52	DB	' f48$',21h,0
UC_D53	DB	' f64$',21h,0

UC_D54	DB	' f+1$' ,21h,0
UC_D55	DB	' f+2$' ,21h,0
UC_D56	DB	' f+3$' ,21h,0
UC_D57	DB	' f+4.$',21h,0
UC_D58	DB	' f+4$' ,21h,0
UC_D59	DB	' f+6$' ,21h,0
UC_D5A	DB	' f+8.$',21h,0
UC_D5B	DB	' f+8$' ,21h,0
UC_D5C	DB	' f+12$',21h,0
UC_D5D	DB	' f+16$',21h,0
UC_D5E	DB	' f+24$',21h,0
UC_D5F	DB	' f+32$',21h,0
UC_D60	DB	' f+48$',21h,0
UC_D61	DB	' f+64$',21h,0

UC_D62	DB	' g1$' ,21h,0
UC_D63	DB	' g2$' ,21h,0
UC_D64	DB	' g3$' ,21h,0
UC_D65	DB	' g4.$',21h,0
UC_D66	DB	' g4$' ,21h,0
UC_D67	DB	' g6$' ,21h,0
UC_D68	DB	' g8.$',21h,0
UC_D69	DB	' g8$' ,21h,0
UC_D6A	DB	' g12$',21h,0
UC_D6B	DB	' g16$',21h,0
UC_D6C	DB	' g24$',21h,0
UC_D6D	DB	' g32$',21h,0
UC_D6E	DB	' g48$',21h,0
UC_D6F	DB	' g64$',21h,0

UC_D70	DB	' g+1$' ,21h,0
UC_D71	DB	' g+2$' ,21h,0
UC_D72	DB	' g+3$' ,21h,0
UC_D73	DB	' g+4.$',21h,0
UC_D74	DB	' g+4$' ,21h,0
UC_D75	DB	' g+6$' ,21h,0
UC_D76	DB	' g+8.$',21h,0
UC_D77	DB	' g+8$' ,21h,0
UC_D78	DB	' g+12$',21h,0
UC_D79	DB	' g+16$',21h,0
UC_D7A	DB	' g+24$',21h,0
UC_D7B	DB	' g+32$',21h,0
UC_D7C	DB	' g+48$',21h,0
UC_D7D	DB	' g+64$',21h,0

UC_D7E	DB	' a1$' ,21h,0
UC_D7F	DB	' a2$' ,21h,0
UC_D80	DB	' a3$' ,21h,0
UC_D81	DB	' a4.$',21h,0
UC_D82	DB	' a4$' ,21h,0
UC_D83	DB	' a6$' ,21h,0
UC_D84	DB	' a8.$',21h,0
UC_D85	DB	' a8$' ,21h,0
UC_D86	DB	' a12$',21h,0
UC_D87	DB	' a16$',21h,0
UC_D88	DB	' a24$',21h,0
UC_D89	DB	' a32$',21h,0
UC_D8A	DB	' a48$',21h,0
UC_D8B	DB	' a64$',21h,0

UC_D8C	DB	' a+1$' ,21h,0
UC_D8D	DB	' a+2$' ,21h,0
UC_D8E	DB	' a+3$' ,21h,0
UC_D8F	DB	' a+4.$',21h,0
UC_D90	DB	' a+4$' ,21h,0
UC_D91	DB	' a+6$' ,21h,0
UC_D92	DB	' a+8.$',21h,0
UC_D93	DB	' a+8$' ,21h,0
UC_D94	DB	' a+12$',21h,0
UC_D95	DB	' a+16$',21h,0
UC_D96	DB	' a+24$',21h,0
UC_D97	DB	' a+32$',21h,0
UC_D98	DB	' a+48$',21h,0
UC_D99	DB	' a+64$',21h,0

UC_D9A	DB	' b1$' ,21h,0
UC_D9B	DB	' b2$' ,21h,0
UC_D9C	DB	' b3$' ,21h,0
UC_D9D	DB	' b4.$',21h,0
UC_D9E	DB	' b4$' ,21h,0
UC_D9F	DB	' b6$' ,21h,0
UC_DA0	DB	' b8.$',21h,0
UC_DA1	DB	' b8$' ,21h,0
UC_DA2	DB	' b12$',21h,0
UC_DA3	DB	' b16$',21h,0
UC_DA4	DB	' b24$',21h,0
UC_DA5	DB	' b32$',21h,0
UC_DA6	DB	' b48$',21h,0
UC_DA7	DB	' b64$',21h,0

UC_DA8	DB	' r1$' ,21h,0
UC_DA9	DB	' r2$' ,21h,0
UC_DAA	DB	' r3$' ,21h,0
UC_DAB	DB	' r4.$',21h,0
UC_DAC	DB	' r4$' ,21h,0
UC_DAD	DB	' r6$' ,21h,0
UC_DAE	DB	' r8.$',21h,0
UC_DAF	DB	' r8$' ,21h,0
UC_DB0	DB	' r12$',21h,0
UC_DB1	DB	' r16$',21h,0
UC_DB2	DB	' r24$',21h,0
UC_DB3	DB	' r32$',21h,0
UC_DB4	DB	' r48$',21h,0
UC_DB5	DB	' r64$',21h,0

UC_DB6	DB	' r1$' ,21h,0
UC_DB7	DB	' r2$' ,21h,0
UC_DB8	DB	' r3$' ,21h,0
UC_DB9	DB	' r4.$',21h,0
UC_DBA	DB	' r4$' ,21h,0
UC_DBB	DB	' r6$' ,21h,0
UC_DBC	DB	' r8.$',21h,0
UC_DBD	DB	' r8$' ,21h,0
UC_DBE	DB	' r12$',21h,0
UC_DBF	DB	' r16$',21h,0
UC_DC0	DB	' r24$',21h,0
UC_DC1	DB	' r32$',21h,0
UC_DC2	DB	' r48$',21h,0
UC_DC3	DB	' r64$',21h,0






UC_DC4	DB	' E$',0FFh		;expression
	DW	OFFSET UC_SAVE_E	
	DB	00h

UC_DC5	DB	0FFh			;expression move
	DW	OFFSET UC_Expression
	DB	00h

UC_DC6	DB	' p$',0FFh		;panpot
	DW	OFFSET UC_SAVE_P
	DB	00h

UC_DC7	DB	0FFh			;panpot move
	DW	OFFSET UC_Panpot
	DB	00h

UC_DC8	DB	' UB1,$',0ffh		;ポルタメント
	dw	offset UC_portamento	;
	db	00h			;

UC_DC9	DB	' IW$',0FFh					;LFO
	dw	offset UC_LFO_IW				;
	db	00h						;

UC_DCA	DB	' IW0$',00h					;LFO off

UC_DCB	DB	' IE$',0ffh					;
	dw	offset UC_LFO_IE				;
	db	00h						;

UC_DCC	DB	' IE0$',00h					;

UC_DCD	DB	' IP$',0ffh					;
	dw	offset UC_LFO_IP				;
	db	' $',00h					;

UC_DCE	DB	' IP0$',00h					;

UC_DCF	DB	' /*CF,$',010h,' */$',00h	

UC_DD0	DB	' /*D0*/$',00h

UC_DD1	DB	' /*D1*/$',00h

UC_DD2	DB	' /*D2*/$',00h

UC_DD3	DB	' /*D3*/$',00h

UC_DD4	DB	' y91,100$',00h

UC_DD5	DB	' y91,0$',00h

UC_DD6	DB	' o$',0FFh		;オクターブ
	DW	offset UC_Octave	
	DB	0

UC_DD7	DB	' >$',00h		;オクターブアップ

UC_DD8	DB	' <$',00h		;オクターブダウン

UC_DD9	DB	' _$',11h,00h

UC_DDA	DB	' __$',11h,00h

UC_DDB	DB	' BW$',0FFh		;ディチューン
	DW	offset UC_Detune
	DB	00h

UC_DDC	DB	24h,24h,0FFH		;音色	'$'の出力
	DW	OFFSET UC_VOICE_OUTPUT	;	マクロ番号出力
	DB	00h			;	使用マクロ記憶


UC_DDD	DB	' /*E.AR,$',010h,' */$',00h	;不明

UC_DDE	DB	' /*E.DR,$',010h,' */$',00h	;不明

UC_DDF	DB	' /*E.SL,$',010h,' */$',00h	;不明

UC_DE0	DB	' /*E.RR,$',010h,' */$',00h	;不明

UC_DE1	DB	' /*E.reset*/$',00h		;エンベロープ

UC_DE2	DB	0FFh
	DW	OFFSET Loop_Start
	DB	00h

UC_DE3	DB	0FFh
	DW	OFFSET Loop_End
	DB	00h

UC_DE4	db	' /*E4*/$',0
UC_DE5	db	' /*E5*/$',0
UC_DE6	db	' /*E6*/$',0
UC_DE7	db	' /*E7*/$',0
UC_DE8	db	0ffH			;次の音符の音長指定
	dw	OFFSET UC_Step
	DB	0
UC_DE9	db	' /*E9,$',010h,' */$',0
UC_DEA	db	' /*EA,$',010h,' */$',0

UC_DEB	DB	0FFh
	dw	offset UC_End
	db	00h			;終了

UC_DEC	db	' /*EC*/$',0
UC_DED	db	' /*ED*/$',0
UC_DEE	db	' /*EE*/$',0
UC_DEF	db	' /*EF*/$',0

UC_DF0	DB	0FFh				;テンポ
	dw	offset UC_Tempo			;
	db	00h				;

UC_DF1	DB	0FFh				;相対テンポ
	dw	offset UC_RelativeTempo		;
	db	00h				;

UC_DF2	DB	0FFh				;リバーブ
	dw	offset UC_Reverb		;
	db	00h				;

UC_DF3	DB	0FFh				;相対リバーブ
	dw	offset UC_RelativeReverb	;
	db	00h				;

UC_DF4	db	' /* EX x7F,x7F,x04,x01,x00,$'
	db	013h				;
	db	' ,xF7 */$',0			;Master Volume

UC_DF5	DB	' /*F5*/$',00h			;不明

UC_DF6	DB	0FFh				;ループ抜け
	dw	offset Loop_Exit		;
	db	00h				;

UC_DF7	DB	0FFh				;無限ループ
	dw	offset UC_PermanentLoop		;
	db	00h				;

UC_DF8	DB	' /* EX x7F,x7F,x04,x05,x01,x01,x01,x01,x01,x01,$'
	db	011h				;
	DB	' ,xF7 */$',0			;Reverb FeedBack (Time?)

UC_DF9	DB	' /*FIR,$',010h,' */$',00h	

UC_DFA	DB	' /*FA*/$',00h			;不明
UC_DFB	DB	' /*FB*/$',00h			;不明
UC_DFC	DB	' /*FC*/$',00h			;不明
UC_DFD	DB	' /*FD*/$',00h			;不明
UC_DFE	DB	' /*FE*/$',00h			;不明
UC_DFF	DB	' /*FF*/$',00h			;不明
endif	;--------------------------------
