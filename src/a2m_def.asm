;************************************************************************
;*									*
;*		定義部							*
;*									*
;************************************************************************
ifdef	ff7	;------------------------
;FINAL FANTASY 7
PARTF_ADDRESS	equ	0010h		
VOICE_ADDRESS	EQU	0000H		
RIHTM_ADDRESS	EQU	0000H		
MUSIC_ADDRESS	EQU	0014H		
MUSIC_ADDRESSa	equ	+2
endif	;--------------------------------

ifdef	ff8	;------------------------
;FINAL FANTASY 2,8,9
PARTF_ADDRESS	equ	0020h		
VOICE_ADDRESS	EQU	0030H		
RIHTM_ADDRESS	EQU	0034H		
MUSIC_ADDRESS	EQU	0040H		
MUSIC_ADDRESSa	equ	0
endif	;--------------------------------


;************************************************************************
;*									*
;*		逆ＭＭＬ変換情報のあるアドレス				*
;*									*
;************************************************************************
UC_DATA_ADDRESS:
	DW	OFFSET UC_D00	;コマンド00h
	DW	OFFSET UC_D01
	DW	OFFSET UC_D02
	DW	OFFSET UC_D03
	DW	OFFSET UC_D04
	DW	OFFSET UC_D05
	DW	OFFSET UC_D06
	DW	OFFSET UC_D07
	DW	OFFSET UC_D08
	DW	OFFSET UC_D09
	DW	OFFSET UC_D0A
	DW	OFFSET UC_D0B
	DW	OFFSET UC_D0C
	DW	OFFSET UC_D0D
	DW	OFFSET UC_D0E
	DW	OFFSET UC_D0F
	DW	OFFSET UC_D10
	DW	OFFSET UC_D11
	DW	OFFSET UC_D12
	DW	OFFSET UC_D13
	DW	OFFSET UC_D14
	DW	OFFSET UC_D15
	DW	OFFSET UC_D16
	DW	OFFSET UC_D17
	DW	OFFSET UC_D18
	DW	OFFSET UC_D19
	DW	OFFSET UC_D1A
	DW	OFFSET UC_D1B
	DW	OFFSET UC_D1C
	DW	OFFSET UC_D1D
	DW	OFFSET UC_D1E
	DW	OFFSET UC_D1F
	DW	OFFSET UC_D20
	DW	OFFSET UC_D21
	DW	OFFSET UC_D22
	DW	OFFSET UC_D23
	DW	OFFSET UC_D24
	DW	OFFSET UC_D25
	DW	OFFSET UC_D26
	DW	OFFSET UC_D27
	DW	OFFSET UC_D28
	DW	OFFSET UC_D29
	DW	OFFSET UC_D2A
	DW	OFFSET UC_D2B
	DW	OFFSET UC_D2C
	DW	OFFSET UC_D2D
	DW	OFFSET UC_D2E
	DW	OFFSET UC_D2F
	DW	OFFSET UC_D30
	DW	OFFSET UC_D31
	DW	OFFSET UC_D32
	DW	OFFSET UC_D33
	DW	OFFSET UC_D34
	DW	OFFSET UC_D35
	DW	OFFSET UC_D36
	DW	OFFSET UC_D37
	DW	OFFSET UC_D38
	DW	OFFSET UC_D39
	DW	OFFSET UC_D3A
	DW	OFFSET UC_D3B
	DW	OFFSET UC_D3C
	DW	OFFSET UC_D3D
	DW	OFFSET UC_D3E
	DW	OFFSET UC_D3F
	DW	OFFSET UC_D40
	DW	OFFSET UC_D41
	DW	OFFSET UC_D42
	DW	OFFSET UC_D43
	DW	OFFSET UC_D44
	DW	OFFSET UC_D45
	DW	OFFSET UC_D46
	DW	OFFSET UC_D47
	DW	OFFSET UC_D48
	DW	OFFSET UC_D49
	DW	OFFSET UC_D4A
	DW	OFFSET UC_D4B
	DW	OFFSET UC_D4C
	DW	OFFSET UC_D4D
	DW	OFFSET UC_D4E
	DW	OFFSET UC_D4F
	DW	OFFSET UC_D50
	DW	OFFSET UC_D51
	DW	OFFSET UC_D52
	DW	OFFSET UC_D53
	DW	OFFSET UC_D54
	DW	OFFSET UC_D55
	DW	OFFSET UC_D56
	DW	OFFSET UC_D57
	DW	OFFSET UC_D58
	DW	OFFSET UC_D59
	DW	OFFSET UC_D5A
	DW	OFFSET UC_D5B
	DW	OFFSET UC_D5C
	DW	OFFSET UC_D5D
	DW	OFFSET UC_D5E
	DW	OFFSET UC_D5F
	DW	OFFSET UC_D60
	DW	OFFSET UC_D61
	DW	OFFSET UC_D62
	DW	OFFSET UC_D63
	DW	OFFSET UC_D64
	DW	OFFSET UC_D65
	DW	OFFSET UC_D66
	DW	OFFSET UC_D67
	DW	OFFSET UC_D68
	DW	OFFSET UC_D69
	DW	OFFSET UC_D6A
	DW	OFFSET UC_D6B
	DW	OFFSET UC_D6C
	DW	OFFSET UC_D6D
	DW	OFFSET UC_D6E
	DW	OFFSET UC_D6F
	DW	OFFSET UC_D70
	DW	OFFSET UC_D71
	DW	OFFSET UC_D72
	DW	OFFSET UC_D73
	DW	OFFSET UC_D74
	DW	OFFSET UC_D75
	DW	OFFSET UC_D76
	DW	OFFSET UC_D77
	DW	OFFSET UC_D78
	DW	OFFSET UC_D79
	DW	OFFSET UC_D7A
	DW	OFFSET UC_D7B
	DW	OFFSET UC_D7C
	DW	OFFSET UC_D7D
	DW	OFFSET UC_D7E
	DW	OFFSET UC_D7F
	DW	OFFSET UC_D80
	DW	OFFSET UC_D81
	DW	OFFSET UC_D82
	DW	OFFSET UC_D83
	DW	OFFSET UC_D84
	DW	OFFSET UC_D85
	DW	OFFSET UC_D86
	DW	OFFSET UC_D87
	DW	OFFSET UC_D88
	DW	OFFSET UC_D89
	DW	OFFSET UC_D8A
	DW	OFFSET UC_D8B
	DW	OFFSET UC_D8C
	DW	OFFSET UC_D8D
	DW	OFFSET UC_D8E
	DW	OFFSET UC_D8F
	DW	OFFSET UC_D90
	DW	OFFSET UC_D91
	DW	OFFSET UC_D92
	DW	OFFSET UC_D93
	DW	OFFSET UC_D94
	DW	OFFSET UC_D95
	DW	OFFSET UC_D96
	DW	OFFSET UC_D97
	DW	OFFSET UC_D98
	DW	OFFSET UC_D99
	DW	OFFSET UC_D9A
	DW	OFFSET UC_D9B
	DW	OFFSET UC_D9C
	DW	OFFSET UC_D9D
	DW	OFFSET UC_D9E
	DW	OFFSET UC_D9F
	DW	OFFSET UC_DA0
	DW	OFFSET UC_DA1
	DW	OFFSET UC_DA2
	DW	OFFSET UC_DA3
	DW	OFFSET UC_DA4
	DW	OFFSET UC_DA5
	DW	OFFSET UC_DA6
	DW	OFFSET UC_DA7
	DW	OFFSET UC_DA8
	DW	OFFSET UC_DA9
	DW	OFFSET UC_DAA
	DW	OFFSET UC_DAB
	DW	OFFSET UC_DAC
	DW	OFFSET UC_DAD
	DW	OFFSET UC_DAE
	DW	OFFSET UC_DAF
	DW	OFFSET UC_DB0
	DW	OFFSET UC_DB1
	DW	OFFSET UC_DB2
	DW	OFFSET UC_DB3
	DW	OFFSET UC_DB4
	DW	OFFSET UC_DB5
	DW	OFFSET UC_DB6
	DW	OFFSET UC_DB7
	DW	OFFSET UC_DB8
	DW	OFFSET UC_DB9
	DW	OFFSET UC_DBA
	DW	OFFSET UC_DBB
	DW	OFFSET UC_DBC
	DW	OFFSET UC_DBD
	DW	OFFSET UC_DBE
	DW	OFFSET UC_DBF
	DW	OFFSET UC_DC0
	DW	OFFSET UC_DC1
	DW	OFFSET UC_DC2
	DW	OFFSET UC_DC3
	DW	OFFSET UC_DC4
	DW	OFFSET UC_DC5
	DW	OFFSET UC_DC6
	DW	OFFSET UC_DC7
	DW	OFFSET UC_DC8
	DW	OFFSET UC_DC9
	DW	OFFSET UC_DCA
	DW	OFFSET UC_DCB
	DW	OFFSET UC_DCC
	DW	OFFSET UC_DCD
	DW	OFFSET UC_DCE
	DW	OFFSET UC_DCF
	DW	OFFSET UC_DD0
	DW	OFFSET UC_DD1
	DW	OFFSET UC_DD2
	DW	OFFSET UC_DD3
	DW	OFFSET UC_DD4
	DW	OFFSET UC_DD5
	DW	OFFSET UC_DD6
	DW	OFFSET UC_DD7
	DW	OFFSET UC_DD8
	DW	OFFSET UC_DD9
	DW	OFFSET UC_DDA
	DW	OFFSET UC_DDB
	DW	OFFSET UC_DDC
	DW	OFFSET UC_DDD
	DW	OFFSET UC_DDE
	DW	OFFSET UC_DDF
	DW	OFFSET UC_DE0
	DW	OFFSET UC_DE1
	DW	OFFSET UC_DE2
	DW	OFFSET UC_DE3
	DW	OFFSET UC_DE4
	DW	OFFSET UC_DE5
	DW	OFFSET UC_DE6
	DW	OFFSET UC_DE7
	DW	OFFSET UC_DE8
	DW	OFFSET UC_DE9
	DW	OFFSET UC_DEA
	DW	OFFSET UC_DEB
	DW	OFFSET UC_DEC
	DW	OFFSET UC_DED
	DW	OFFSET UC_DEE
	DW	OFFSET UC_DEF
	DW	OFFSET UC_DF0
	DW	OFFSET UC_DF1
	DW	OFFSET UC_DF2
	DW	OFFSET UC_DF3
	DW	OFFSET UC_DF4
	DW	OFFSET UC_DF5
	DW	OFFSET UC_DF6
	DW	OFFSET UC_DF7
	DW	OFFSET UC_DF8
	DW	OFFSET UC_DF9
	DW	OFFSET UC_DFA
	DW	OFFSET UC_DFB
	DW	OFFSET UC_DFC
	DW	OFFSET UC_DFD
	DW	OFFSET UC_DFE
	DW	OFFSET UC_DFF
