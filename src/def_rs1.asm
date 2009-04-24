ifdef	rs1	;------------------------
;****************************************************************
;*								*
;*		�v���W�F�N�g��					*
;*								*
;****************************************************************
ProjectName	equ	'RS1MML'



;****************************************************************
;*								*
;*		�o�̓w�b�_					*
;*								*
;****************************************************************
MML2MID_HED:
	DB	'#title     "Romancing Saga 1  "',0dh,0ah
	DB	'#copyright "�@�@(c)SQUARE"',0dh,0ah
	db	0dh,0ah,24h



;****************************************************************
;*								*
;*		FINAL FANTASY 4 �f�[�^�\����`			*
;*								*
;*			�����R���p�C���p			*
;*								*
;****************************************************************
;---------------------------------------
;���A�h���X�֘A
;MUSIC_START	EQU	1D00h	;�f�[�^�̈ʒu	�����ꍇ�́A��`���Ȃ���
;MUSIC_EOF	EQU	1D12h	;�f�[�^�̈ʒu	;�����ꍇ�́A��`���Ȃ���
MUSIC_ADDRESS	EQU	2100h	;�w�b�_�[�̈ʒu
;MUSIC_DATA	EQU	2110h	;�f�[�^�̈ʒu	;�w�b�_�[��SPC�A�h���X�̏ꍇ�A��`���Ȃ�

;---------------------------------------
;���R�}���h�֘A
Music_Note	EQU	0D1h	;�ǂ��܂ŉ����H
comRepeatStart	equ	0EEh	; [ �R�}���h
comRepeatEnd	equ	0EFh	; ] �R�}���h
comRepeatExit	equ	0F0h	; : �R�}���h

;---------------------------------------
;�����ʁE�p���|�b�g���߂̈����̃����W
;	��`���Ȃ��ꍇ	255
;	��`����ꍇ	127	�ishl	ah,1�����s�j
;ExpRange	equ	1	;���� �̃����W
;PanRange	equ	1	;�p�� �̃����W

;---------------------------------------
;���e���|���߂̈����̌W��
TempoMul	equ	60000	;�e���|�̌W���i���q�j
TempoDiv	equ	55296	;�e���|�̌W���i����j

;---------------------------------------
;���e���|�E���ʁE�p�����߂̈���wLengh��type
;Change_tLength	equ	1	;��`��word�^����`��byte

;---------------------------------------
;��LFO���߂̈���Rate�̌W��
;LFO_DepthMul	equ	64	;LFO �����̌W���i���q�j
;LFO_DepthDiv	equ	50	;LFO �����̌W���i����j
;
;LFO_PitchCent	equ	100	;������100�H
LFO_DepthFirst	equ	1	;LFO�́ADepth���ŏ�

;---------------------------------------
;��LFO���߂̈���Rate�̌W��
LFO_RateMul	equ	48	;LFO �����̌W���i���q�j
LFO_RateDiv	equ	40	;LFO �����̌W���i����j

;---------------------------------------
;��LFO���߂̈���Delay�̌W��
;LFO_DelayMul	equ	48	;LFO �����̌W���i���q�j
;LFO_DelayDiv	equ	24	;LFO �����̌W���i����j

;---------------------------------------
;��LFO���߂̈���Delay�̗L��
LFO_PanDelay0	equ	1	;�p���|�b�gLFO�ɁA����Delay����



;=======================================================================|
;			������́E�����p���				|
;-----------------------------------------------------------------------|
;	0	���� �c �^�C�Ōq����Ȃ��B				|
;	1-5	���� �c ��͒��͓��ɋC�ɂ��Ȃ��i�R�}���h�{������byte�����j
;	6	���� �c �����W�����v					|
;	7	���� �c END of Channel �i�������[�v�����j		|
;	8	���� �c END of Channel �i�������[�v�L��j		|
;	9	���� �c �^�C�Ōq�����					|
;=======================================================================|
UCMO_COMMAND_SIZE:
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;00h-0Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;10h-1Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;20h-2Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;30h-3Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;40h-4Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;50h-5Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;60h-6Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;70h-7Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;80h-8Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;90h-9Fh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;A0h-AFh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0	;B0h-BFh
	DB	0,0,0,9, 9,9,9,9, 9,9,9,9, 9,9,9,9	;C0h-CFh
	DB	9,9,2,3, 2,3,2,3, 2,3,1,1, 1,3,1,3	;D0h-DFh
	DB	1,2,1,1, 1,1,3,1, 1,1,1,2, 1,1,2,1	;E0h-EFh
	DB	4,8,1,2, 2,1,1,1, 7,1,1,1, 1,1,1,1	;F0h-FFh

;=======================================================================|
;		�t�l�l�k���						|
;-----------------------------------------------------------------------|
;	�i�ŏ��ɕϊ��A�h���X�{�P����Ă���B�j				|
;	00h	�ϊ��I��						|
;	10h	���������a�������ϊ�	�A�h���X�{�P			|
;	11h	�����L��a�������ϊ�	�A�h���X�{�P			|
;	12h	���������v�������ϊ�	�A�h���X�{�P			|
;	13h	�����L��v�������ϊ�	�A�h���X�{�P			|
;	20h	������o�́@'$'�܂ŏo�͂���B				|
;	21h	���̔����̓^�C�Ōq����邩����				|
;	24h	���̃R�[�h�̏o��					|
;	80h	�p�[�g�I��						|
;	F0h	�A�h���X�{�P	�i����̓R�}���h�̈������j		|
;	FFh	���Ɏ����A�h���X���R�[������				|
;=======================================================================|
UC_D00	DB	' c1$' ,21h,0
UC_D01	DB	' c2.$',21h,0
UC_D02	DB	' c2$' ,21h,0
UC_D03	DB	' c3$' ,21h,0
UC_D04	DB	' c4.$',21h,0
UC_D05	DB	' c4$' ,21h,0
UC_D06	DB	' c6$' ,21h,0
UC_D07	DB	' c8.$',21h,0
UC_D08	DB	' c8$' ,21h,0
UC_D09	DB	' c12$',21h,0
UC_D0A	DB	' c16$',21h,0
UC_D0B	DB	' c24$',21h,0
UC_D0C	DB	' c32$',21h,0
UC_D0D	DB	' c48$',21h,0
UC_D0E	DB	' c64$',21h,0

UC_D0F	DB	' c+1$' ,21h,0
UC_D10	DB	' c+2.$',21h,0
UC_D11	DB	' c+2$' ,21h,0
UC_D12	DB	' c+3$' ,21h,0
UC_D13	DB	' c+4.$',21h,0
UC_D14	DB	' c+4$' ,21h,0
UC_D15	DB	' c+6$' ,21h,0
UC_D16	DB	' c+8.$',21h,0
UC_D17	DB	' c+8$' ,21h,0
UC_D18	DB	' c+12$',21h,0
UC_D19	DB	' c+16$',21h,0
UC_D1A	DB	' c+24$',21h,0
UC_D1B	DB	' c+32$',21h,0
UC_D1C	DB	' c+48$',21h,0
UC_D1D	DB	' c+64$',21h,0

UC_D1E	DB	' d1$' ,21h,0
UC_D1F	DB	' d2.$',21h,0
UC_D20	DB	' d2$' ,21h,0
UC_D21	DB	' d3$' ,21h,0
UC_D22	DB	' d4.$',21h,0
UC_D23	DB	' d4$' ,21h,0
UC_D24	DB	' d6$' ,21h,0
UC_D25	DB	' d8.$',21h,0
UC_D26	DB	' d8$' ,21h,0
UC_D27	DB	' d12$',21h,0
UC_D28	DB	' d16$',21h,0
UC_D29	DB	' d24$',21h,0
UC_D2A	DB	' d32$',21h,0
UC_D2B	DB	' d48$',21h,0
UC_D2C	DB	' d64$',21h,0

UC_D2D	DB	' d+1$' ,21h,0
UC_D2E	DB	' d+2.$',21h,0
UC_D2F	DB	' d+2$' ,21h,0
UC_D30	DB	' d+3$' ,21h,0
UC_D31	DB	' d+4.$',21h,0
UC_D32	DB	' d+4$' ,21h,0
UC_D33	DB	' d+6$' ,21h,0
UC_D34	DB	' d+8.$',21h,0
UC_D35	DB	' d+8$' ,21h,0
UC_D36	DB	' d+12$',21h,0
UC_D37	DB	' d+16$',21h,0
UC_D38	DB	' d+24$',21h,0
UC_D39	DB	' d+32$',21h,0
UC_D3A	DB	' d+48$',21h,0
UC_D3B	DB	' d+64$',21h,0

UC_D3C	DB	' e1$' ,21h,0
UC_D3D	DB	' e2.$',21h,0
UC_D3E	DB	' e2$' ,21h,0
UC_D3F	DB	' e3$' ,21h,0
UC_D40	DB	' e4.$',21h,0
UC_D41	DB	' e4$' ,21h,0
UC_D42	DB	' e6$' ,21h,0
UC_D43	DB	' e8.$',21h,0
UC_D44	DB	' e8$' ,21h,0
UC_D45	DB	' e12$',21h,0
UC_D46	DB	' e16$',21h,0
UC_D47	DB	' e24$',21h,0
UC_D48	DB	' e32$',21h,0
UC_D49	DB	' e48$',21h,0
UC_D4A	DB	' e64$',21h,0

UC_D4B	DB	' f1$' ,21h,0
UC_D4C	DB	' f2.$',21h,0
UC_D4D	DB	' f2$' ,21h,0
UC_D4E	DB	' f3$' ,21h,0
UC_D4F	DB	' f4.$',21h,0
UC_D50	DB	' f4$' ,21h,0
UC_D51	DB	' f6$' ,21h,0
UC_D52	DB	' f8.$',21h,0
UC_D53	DB	' f8$' ,21h,0
UC_D54	DB	' f12$',21h,0
UC_D55	DB	' f16$',21h,0
UC_D56	DB	' f24$',21h,0
UC_D57	DB	' f32$',21h,0
UC_D58	DB	' f48$',21h,0
UC_D59	DB	' f64$',21h,0

UC_D5A	DB	' f+1$' ,21h,0
UC_D5B	DB	' f+2.$',21h,0
UC_D5C	DB	' f+2$' ,21h,0
UC_D5D	DB	' f+3$' ,21h,0
UC_D5E	DB	' f+4.$',21h,0
UC_D5F	DB	' f+4$' ,21h,0
UC_D60	DB	' f+6$' ,21h,0
UC_D61	DB	' f+8.$',21h,0
UC_D62	DB	' f+8$' ,21h,0
UC_D63	DB	' f+12$',21h,0
UC_D64	DB	' f+16$',21h,0
UC_D65	DB	' f+24$',21h,0
UC_D66	DB	' f+32$',21h,0
UC_D67	DB	' f+48$',21h,0
UC_D68	DB	' f+64$',21h,0

UC_D69	DB	' g1$' ,21h,0
UC_D6A	DB	' g2.$',21h,0
UC_D6B	DB	' g2$' ,21h,0
UC_D6C	DB	' g3$' ,21h,0
UC_D6D	DB	' g4.$',21h,0
UC_D6E	DB	' g4$' ,21h,0
UC_D6F	DB	' g6$' ,21h,0
UC_D70	DB	' g8.$',21h,0
UC_D71	DB	' g8$' ,21h,0
UC_D72	DB	' g12$',21h,0
UC_D73	DB	' g16$',21h,0
UC_D74	DB	' g24$',21h,0
UC_D75	DB	' g32$',21h,0
UC_D76	DB	' g48$',21h,0
UC_D77	DB	' g64$',21h,0

UC_D78	DB	' g+1$' ,21h,0
UC_D79	DB	' g+2.$',21h,0
UC_D7A	DB	' g+2$' ,21h,0
UC_D7B	DB	' g+3$' ,21h,0
UC_D7C	DB	' g+4.$',21h,0
UC_D7D	DB	' g+4$' ,21h,0
UC_D7E	DB	' g+6$' ,21h,0
UC_D7F	DB	' g+8.$',21h,0
UC_D80	DB	' g+8$' ,21h,0
UC_D81	DB	' g+12$',21h,0
UC_D82	DB	' g+16$',21h,0
UC_D83	DB	' g+24$',21h,0
UC_D84	DB	' g+32$',21h,0
UC_D85	DB	' g+48$',21h,0
UC_D86	DB	' g+64$',21h,0

UC_D87	DB	' a1$' ,21h,0
UC_D88	DB	' a2.$',21h,0
UC_D89	DB	' a2$' ,21h,0
UC_D8A	DB	' a3$' ,21h,0
UC_D8B	DB	' a4.$',21h,0
UC_D8C	DB	' a4$' ,21h,0
UC_D8D	DB	' a6$' ,21h,0
UC_D8E	DB	' a8.$',21h,0
UC_D8F	DB	' a8$' ,21h,0
UC_D90	DB	' a12$',21h,0
UC_D91	DB	' a16$',21h,0
UC_D92	DB	' a24$',21h,0
UC_D93	DB	' a32$',21h,0
UC_D94	DB	' a48$',21h,0
UC_D95	DB	' a64$',21h,0

UC_D96	DB	' a+1$' ,21h,0
UC_D97	DB	' a+2.$',21h,0
UC_D98	DB	' a+2$' ,21h,0
UC_D99	DB	' a+3$' ,21h,0
UC_D9A	DB	' a+4.$',21h,0
UC_D9B	DB	' a+4$' ,21h,0
UC_D9C	DB	' a+6$' ,21h,0
UC_D9D	DB	' a+8.$',21h,0
UC_D9E	DB	' a+8$' ,21h,0
UC_D9F	DB	' a+12$',21h,0
UC_DA0	DB	' a+16$',21h,0
UC_DA1	DB	' a+24$',21h,0
UC_DA2	DB	' a+32$',21h,0
UC_DA3	DB	' a+48$',21h,0
UC_DA4	DB	' a+64$',21h,0

UC_DA5	DB	' b1$' ,21h,0
UC_DA6	DB	' b2.$',21h,0
UC_DA7	DB	' b2$' ,21h,0
UC_DA8	DB	' b3$' ,21h,0
UC_DA9	DB	' b4.$',21h,0
UC_DAA	DB	' b4$' ,21h,0
UC_DAB	DB	' b6$' ,21h,0
UC_DAC	DB	' b8.$',21h,0
UC_DAD	DB	' b8$' ,21h,0
UC_DAE	DB	' b12$',21h,0
UC_DAF	DB	' b16$',21h,0
UC_DB0	DB	' b24$',21h,0
UC_DB1	DB	' b32$',21h,0
UC_DB2	DB	' b48$',21h,0
UC_DB3	DB	' b64$',21h,0

UC_DB4	DB	' r1$' ,21h,0
UC_DB5	DB	' r2.$',21h,0
UC_DB6	DB	' r2$' ,21h,0
UC_DB7	DB	' r3$' ,21h,0
UC_DB8	DB	' r4.$',21h,0
UC_DB9	DB	' r4$' ,21h,0
UC_DBA	DB	' r6$' ,21h,0
UC_DBB	DB	' r8.$',21h,0
UC_DBC	DB	' r8$' ,21h,0
UC_DBD	DB	' r12$',21h,0
UC_DBE	DB	' r16$',21h,0
UC_DBF	DB	' r24$',21h,0
UC_DC0	DB	' r32$',21h,0
UC_DC1	DB	' r48$',21h,0
UC_DC2	DB	' r64$',21h,0

UC_DC3	DB	' r1$' ,21h,0
UC_DC4	DB	' r2.$',21h,0
UC_DC5	DB	' r2$' ,21h,0
UC_DC6	DB	' r3$' ,21h,0
UC_DC7	DB	' r4.$',21h,0
UC_DC8	DB	' r4$' ,21h,0
UC_DC9	DB	' r6$' ,21h,0
UC_DCA	DB	' r8.$',21h,0
UC_DCB	DB	' r8$' ,21h,0
UC_DCC	DB	' r12$',21h,0
UC_DCD	DB	' r16$',21h,0
UC_DCE	DB	' r24$',21h,0
UC_DCF	DB	' r32$',21h,0
UC_DD0	DB	' r48$',21h,0
UC_DD1	DB	' r64$',21h,0

UC_DD2	DB	0FFh				;�e���|
	dw	offset UC_Tempo			;
	db	00h				;

UC_DD3	DB	0FFh				;���΃e���|
	dw	offset UC_RelativeTempo		;
	db	00h				;

UC_DD4	DB	' E$',0FFh		;expression
	DW	OFFSET UC_SAVE_E	
	DB	00h

UC_DD5	DB	0FFh			;expression move
	DW	OFFSET UC_Expression
	DB	00h

UC_DD6	DB	' p$',0FFh		;panpot
	DW	OFFSET UC_SAVE_P
	DB	00h

UC_DD7	DB	0FFh			;panpot move
	DW	OFFSET UC_Panpot
	DB	00h

UC_DD8	DB	0FFh				;���o�[�u
	dw	offset UC_Reverb		;
	db	00h				;

UC_DD9	DB	0FFh				;���΃��o�[�u
	dw	offset UC_RelativeReverb	;
	db	00h				;

UC_DDA	DB	' /*DA*/$',00h
UC_DDB	DB	' /*DB*/$',00h
UC_DDC	DB	' /*DC*/$',00h

UC_DDD	DB	' IW$',0FFh					;LFO
	dw	offset UC_LFO_IW				;
	db	00h						;

UC_DDE	DB	' IW0$',00h					;LFO off

UC_DDF	DB	' IE$',0ffh					;
	dw	offset UC_LFO_IE				;
	db	00h						;

UC_DE0	DB	' IE0$',00h					;

UC_DE1	DB	' IP$',0ffh					;
	dw	offset UC_LFO_IP				;
	db	' $',00h					;

UC_DE2	DB	' IP0$',00h					;

UC_DE3	DB	' /*E3*/$',00h
UC_DE4	DB	' /*E4*/$',00h
UC_DE5	DB	' /*E5*/$',00h

UC_DE6	DB	' /* EX x7F,x7F,x04,x05,x01,x01,x01,x01,x01,x01,$'
	db	013h				;
	DB	' ,xF7 */$',0			;Reverb FeedBack (Time?)

UC_DE7	DB	' y91,100$',00h
UC_DE8	DB	' y91,0$',00h

UC_DE9	DB	' /*E9*/$',00h
UC_DEA	DB	' /*EA*/$',00h

UC_DEB	DB	' o$',0FFh		;�I�N�^�[�u
	DW	offset UC_Octave	
	DB	0

UC_DEC	DB	' >$',00h		;�I�N�^�[�u�A�b�v

UC_DED	DB	' <$',00h		;�I�N�^�[�u�_�E��

UC_DEE	DB	0FFh				;[
	DW	OFFSET Loop_Start
	DB	00h

UC_DEF	DB	0FFh				;]
	DW	OFFSET Loop_End
	DB	00h

UC_DF0	DB	0FFh				;���[�v����
	dw	offset Loop_Exit		;
	db	00h				;


UC_DF1	DB	0FFh				;�������[�v
	dw	offset UC_PermanentLoop		;
	db	00h				;

UC_DF2	DB	' /*F2*/$',00h

UC_DF3	DB	24h,24h,0FFH		;���F	'$'�̏o��
	DW	OFFSET UC_VOICE_OUTPUT	;	�}�N���ԍ��o��
	DB	00h			;	�g�p�}�N���L��

UC_DF4	DB	' /*F4,$',010h,' */$',00h	

UC_DF5	DB	' /*F5*/$',00h
UC_DF6	DB	' /*F6*/$',00h
UC_DF7	DB	' /*F7*/$',00h

UC_DF8	DB	0FFh
	dw	offset UC_End
	db	00h			;�I��

UC_DF9	DB	' /*F9*/$',00h
UC_DFA	DB	' /*FA*/$',00h
UC_DFB	DB	' /*FB*/$',00h
UC_DFC	DB	' /*FC*/$',00h
UC_DFD	DB	' /*FD*/$',00h
UC_DFE	DB	' /*FE*/$',00h
UC_DFF	DB	' /*FF*/$',00h

endif	;--------------------------------