;************************************************************************
;*									*
;*		逆ＭＭＬ情報						*
;*									*
;************************************************************************
;*	（最初に変換アドレス＋１されている。）				*
;*	00h	変換終了						*
;*	10h	符号無しＢｙｔｅ変換	アドレス＋１			*
;*	11h	符号有りＢｙｔｅ変換	アドレス＋１			*
;*	12h	符号無しＷｏｒｄ変換	アドレス＋１			*
;*	13h	符号有りＷｏｒｄ変換	アドレス＋１			*
;*	20h	文字列出力　'$'まで出力する。				*
;*	21h	次の発音はタイで繋がれるか検索				*
;*	24h	次のコードの出力					*
;*	80h	パート終了						*
;*	F0h	アドレス＋１	（未解析コマンドの引き数）		*
;*	FFh	次に示すアドレスをコールする				*
;************************************************************************
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
UC_DA0	DB	80h,00h			;終了
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
	DB	10h,00h
UC_DA9	DB	' E$',0FFh		;expression move
	DW	OFFSET UC_LOAD_ES
	DB	' UE1,0,%$',10h,' ,$',0FFh
	DW	OFFSET UC_LOAD_E
	DB	00h
UC_DAA	DB	' p$',0FFh		;panpot
	DW	OFFSET UC_SAVE_P
	DB	10h,00h
UC_DAB	DB	' p$',0FFh		;panpot move
	DW	OFFSET UC_LOAD_PS
	DB	' UP1,0,%$',10h,' ,$',0FFh
	DW	OFFSET UC_LOAD_P
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
UC_DC8	DB	' [$',0FFH		;Loop start
	dw	offset UC_LoopCountInc
	db	00h
UC_DC9	DB	' ]$',10h,0FFh		;Loop end
	dw	offset UC_LoopCountDec
	db	00h
UC_DCA	DB	' ]2$',0FFh		;Loop end(FF7用)
	dw	offset UC_LoopCountDec
	db	00h
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
UC_DD8	DB	' BS$',0FFh		;ディチューン
	DW	offset UC_Detune
	DB	00h
UC_DD9	DB	' BS$',11h,00h		;相対ディチューン
UC_DDA	DB	' /*DA,$',010h,' ,$',010h,' */$',00h	;不明
UC_DDB	DB	' /*DB*/$',00h
UC_DDC	DB	' /*DC,$',010h,' */$',00h	;不明
UC_DDD	DB	' /*DD,$',012h,' */$',00h	;
UC_DDE	DB	' /*DE,$',012h,' */$',00h	;
UC_DDF	DB	' /*DF,$',012h,' */$',00h	;不明
ifdef	ff7	;------------------------
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
UC_DEC	DB	0ffh				;パーカッションon
	dw	offset UC_PercussionOn		;
	db	' /*Adr=$',012h,' */$',00h	;Address?
UC_DED	DB	0ffh				;パーカッションoff
	dw	offset UC_PercussionOff		;
	db	00h				;
UC_DEE	DB	0FFh				;無限ループ(FF7)
	dw	offset UC_PermanentLoop	;
	db	00h				;
UC_DEF	DB	' /*EF,$',010h,' ,$',010h,' ,$',010h,' */$',00h	;
UC_DF0	DB	0FFh				;ループ抜け
	dw	offset UC_ExitLoop		;
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
UC_DFC	DB	' /*FC,$',010h,' ,$',010h,' */$',00h	;不明
UC_DFD	DB	0ffh				;拍子
	dw	offset UC_Beat			;
	db	0				;
UC_DFE	DB	0ffh				;リハーサル番号
	dw	offset UC_Measures		;
	db	0				;
UC_DFF	DB	' /*FF*/$',80h,00h
endif	;--------------------------------
ifdef	ff8	;------------------------
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


;===============================================================
;	初期化
;===============================================================
UC_INIT		proc	near

	mov	ax,0
	mov	byte ptr cs:[UC_Step_work],al
	mov	byte ptr cs:[UC_DATA_E],al
	mov	byte ptr cs:[UC_DATA_P],al

	mov	byte ptr cs:[UC_LFO_PitchBend_delay],al
	mov	byte ptr cs:[UC_LFO_PitchBend_range],al
	mov	byte ptr cs:[UC_LFO_PitchBend_count],al
	mov	byte ptr cs:[UC_LFO_PitchBend_depth],al

	mov	byte ptr cs:[UC_LFO_Expression_delay],al
	mov	byte ptr cs:[UC_LFO_Expression_range],al
	mov	byte ptr cs:[UC_LFO_Expression_count],al
	mov	byte ptr cs:[UC_LFO_Expression_depth],al

	mov	byte ptr cs:[UC_LFO_Panpot_delay],al
	mov	byte ptr cs:[UC_LFO_Panpot_range],al
	mov	byte ptr cs:[UC_LFO_Panpot_count],al
	mov	byte ptr cs:[UC_LFO_Panpot_depth],al

	mov	word ptr cs:[UC_LoopCountData],ax
	mov	word ptr cs:[UC_Tempo_Work],ax

	mov	byte ptr cs:[UC_Detune_D],64	;

	ret

UC_INIT		endp
;===============================================================
;	0xA1	0xF2	音色をマクロで出力する
;===============================================================
;
;		音色マクロ変換　（まだ暫定的に'@0x' を出力）
;
UC_VOICE	DB	64	DUP	(0FFh)	
UC_VOICE_NAME:	
ifdef	ff7	;------------------------
		DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$','8c$','9c$'
		DB	'0d$','1d$','2d$','3d$','4d$','5d$','6d$','7d$','8d$','9d$'
		DB	'0e$','1e$','2e$','3e$','4e$','5e$','6e$','7e$','8e$','9e$'
		DB	'0f$','1f$','2f$','3f$','4f$','5f$','6f$','7f$','8f$','9f$'
		DB	'0g$','1g$','2g$','3g$','4g$','5g$','6g$','7g$','8g$','9g$'
		DB	'0h$','1h$','2h$','3h$','4h$','5h$','6h$','7h$','8h$','9h$'
		DB	'0i$','1i$','2i$','3i$','4i$','5i$','6i$','7i$','8i$','9i$'
		DB	'0j$','1j$','2j$','3j$','4j$','5j$','6j$','7j$','8j$','9j$'
		DB	'0k$','1k$','2k$','3k$','4k$','5k$','6k$','7k$','8k$','9k$'
		DB	'0l$','1l$','2l$','3l$','4l$','5l$','6l$','7l$','8l$','9l$'
		DB	'0m$','1m$','2m$','3m$','4m$','5m$','6m$','7m$','8m$','9m$'
		DB	'0n$','1n$','2n$','3n$','4n$','5n$','6n$','7n$','8n$','9n$'
		DB	'0o$','1o$','2o$','3o$','4o$','5o$','6o$','7o$','8o$','9o$'
endif	;--------------------------------
ifdef	ff8	;------------------------
		DB	'0c$','1c$','2c$','3c$','4c$','5c$','6c$','7c$'
		DB	'0d$','1d$','2d$','3d$','4d$','5d$','6d$','7d$'
		DB	'0e$','1e$','2e$','3e$','4e$','5e$','6e$','7e$'
		DB	'0f$','1f$','2f$','3f$','4f$','5f$','6f$','7f$'
		DB	'0g$','1g$','2g$','3g$','4g$','5g$','6g$','7g$'
		DB	'0h$','1h$','2h$','3h$','4h$','5h$','6h$','7h$'
		DB	'0i$','1i$','2i$','3i$','4i$','5i$','6i$','7i$'
		DB	'0j$','1j$','2j$','3j$','4j$','5j$','6j$','7j$'
endif	;--------------------------------
UC_VOICE_OUTPUT	proc	near
	mov	ax,0				;
	MOV	AL,ES:[BX]			;ax←データ読み込み
	INC	BX				;

	PUSH	BX				;
	PUSH	CX				;
	PUSH	DX				;

	MOV	DX,OFFSET UC_VOICE_NAME		;

ifdef	ff7	;------------------------
	add	dx,ax				;
	add	dx,ax				;
	add	dx,ax				;DX←Address + ax *3
endif	;--------------------------------
ifdef	ff8	;------------------------
	XOR	BX,BX				;BX←0
UC_VOICE_OUTPUT_L1:				;
	MOV	AH,CS:[UC_VOICE + BX]		;使用登録済み音色読み込み
	CMP	AH,0FFh				;登録情報終了検査
	JZ	UC_VOICE_OUTPUT_L2		;
	
	CMP	AH,AL				;音色一致検査
	JZ	UC_VOICE_OUTPUT_L3		;存在した。
	INC	BX				;
	JMP	UC_VOICE_OUTPUT_L1		;

UC_VOICE_OUTPUT_L2:				;
	MOV	CS:[UC_VOICE + BX],AL		;登録

UC_VOICE_OUTPUT_L3:				;表示
	ADD	DX,BX				;
	ADD	DX,BX				;
	ADD	DX,BX				;DX←Address + BX *3
endif	;--------------------------------

	MOV	AH,09H				;
	INT	21H				;

UC_VOICE_OUTPUT_LE:				;終わり
	POP	DX				;
	POP	CX				;
	POP	BX				;
	RET					;

UC_VOICE_OUTPUT	endp
;===============================================================
;	0xA2	次の音符・休符の音長
;===============================================================
UC_Step_work	db	0			;
UC_Step		proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	inc	bx				;
	mov	byte ptr cs:[UC_Step_work],ah	;保存
	RET					;
UC_Step		endp
;===============================================================
;	0xA3	音量
;===============================================================

UC_Volume_TABLE:	;指数値を、リニアに変換
			;=INT(LOG((x+1))/LOG(129)*128)
;		0	+1	+2	+3	+4	+5	+6	+7
	db	0,	18,	28,	36,	42,	47,	51,	54
	db	57,	60,	63,	65,	67,	69,	71,	73
	db	74,	76,	77,	78,	80,	81,	82,	83
	db	84,	85,	86,	87,	88,	89,	90,	91
	db	92,	92,	93,	94,	95,	95,	96,	97
	db	97,	98,	99,	99,	100,	100,	101,	101
	db	102,	103,	103,	104,	104,	105,	105,	106
	db	106,	106,	107,	107,	108,	108,	109,	109
	db	109,	110,	110,	111,	111,	111,	112,	112
	db	113,	113,	113,	114,	114,	114,	115,	115
	db	115,	116,	116,	116,	117,	117,	117,	117
	db	118,	118,	118,	119,	119,	119,	119,	120
	db	120,	120,	121,	121,	121,	121,	122,	122
	db	122,	122,	123,	123,	123,	123,	124,	124
	db	124,	124,	124,	125,	125,	125,	125,	126
	db	126,	126,	126,	126,	127,	127,	127,	127

UC_Volume	proc	near
	MOV	AL,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	BX				;
	XOR	AH,AH				;
	MOV	BX,OFFSET UC_Volume_TABLE	;
	ADD	BX,AX				;
	MOV	AH,CS:[BX]			;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	BX				;
	RET					;
UC_Volume	endp
;===============================================================
;	0xA3	オクターブ
;===============================================================
UC_Octave	proc	near
	MOV	Ah,ES:[BX]			;
	inc	bx				
	dec	ah				
	call	hex2asc8			
	mov	ah,9				
	int	21h				
	RET					;
UC_Octave	endp
;===============================================================
;	0xA4	ポルタメント
;===============================================================
UC_portamento_D	db	0			;一応、2byteで保存する
UC_portamento	proc	near
	mov	al,byte ptr cs:[UC_portamento_D]
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;初期変位出力

	MOV	DL,2CH				;','の出力
	MOV	AH,02H				;
	INT	21H				;

	MOV	DL,'%'				;'%'の出力
	MOV	AH,02H				;
	INT	21H				;

	MOV	Ah,ES:[BX]			;
	inc	bx				
	call	hex2asc8			;
	mov	ah,09h				;
	int	21h				;ステップの出力

	MOV	DL,2CH				;','の出力
	MOV	AH,02H				;
	INT	21H				;

	MOV	Al,ES:[BX]			;
	inc	bx				;
	add	byte ptr cs:[UC_portamento_D],al
	mov	ah,8				;
	imul	ah				;
	call	fh2a16				;
	mov	ah,09h				;
	int	21h				;ステップの出力

	ret
UC_portamento	endp
;===============================================================
;	0xA8	音量セーブ
;===============================================================
UC_DATA_E	DB	?			;エクスプレッション
UC_SAVE_E	proc	near
	MOV	AL,ES:[BX]			;データ保存
	MOV	CS:[UC_DATA_E],AL		;
	RET					;
UC_SAVE_E	endp
;===============================================================
;	0xA9	音量ロード
;===============================================================
UC_LOAD_E	proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	DX				;
	MOV	AL,CS:[UC_DATA_E]		;保存データ
	MOV	CS:[UC_DATA_E],AH		;
	SUB	AH,AL				;
	CALL	FH2A8				;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_E	endp
;---------------------------------------------------------------
UC_LOAD_ES	proc	near
	PUSH	DX				;
	MOV	AH,CS:[UC_DATA_E]		;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_ES	endp
;===============================================================
;	0xAA	パンポット・セーブ
;===============================================================
UC_DATA_P	DB	?			;パンポット
UC_SAVE_P	proc	near
	MOV	AL,ES:[BX]			;データ保存
	MOV	CS:[UC_DATA_P],AL		;
	RET					;
UC_SAVE_P	endp
;===============================================================
;	0xA9	パンポット・ロード
;===============================================================
UC_LOAD_P	proc	near
	MOV	AH,ES:[BX]			;データ読み込み
	INC	BX				;
	PUSH	DX				;
	MOV	AL,CS:[UC_DATA_P]		;保存データ
	MOV	CS:[UC_DATA_P],AH		;
	SUB	AH,AL				;
	CALL	FH2A8				;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_P	endp
;---------------------------------------------------------------
UC_LOAD_PS	proc	near
	PUSH	DX				;
	MOV	AH,CS:[UC_DATA_P]		;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_LOAD_PS	endp
;===============================================================
;	0xB4		Pitch Bend LFO
;===============================================================
UC_LFO_PitchBend_delay	db	0
UC_LFO_PitchBend_range	db	0
UC_LFO_PitchBend_count	db	0
UC_LFO_PitchBend_depth	db	0

UC_LFO_PitchBend	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_delay],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_count],al

	call	UC_LFO_PitchBend_Output
	ret
UC_LFO_PitchBend	endp
;===============================================================
;	0xB5		Pitch Bend LFO
;===============================================================
UC_LFO_PitchBendDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_PitchBend_depth],al

	call	UC_LFO_PitchBend_Output
	ret
UC_LFO_PitchBendDepth	endp
;---------------------------------------------------------------
UC_LFO_PitchBend_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_PitchBend_depth],0
	jz	UC_LFO_PitchBend_End
	cmp	byte ptr cs:[UC_LFO_PitchBend_range],0
	jz	UC_LFO_PitchBend_End
	cmp	byte ptr cs:[UC_LFO_PitchBend_count],0
	jz	UC_LFO_PitchBend_End

	xor	ax,ax
	mov	al,byte ptr cs:[UC_LFO_PitchBend_depth]
	shl	ax,3
;	mov	ah,byte ptr cs:[UC_LFO_PitchBend_range]
;	imul	ah		;
;	mov	dx,8		;符号付きですよ？奥さん！！　多分
;	imul	dx
	cmp	ax,0
	jz	UC_LFO_PitchBend_End
	call	fh2a16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_PitchBend_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_PitchBend_count]
;	mov	ah,byte ptr cs:[UC_LFO_PitchBend_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_PitchBend_End:

	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_PitchBend_Output	endp
;===============================================================
;	0xB8		Expression LFO
;===============================================================
UC_LFO_Expression_delay	db	0
UC_LFO_Expression_range	db	0
UC_LFO_Expression_count	db	0
UC_LFO_Expression_depth	db	0

UC_LFO_Expression	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_delay],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_count],al

	call	UC_LFO_Expression_Output
	ret
UC_LFO_Expression	endp
;===============================================================
;	0xB9		Expression LFO
;===============================================================
UC_LFO_ExpressionDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Expression_depth],al

	call	UC_LFO_Expression_Output
	ret
UC_LFO_ExpressionDepth	endp
;---------------------------------------------------------------
UC_LFO_Expression_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_Expression_depth],0
	jz	UC_LFO_Expression_End
	cmp	byte ptr cs:[UC_LFO_Expression_range],0
	jz	UC_LFO_Expression_End
	cmp	byte ptr cs:[UC_LFO_Expression_count],0
	jz	UC_LFO_Expression_End

	xor	ax,ax
	mov	ah,byte ptr cs:[UC_LFO_Expression_depth]
	shr	ah,3
;	mov	ah,byte ptr cs:[UC_LFO_Expression_range]
;	imul	ah
;	mov	dx,2
;	imul	dx
	cmp	ah,0
	jz	UC_LFO_Expression_End
	call	fh2a8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_Expression_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_Expression_count]
;	mov	ah,byte ptr cs:[UC_LFO_Expression_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_Expression_End:
	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_Expression_Output	endp
;===============================================================
;	0xBC		Panpot LFO
;===============================================================
UC_LFO_Panpot_delay	db	0
UC_LFO_Panpot_range	db	0
UC_LFO_Panpot_count	db	0
UC_LFO_Panpot_depth	db	0
UC_LFO_Panpot		proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_range],al

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_count],al

	call	UC_LFO_Panpot_Output
	ret
UC_LFO_Panpot		endp
;===============================================================
;	0xBD		Panpot LFO
;===============================================================
UC_LFO_PanpotDepth	proc	near

	mov	al,es:[bx]
	inc	bx
	mov	byte ptr cs:[UC_LFO_Panpot_depth],al

	call	UC_LFO_Panpot_Output
	ret
UC_LFO_PanpotDepth	endp
;---------------------------------------------------------------
UC_LFO_Panpot_Output	proc	near

	;何かしらが0だったら終わる
	cmp	byte ptr cs:[UC_LFO_Panpot_depth],0
	jz	UC_LFO_Panpot_End
	cmp	byte ptr cs:[UC_LFO_Panpot_range],0
	jz	UC_LFO_Panpot_End
	cmp	byte ptr cs:[UC_LFO_Panpot_count],0
	jz	UC_LFO_Panpot_End

	xor	ax,ax
	mov	ah,byte ptr cs:[UC_LFO_Panpot_depth]
	shr	ah,3
;	mov	ah,byte ptr cs:[UC_LFO_Panpot_range]
;	imul	ah
;	mov	dx,2
;	imul	dx
	cmp	ah,0
	jz	UC_LFO_Panpot_End
	call	fh2a8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,1
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ah,byte ptr cs:[UC_LFO_Panpot_delay]
	call	hex2asc8
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,0
	mov	al,byte ptr cs:[UC_LFO_Panpot_count]
;	mov	ah,byte ptr cs:[UC_LFO_Panpot_range]
;	mul	ah
	shl	ax,1		;
	call	hex2asc16
	mov	ah,09h
	int	21h

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

UC_LFO_Panpot_End:

	mov	ah,0
	call	hex2asc8
	mov	ah,09h
	int	21h

	ret
UC_LFO_Panpot_Output	endp
;===============================================================
;	0xC8		ループ
;===============================================================
UC_LoopCountData	dw	0
UC_LoopCountInc	proc	near
	inc	word ptr cs:[UC_LoopCountData]
	ret
UC_LoopCountInc	endp
;===============================================================
;	0xC9,0xCA	ループ
;===============================================================
UC_LoopCountDec	proc	near
	cmp	word ptr cs:[UC_LoopCountData],0
	jz	UC_LoopCountDec_1
	dec	word ptr cs:[UC_LoopCountData]
UC_LoopCountDec_1:
	ret
UC_LoopCountDec	endp
;===============================================================
;	0xD8	ピッチベンド
;===============================================================
UC_Detune_D	db	64
UC_Detune	proc	near
	PUSH	DX				;
	MOV	AH,ES:[BX]			;データ読み込み
	inc	bx
	add	ah,64				;
	mov	byte ptr cs:[UC_Detune_D],ah	;
	CALL	HEX2ASC8			;出力
	MOV	AH,09H				;
	INT	21H				;
	POP	DX				;
	RET					;
UC_Detune	endp
;===============================================================
;	0xE8	テンポ
;===============================================================
UC_RelativeTempo_M:
	db	't$'
UC_Tempo_Work	dw	0

UC_Tempo	proc	near
	MOV	DX,OFFSET UC_RelativeTempo_M
	MOV	AH,09H		;
	INT	21H		;

	MOV	AX,ES:[BX]	;AX←データ（WORD）
	INC	BX		;
	INC	BX		;

	mov	word ptr cs:[UC_Tempo_Work],ax

	PUSH	CX		;
	XOR	DX,DX		;DX,AX←Ax
	MOV	CX,218		;
	DIV	CX		;ax←dx,ax÷218
	POP	CX		;
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示
	RET
UC_Tempo	endp
;===============================================================
;	0xE9	相対テンポ
;===============================================================
UC_RTempo_M0	db	'/*$'
UC_RTempo_M1	db	'UT$'
UC_RTempo_M2	db	'*/$'
UC_RelativeTempo	proc	near

	MOV	DX,OFFSET UC_RTempo_M0
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UC_RTempo_M1
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]	;
	inc	bx		;
	CALL	HEX2ASC8	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
	CALL	FH2A16		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_RTempo_M2
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_RelativeTempo	endp
;===============================================================
;	0xEA	リバーブ
;===============================================================
UC_UC_Reverb_M1	db	'/*Reverb($'
UC_UC_Reverb_M2	db	')*/$'

UC_Reverb		proc	near
	MOV	DX,OFFSET UC_UC_Reverb_M1
	MOV	AH,09H		;
	INT	21H		;

	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
	CALL	HEX2ASC16	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_UC_Reverb_M2
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_Reverb		endp
;===============================================================
;	0xEB	相対リバーブ
;===============================================================
UC_UC_Reverb_M8	db	'/*Reverb($'
UC_UC_Reverb_M9	db	')*/$'

UC_RelativeReverb	proc	near
	MOV	DX,OFFSET UC_UC_Reverb_M8
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]	;
	inc	bx		;
	CALL	HEX2ASC8	;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	mov	ax,es:[bx]	;
	inc	bx		;
	inc	bx		;
	CALL	FH2A16		;数値変換
	MOV	AH,09H		;
	INT	21H		;そしてそれを表示

	MOV	DX,OFFSET UC_UC_Reverb_M9
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_RelativeReverb	endp
;===============================================================
;	0xEC	パーカッションon
;===============================================================
UC_Perc_On	db	'1z$'

UC_PercussionOn		proc	near

	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	DX,OFFSET UC_Perc_On
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_PercussionOn		endp
;===============================================================
;	0xED	パーカッションoff
;===============================================================
UC_Perc_Off	db	'0z$'

UC_PercussionOff	proc	near
	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	DX,OFFSET UC_Perc_Off
	MOV	AH,09H		;
	INT	21H		;

	ret
UC_PercussionOff	endp
;===============================================================
;	0xEE	無限ループ
;===============================================================
UCDFF_M06_1	DB	']2/*L*/$'
UCDFF_M06_2	DB	']1/*L*/$'
UCDFF_M06_bx	Dw	0

UC_PermanentLoop	proc	near
UCDFF_L06_1:			;
	cmp	word ptr cs:[UC_LoopCountData],0
	jz	UCDFF_L06_1_LoopOk
	mov	dx,offset UCDFF_M06_2
	mov	ah,09h		;
	int	21h		;
	dec	word ptr cs:[UC_LoopCountData]
	jmp	UCDFF_L06_1	;
UCDFF_L06_1_LoopOk:		;
	mov	ax,bx		;
	mov	cs:[UCDFF_M06_bx],ax
	MOV	AX,ES:[BX]	;
	TEST	AX,AX		;
	JNZ	UCDFF_L06_4	;
	JMP	UCDFF_L06_3	;
UCDFF_L06_4:			
	ADD	BX,AX		;BX←ループ先アドレス
	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS]	;検索したループ先アドレス
;	CMP	AX,BX		;同一
;	JZ	UCDFF_L06_2	;
;	RET			;でないならば、ジャンプ
UCDFF_L06_2:			;
	TEST	AX,AX		;
	JZ	UCDFF_L06_3	;
	MOV	DX,OFFSET UCDFF_M06_1
	MOV	AH,09H		;
	INT	21H		;

	cmp	byte ptr cs:[UCMOLS_LOOP_flag2],01h	;
	jnz	UCDFF_L06_3
	mov	byte ptr cs:[UCMOLS_LOOP_flag2],00h	;
	mov	ax,cs:[UCDFF_M06_bx]
	mov	bx,ax
	add	bx,2
	ret

UCDFF_L06_3:			;
	POP	DX		;ダミー
	XCHG	BX,DX		;今更ながら、数年前のソースって
	MOV	BX,SP		;すごいことしてるなぁ～。
	MOV	AX,OFFSET UCMO_LQQ	;	by 2008年 秋
	MOV	SS:[BX],AX	;
	XCHG	BX,DX		;スタックを"UCMO_LQQ"に書き換え。
	RET			;RET命令で、↑に戻る。（チャンネル終了）
UC_PermanentLoop	endp
;===============================================================
;	0xF0	ループ抜け
;===============================================================
UC_ExitLoop_M1	db	'/*Adr=$'
UC_ExitLoop_M2	db	'*/:$'
UC_ExitLoop		proc	near

	MOV	DX,OFFSET UC_ExitLoop_M1
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]
	inc	bx		;
	call	hex2asc8
	MOV	AH,09H		;
	INT	21H		;

	MOV	AX,ES:[BX]	;
	inc	bx
	inc	bx
	call	FH2A16
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UC_ExitLoop_M2
	MOV	AH,09H		;
	INT	21H		;

	ret			;
UC_ExitLoop		endp
;===============================================================
;	0xFD	拍子
;===============================================================
UC_Beat_M	db	'BT$'
UC_Beat			proc	near

	mov	dx,offset UC_Beat_M
	mov	ah,09h
	int	21h

	mov	al,es:[bx]	;
	inc	bx		;
	mov	ah,es:[bx]	;
	inc	bx		;

	cmp	al,0		;
	jnz	UC_Beat_1	;
	mov	al,48		;
UC_Beat_1:			;
	cmp	ah,0		;0除算エラー防止
	jnz	UC_Beat_2	;
	mov	ah,4		;
UC_Beat_2:			;

	push	ax

	call	hex2asc8
	mov	ah,09h
	int	21h

	mov	dl,','
	mov	ah,02h
	int	21h

	pop	ax

	mov	dl,al		;dl←al（times）
	mov	ax,192		;（timebase × 4）
	div	dl		;al←192 ÷ dl（times）
	mov	ah,al		;
	call	hex2asc8	;
	mov	ah,09h		;
	int	21h		;

	ret
UC_Beat			endp
;===============================================================
;	0xFE	小節（リハーサル）番号
;===============================================================
UC_Measures_M	db	'WC$'
UC_Measures		proc	near

	mov	dx,offset UC_Measures_M
	mov	ah,09h
	int	21h

	mov	dl,'"'
	mov	ah,02h
	int	21h

	mov	ax,es:[bx]
	inc	bx
	inc	bx

	call	hex2asc16
	mov	ah,09h
	int	21h

	mov	dl,'"'
	mov	ah,02h
	int	21h

	ret
UC_Measures		endp
;===============================================================
;	0xFE系コマンドの処理	(AKAO32)
;===============================================================
ifdef	ff8	;------------------------
;---------------------------------------
;	開始
;---------------------------------------
UCDFF_LSTART		proc	near
	MOV	AL,ES:[BX]	;データ読み込み
	INC	BX		;
	jmp	UCDFF_L00	
;---------------------------------------
;	0x00	テンポ
;---------------------------------------
UCDFF_L00:
	CMP	AL,00h		;テンポ命令
	jnz	UCDFF_L02	;
	jmp	UC_Tempo	;
;---------------------------------------
;	0x02	リバーブ
;---------------------------------------
UCDFF_L02:
	CMP	AL,02h		;
	jnz	UCDFF_L04	;
	jmp	UC_Reverb	;
;---------------------------------------
;	0x04	パーカッション
;---------------------------------------
UCDFF_L04:
	CMP	AL,04h		;リズムパートだよ。
	jnz	UCDFF_L06	;
	jmp	UC_PercussionOn	;
;---------------------------------------
;	0x06	終了
;---------------------------------------
UCDFF_L06:
	CMP	AL,06h		;データ終了
	jnz	UCDFF_L07	;
	jmp	UC_PermanentLoop
;---------------------------------------
;	0x07	条件ジャンプ
;---------------------------------------
UCDFF_M07_1	DB	'/*FE,7,$'
UCDFF_M07_2	DB	'*/:$'
UCDFF_L07:
	CMP	AL,07h		;データ終了
	JZ	UCDFF_L07_1	;
	JMP	UCDFF_L09	;
UCDFF_L07_1:
	MOV	DX,OFFSET UCDFF_M07_1
	MOV	AH,09H		;
	INT	21H		;

	mov	ah,es:[bx]	;
	inc	bx		;
	call	hex2asc8	;
	MOV	AH,09H		;
	INT	21H		;

	MOV	AX,ES:[BX]	;
	call	FH2A16
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UCDFF_M07_2
	MOV	AH,09H		;
	INT	21H		;

	inc	bx
	inc	bx

	ret			;
;---------------------------------------
;	0x09	ループ抜け
;---------------------------------------
UCDFF_L09:
	CMP	AL,09h		;
	jnz	UCDFF_L14	;
	jmp	UC_ExitLoop	
;---------------------------------------
;	0x14	音色
;---------------------------------------
UCDFF_M14_1	DB	'0a$'			;音色マクロ名
		DB	'1a$'
		DB	'2a$'
		DB	'3a$'
		DB	'4a$'
		DB	'5a$'
		DB	'6a$'
		DB	'7a$'
		DB	'0b$'
		DB	'1b$'
		DB	'2b$'
		DB	'3b$'
		DB	'4b$'
		DB	'5b$'
		DB	'6b$'
		DB	'7b$'
UCDFF_L14:
	CMP	AL,14h		;音色
	JNZ	UCDFF_L15	;
	MOV	DL,24H		;'$'の出力
	MOV	AH,02H		;
	INT	21H		;
	XOR	AX,AX		;
	MOV	AL,ES:[BX]	;
	INC	BX		;
	MOV	DX,OFFSET UCDFF_M14_1
	ADD	DX,AX		;
	ADD	DX,AX		;
	ADD	DX,AX		;
	MOV	AH,09H		;マクロ番号表示
	INT	21H		;
	RET			;
;---------------------------------------
;	0x15
;---------------------------------------
UCDFF_L15:
	CMP	AL,15h		;不明
	jnz	UCDFF_L16
	jmp	UC_Beat
;---------------------------------------
;	0x16
;---------------------------------------
UCDFF_L16:
	CMP	AL,16h		;不明
	jnz	UCDFF_L1C	;
	jmp	UC_Measures
;---------------------------------------
;	0x1C
;---------------------------------------
UCDFF_M1C_1	DB	'/*FE,1C,$'
UCDFF_M1C_2	DB	'*/$'
UCDFF_L1C:
	CMP	AL,1Ch		;不明
	JZ	UCDFF_L1C_1	;
	jmp	UCDFF_L1F
UCDFF_L1C_1:
	mov	dx,offset UCDFF_M1C_1
	mov	ah,09h
	int	21h

	mov	ah,es:[bx]
	inc	bx
	call	hex2asc8
	mov	ah,09h
	int	21h

	mov	dx,offset UCDFF_M1C_2
	mov	ah,09h
	int	21h

	RET			;
;---------------------------------------
;	0x1F
;---------------------------------------
UCDFF_M1F_1	DB	'/*FE,1F*/$'
UCDFF_L1F:
	CMP	AL,1Fh		;不明
	JZ	UCDFF_L1F_1	;
	jmp	UCDFF_LQQ
UCDFF_L1F_1:
	
	MOV	DX,OFFSET UCDFF_M1F_1
	MOV	AH,09H		;
	INT	21H		;

	RET			;
;---------------------------------------
;	other
;---------------------------------------
UCDFF_Mst	DB	'/*FE,$'
UCDFF_Med	DB	'*/$'
;UCDFF_Mc	DB	',$'
UCDFF_LQQ:

	push	ax
	MOV	DX,OFFSET UCDFF_Mst
	MOV	AH,09H		;
	INT	21H		;
	pop	ax

	mov	ah,al
	call	hex2asc8
	MOV	AH,09H		;
	INT	21H		;

;	MOV	DX,OFFSET UCDFF_Mc
;	MOV	AH,09H		;
;	INT	21H		;
	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	AH,ES:[BX]	;
	INC	BX		;
	call	hex2asc8
	MOV	AH,09H		;
	INT	21H		;

;	MOV	DX,OFFSET UCDFF_Mc
;	MOV	AH,09H		;
;	INT	21H		;
	MOV	DL,2CH		;','の出力
	MOV	AH,02H		;
	INT	21H		;

	MOV	AH,ES:[BX]	;
	INC	BX		;
	call	hex2asc8
	MOV	AH,09H		;
	INT	21H		;

	MOV	DX,OFFSET UCDFF_Med
	MOV	AH,09H		;
	INT	21H		;

	RET			;

UCDFF_LSTART	endp
endif	;--------------------------------
