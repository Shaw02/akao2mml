;|======================================================|
;|	‚e‚h‚m‚`‚k@‚e‚`‚m‚s‚`‚r‚x@VIII		|
;|		‹t‚l‚l‚kƒRƒ“ƒpƒCƒ‰	Version 1.00	|
;|							|
;|				Programmed By		|
;|					A.Watanabe	|
;|							|
;=======================================================|

.186

ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE

CODE	SEGMENT

	ORG	0100H

COM:	
	JMP	START
;************************************************************************
;*									*
;*		ƒf[ƒ^•”						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;								|
;		‚c‚`‚s‚`					|
;---------------------------------------------------------------|
BSTACK		EQU	0400H		;ƒXƒ^ƒbƒNƒoƒbƒtƒ@
F_ADD		DW	?		;ƒtƒ@ƒCƒ‹–¼Ši”[ƒAƒhƒŒƒX
FILE_H		DW	?		;ƒtƒ@ƒCƒ‹ƒnƒ“ƒhƒ‹
DATSEG		DW	?		;Š„‚è“–‚Ä‚½ƒƒ‚ƒŠ‚ÌƒZƒOƒƒ“ƒg
;
;	‹t‚l‚l‚k•ÏŠ·î•ñ
;
INCLUDE	FF8MML.INC			;î•ñ
;
;	‚e‚e‚W‚Ì‹Èƒf[ƒ^‚ÍA‘Š‘ÎƒAƒhƒŒƒX‚É‚Ä‹LÚ‚³‚ê‚éB
;	
VOICE_ADDRESS	EQU	0030H		
RIHTM_ADDRESS	EQU	0034H		
MUSIC_ADDRESS	EQU	0040H		
;************************************************************************
;*									*
;*		‹t‚l‚l‚k•”						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		‹t‚l‚l‚k•”ƒƒCƒ“ƒ‹[ƒ`ƒ“			|
;---------------------------------------------------------------|
UN_MML_COMPAILE:		;
	CALL	UC_START	;‰ŠúÝ’è
	CALL	UC_MML_OUTPUT	;‚l‚l‚ko—Í•”
	CALL	UC_END		;ŒãŠúÝ’è
	RET			;RETURN
;---------------------------------------------------------------|
;		‰Šú•ÏŠ·					|
;---------------------------------------------------------------|
;	ˆ—							|
;	‚PDƒ^ƒCƒgƒ‹Aì‹ÈAƒ^ƒCƒ€ƒx[ƒX‚Ì•\Ž¦			|
;	‚QDƒf[ƒ^‰ðÍ						|
;		(1) Žg—pƒp[ƒg”				|
;---------------------------------------------------------------|
MML2MID_HED:
	DB	'#title     "‚e‚h‚m‚`‚k@‚e‚`‚m‚s‚`‚r‚x@VIII@@"',0dh,0ah
	DB	'#copyright "A¼@M•v	i‚ƒj‚r‚p‚t‚`‚q‚d"',0dh,0ah
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
	DB	0dh,0ah,24h

UC_START:
	MOV	DX,OFFSET MML2MID_HED	;
	MOV	AH,09H			;
	INT	21H			;
	
	MOV	AX,ES:[MUSIC_ADDRESS]	;Žg—pƒp[ƒg”
	SHR	AX,1			;AX©AX/2
	MOV	CS:[UC_PART],AL		;

	RET				;
;---------------------------------------------------------------|
;		ŒãŠú•ÏŠ·					|
;---------------------------------------------------------------|
;	ˆ—							|
;	‚PD‚l‚l‚ko—Í•”‚Å‚¦‚½‰¹F‚Ìƒ}ƒNƒ’è‹`•¶o—Í		|
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
UCE_VOICE_0A	DB	'0a	H0,2	@48k127	',0dh,0ah,24h	
UCE_VOICE_1A	DB	'1a	H0,3	@1 k127	',0dh,0ah,24h	
UCE_VOICE_2A	DB	'2a	H0,3	@2 k127	',0dh,0ah,24h	
UCE_VOICE_3A	DB	'3a	H0,3	@3 k127	',0dh,0ah,24h	
UCE_VOICE_4A	DB	'4a	H0,3	@4 k127	',0dh,0ah,24h	
UCE_VOICE_5A	DB	'5a	H0,3	@5 k127	',0dh,0ah,24h	
UCE_VOICE_6A	DB	'6a	H0,3	@6 k127	',0dh,0ah,24h	
UCE_VOICE_7A	DB	'7a	H0,3	@7 k127	',0dh,0ah,24h	
UCE_VOICE_0B	DB	'0b	H0,3	@8 k127	',0dh,0ah,24h	
UCE_VOICE_1B	DB	'1b	H0,3	@9 k127	',0dh,0ah,24h	
UCE_VOICE_2B	DB	'2b	H0,3	@10k127	',0dh,0ah,24h	
UCE_VOICE_3B	DB	'3b	H0,3	@11k127	',0dh,0ah,24h	
UCE_VOICE_4B	DB	'4b	H0,3	@12k127	',0dh,0ah,24h	
UCE_VOICE_5B	DB	'5b	H0,3	@13k127	',0dh,0ah,24h	
UCE_VOICE_6B	DB	'6b	H0,3	@14k127	',0dh,0ah,24h	
UCE_VOICE_7B	DB	'7b	H0,3	@15k127	',0dh,0ah,24h	
UCE_VOICE_0C	DB	'0c	H0,3	@16k127	',0dh,0ah,24h	
UCE_VOICE_1C	DB	'1c	H0,3	@17k127	',0dh,0ah,24h	
UCE_VOICE_2C	DB	'2c	H0,3	@18k127	',0dh,0ah,24h	
UCE_VOICE_3C	DB	'3c	H0,3	@19k127	',0dh,0ah,24h	
UCE_VOICE_4C	DB	'4c	H0,3	@20k127	',0dh,0ah,24h	
UCE_VOICE_5C	DB	'5c	H0,3	@21k127	',0dh,0ah,24h	
UCE_VOICE_6C	DB	'6c	H0,3	@22k127	',0dh,0ah,24h	
UCE_VOICE_7C	DB	'7c	H0,3	@23k127	',0dh,0ah,24h	
UCE_VOICE_0D	DB	'0d	H0,3	@24k127	',0dh,0ah,24h	
UCE_VOICE_1D	DB	'1d	H0,3	@25k127	',0dh,0ah,24h	
UCE_VOICE_2D	DB	'2d	H0,3	@26k127	',0dh,0ah,24h	
UCE_VOICE_3D	DB	'3d	H0,3	@27k127	',0dh,0ah,24h	
UCE_VOICE_4D	DB	'4d	H0,3	@28k127	',0dh,0ah,24h	
UCE_VOICE_5D	DB	'5d	H0,3	@29k127	',0dh,0ah,24h	
UCE_VOICE_6D	DB	'6d	H0,3	@30k127	',0dh,0ah,24h	
UCE_VOICE_7D	DB	'7d	H0,3	@31k127	',0dh,0ah,24h	
UCE_VOICE_0E	DB	'0e	H0,3	@32k127	',0dh,0ah,24h	
UCE_VOICE_1E	DB	'1e	H0,3	@33k127	',0dh,0ah,24h	
UCE_VOICE_2E	DB	'2e	H0,3	@34k127	',0dh,0ah,24h	
UCE_VOICE_3E	DB	'3e	H0,3	@35k127	',0dh,0ah,24h	
UCE_VOICE_4E	DB	'4e	H0,3	@36k127	',0dh,0ah,24h	
UCE_VOICE_5E	DB	'5e	H0,3	@37k127	',0dh,0ah,24h	
UCE_VOICE_6E	DB	'6e	H0,3	@38k127	',0dh,0ah,24h	
UCE_VOICE_7E	DB	'7e	H0,3	@39k127	',0dh,0ah,24h	
UCE_VOICE_0F	DB	'0f	H0,3	@40k127	',0dh,0ah,24h	
UCE_VOICE_1F	DB	'1f	H0,3	@41k127	',0dh,0ah,24h	
UCE_VOICE_2F	DB	'2f	H0,3	@42k127	',0dh,0ah,24h	
UCE_VOICE_3F	DB	'3f	H0,3	@43k127	',0dh,0ah,24h	
UCE_VOICE_4F	DB	'4f	H0,3	@44k127	',0dh,0ah,24h	
UCE_VOICE_5F	DB	'5f	H0,3	@45k127	',0dh,0ah,24h	
UCE_VOICE_6F	DB	'6f	H0,3	@46k127	',0dh,0ah,24h	
UCE_VOICE_7F	DB	'7f	H0,3	@47k127	',0dh,0ah,24h	
UC_END:		
	XOR	CX,CX			;CL©0
	MOV	BX,VOICE_ADDRESS	;]‘®‰¹Fî•ñƒAƒhƒŒƒX
	MOV	DX,ES:[BX]		;
	CMP	DX,0000H		;]‘®‰¹F—L‚èH
	JZ	UC_END_L1		;–³‚©‚Á‚½‚çI‚í‚èB
	ADD	BX,DX			;BX©]‘®‰¹Fî•ñæ“ªƒAƒhƒŒƒX
UC_END_L0:
	MOV	AX,ES:[BX]		;“Ç‚Ýž‚Ý
	CMP	AX,0FFFFH		;ÅŒãH
	JZ	UC_END_L1		;
	
	PUSH	BX			;
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'‚Ì•\Ž¦
	MOV	DL,24H			;
	INT	21H			;
	MOV	DX,CS:[BX]		;DX©o—Í‚·‚×‚«•¶Žš—ñ‚ÌƒAƒhƒŒƒX
	MOV	AH,09H			;
	INT	21H			;o—Í
	POP	BX			;
	
	INC	BX			;
	INC	BX			;ƒAƒhƒŒƒXƒCƒ“ƒNƒŠƒƒ“ƒg
	INC	CX			;
	JMP	UC_END_L0		;
UC_END_L1:

	XOR	CX,CX			;CL©0
	MOV	BX,OFFSET UC_VOICE	;
UC_END_L2:
	MOV	AL,CS:[BX]		;AL©‰¹F“o˜^î•ñ
	CMP	AL,0FFh			;î•ñI—¹ŒŸ¸
	JZ	UC_END_LE		;

	PUSH	BX			;
	MOV	BX,OFFSET UC_END_VOICE_ADD
	ADD	BX,32			;
	ADD	BX,CX			;
	ADD	BX,CX			;
	MOV	AH,02H			;'$'‚Ì•\Ž¦
	MOV	DL,24H			;
	INT	21H			;
	MOV	DX,CS:[BX]		;DX©o—Í‚·‚×‚«•¶Žš—ñ‚ÌƒAƒhƒŒƒX
	MOV	AH,09H			;
	INT	21H			;o—Í
	POP	BX			;
	INC	BX			;
	INC	CX			;
	JMP	UC_END_L2		;
UC_END_LE:
	RET
;---------------------------------------------------------------|
;		‚l‚l‚ko—Í•”					|
;---------------------------------------------------------------|
;	ˆ—							|
;	‚PD‚l‚l‚ko—Í						|
;	‚QDŽg—p‚³‚ê‚Ä‚¢‚é‰¹F”Ô†‚Ì‹L‰¯			|
;---------------------------------------------------------------|
UC_PART		DB	?			;ƒp[ƒg”
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
;			ŒŸõî•ñ
;	0@	( Search End )
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
	DB	0,2,2,2, 3,2,1,1, 2,3,2,3, 1,2,1,2	;A0h-AFh
	DB	1,2,1,1, 4,2,1,1, 4,2,1,1, 4,2,1,1	;B0h-BFh
	DB	1,1,1,1, 1,1,1,1, 1,2,1,1, 1,1,1,1	;C0h-CFh
	DB	1,1,1,1, 1,1,1,1, 2,1,1,1, 1,1,1,1	;D0h-DFh
	DB	1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1	;E0h-EFh
	DB	0,0,0,0, 0,0,0,0, 0,0,0,0, 9,0,8,1	;F0h-FFh
UCMO_TAI_OUTPUT:			;
	DB	'&$'			;
UCMO_LOOP_OUTPUT:			;
	DB	'[$'			;
UC_MML_OUTPUT:
	MOV	CL,CS:[UC_PART]		;CL©Žg—pƒp[ƒg”
	MOV	CH,0			;CH©Œ»Ý‚Ìƒp[ƒg
UCMO_L00:
	PUSH	CX			;
	XOR	DX,DX			;
	MOV	DL,CH			;
	SHL	DX,1			;
	PUSH	DX			;ƒAƒhƒŒƒXŒvŽZ—p
	SHL	DX,1			;
	ADD	DX,OFFSET UC_PART_ASC	;AX©UC_PART_ASC + CH * 4
	MOV	AH,09H			;
	INT	21H			;ƒp[ƒg•\Ž¦

	POP	AX			;AX©ƒp[ƒg”Ô†–‚Q
	ADD	AX,MUSIC_ADDRESS	;AX©ƒp[ƒgî•ñ{AX
	MOV	BX,AX			;
	MOV	BX,ES:[BX]		;BX©‰‰‘tƒAƒhƒŒƒXi‘Š‘Îj
	ADD	BX,AX			;BX©‰‰‘tƒAƒhƒŒƒX
	CALL	UCMO_LOOP_SEARCH	;
UCMO_L01:
	MOV	AX,CS:[UCMOLS_LOOP_ADDRESS]	;ƒ‹[ƒvƒAƒhƒŒƒXƒŠƒZƒbƒg
	CMP	AX,BX				;“¯ˆêH
	JNZ	UCMO_L01_1			;
	MOV	DX,OFFSET UCMO_LOOP_OUTPUT	;
	MOV	AH,09H				;
	INT	21H				;
UCMO_L01_1:
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	SHL	AX,1			;
	PUSH	BX			;
	MOV	BX,OFFSET UC_DATA_ADDRESS
	ADD	BX,AX			;BX©•ÏŠ·î•ñƒAƒhƒŒƒXŠi”[ƒAƒhƒŒƒX
	MOV	DX,CS:[BX]		;DX©•ÏŠ·î•ñƒAƒhƒŒƒX
	POP	BX			;
UCMO_L02:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;•ÏŠ·î•ñ“Ç‚Ýž‚Ý
	INC	BX			;
	XCHG	BX,DX			;

	CMP	AL,00h			
	JZ	UCMO_L01		
UCML_L10:
	CMP	AL,10h			
	JNZ	UCMO_L11		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	CALL	HEX2ASC8		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L11:
	CMP	AL,11h			
	JNZ	UCMO_L12		
	PUSH	DX			;
	MOV	AH,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	CALL	FH2A8			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L12:
	CMP	AL,12h			
	JNZ	UCMO_L13		
	PUSH	DX			;
	MOV	AX,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	CALL	HEX2ASC8		
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L13:
	CMP	AL,13h			
	JNZ	UCMO_L20		
	PUSH	DX			;
	MOV	AX,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
	CALL	FH2A8			
	MOV	AH,09H			
	INT	21H			
	POP	DX			;
	JMP	UCMO_L02		
UCMO_L20:
	CMP	AL,20h			;
	JNZ	UCMO_L21		;
	PUSH	DX			;
	MOV	AH,09H			;•\Ž¦
	INT	21H			;
	POP	DX			;
UCMO_L20_1:
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;•ÏŠ·î•ñ“Ç‚Ýž‚Ý
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
	MOV	AL,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý@‹È
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý@‰ðÍî•ñ
	XCHG	BX,DX			;
	CMP	AL,0			;‚OF‰ðÍI—¹
	JZ	UCMO_L21_E		;
	CMP	AL,9			;‚XFŽŸ‚Ì‰¹’ö‚Æƒ^ƒC‚ÅŒq‚®B
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
	MOV	DL,CS:[BX]		;•\Ž¦î•ñ“Ç‚Ýž‚Ý
	INT	21H			;•\Ž¦
	INC	BX			;
	POP	DX			;
	XCHG	BX,DX			;
	JMP	UCMO_L02		;
UCMO_LF0:
	CMP	AL,0F0h			
	JNZ	UCMO_LFF		
	INC	BX			;ƒ|ƒCƒ“ƒ^ƒCƒ“ƒNƒŠƒƒ“ƒg
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
	INT	21H			;‰üs
	MOV	DX,OFFSET UC_CR		;
	MOV	AH,09H			;
	INT	21H			;‰üs

	POP	CX			;
	INC	CH			;ƒp[ƒg”Ô†ƒCƒ“ƒNƒŠƒƒ“ƒg
	CMP	CL,CH			;ƒp[ƒgI—¹H
	JZ	UCMO_END		;
	JMP	UCMO_L00		;
UCMO_END:				;
	RET				;RETURN
;---------------------------------------------------------------|
;		–³ŒÀƒ‹[ƒv‰ðÍ					|
;---------------------------------------------------------------|
;	ˆ—							|
;		–³ŒÀƒ‹[ƒvƒAƒhƒŒƒX‚ðŒŸõ‚·‚éB			|
;---------------------------------------------------------------|
UCMOLS_START_ADDRESS	DW	?
UCMOLS_LOOP_ADDRESS	DW	0000H
UCMO_LOOP_SEARCH:
	PUSH	BX				;
	PUSH	CX				;ƒŒƒWƒXƒ^•Û‘¶

UCMOL_0:MOV	AX,BX				;
	MOV	CS:[UCMOLS_START_ADDRESS],AX	;æ“ªƒAƒhƒŒƒX•Û‘¶
	XOR	AX,AX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;ƒ‹[ƒvƒAƒhƒŒƒXƒŠƒZƒbƒg

UCMOL_1:XOR	AX,AX			;
	MOV	AL,ES:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý@‹È
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	MOV	AH,AL			;AH©ƒRƒ}ƒ“ƒh
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;ƒf[ƒ^“Ç‚Ýž‚Ý@‰ðÍî•ñ
	XCHG	BX,DX			;
	CMP	AL,0			;
	JZ	UCMOL_KEY		;
	CMP	AL,9			;
	JZ	UCMOL_KEY		;
	JMP	UCMOL_2			;
UCMOL_KEY:
	MOV	AL,1			;E0F?hˆÈŠO‚ÌƒRƒ}ƒ“ƒh
	CMP	AH,0F0h			;AL©1
	JC	UCMOL_K			;E0F?h‚ÌƒRƒ}ƒ“ƒh
	MOV	AL,2			;AL©2
UCMOL_K:CMP	AH,0A0h			;E0A0h‚ÌƒRƒ}ƒ“ƒh
	JNZ	UCMOL_2			;ƒp[ƒgI—¹
	JMP	UCMOL_EE		;

UCMOL_2:CMP	AL,8			;
	JNZ	UCMOL_3			;
	MOV	AX,ES:[BX]		;
	CMP	AX,006FEH		;
	JZ	UCMOL_E			;
	CMP	AX,004FEH		;
	JNZ	UCMOL_2_1		;
	ADD	BX,2			;
	JMP	UCMOL_1			;
UCMOL_2_1:				;
	ADD	BX,4			;
	JMP	UCMOL_1			;
UCMOL_3:				;
	MOV	AH,0			;
	ADD	BX,AX			;
	JMP	UCMOL_1			;
UCMOL_E:				;
	MOV	DX,BX				;DX©FE06hƒRƒ}ƒ“ƒh‚ÌƒAƒhƒŒƒX
	ADD	BX,2				;
	MOV	AX,ES:[BX]			;
	TEST	AX,AX				;
	JZ	UCMOL_EE			;If AX=0 Then Return
	ADD	AX,BX				;AX©ƒ‹[ƒvæƒAƒhƒŒƒX
	MOV	BX,AX				;BX©AX
	CMP	DX,AX				;AX < DX ?
	JNC	UCMOL_E1			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E1:
	MOV	DX,CS:[UCMOLS_START_ADDRESS]	;DX©æ“ªƒAƒhƒŒƒX
	CMP	AX,DX				;AX <= DX
	JNC	UCMOL_E2			;
	JMP	UCMOL_0				;ReStrat
UCMOL_E2:
	MOV	AX,BX				;
	MOV	CS:[UCMOLS_LOOP_ADDRESS],AX	;ƒ‹[ƒvƒAƒhƒŒƒXƒŠƒZƒbƒg
UCMOL_EE:
	POP	CX			;
	POP	BX			;
	RET
;************************************************************************
;*									*
;*		”’l•ÏŠ·•”						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		‚P‚Ui”ƒR[ƒh`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚P‚UiƒR[ƒh‚ð‚P‚Oi‚ÌƒAƒXƒL[ƒR[ƒh‚É•ÏŠ·	|
;	ˆø”							|
;		AH©•ÏŠ·‚µ‚½‚¢”’l				|
;	•Ô‚è’l							|
;		DX©•ÏŠ·‚µ‚½•¶Žš—ñ‚Ìæ“ªƒAƒhƒŒƒX		|
;---------------------------------------------------------------|
	DB	'-'			;•„†
ASC_8	DB	'$$$$$'			;
HEX2ASC8:
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			;ƒŒƒWƒXƒ^•Û‘¶
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
	JC	H2A8L3			;‚P‚O‚O‚ÌˆÊ‚ ‚éH
	
	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,100			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L3:	
	CMP	AL,' '			;AL=" "‚¾‚Á‚½‚ç‚P‚O‚O‚ÌˆÊ‚Í–³‚©‚Á‚½
	JNZ	H2A8E2			
	CMP	AH,10			;‚P‚O‚ÌˆÊ‚ ‚éH
	JC	H2A8L2			
	
H2A8E2:	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,10			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L2:	
	ADD	AH,30H			;ˆê‚ÌˆÊ‚Í•K‚¸‘‚­
	MOV	CS:[BX],AH		;
	
	MOV	DX,OFFSET ASC_8		;ƒAƒhƒŒƒX
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
;---------------------------------------------------------------|
;		‚P‚Ui”ƒR[ƒh`ASCII CODE(65535)		|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚P‚UiƒR[ƒh‚ð‚P‚Oi‚ÌƒAƒXƒL[ƒR[ƒh‚É•ÏŠ·	|
;	ˆø”							|
;		AX©•ÏŠ·‚µ‚½‚¢”’l				|
;	•Ô‚è’l							|
;		DX©•ÏŠ·‚µ‚½•¶Žš—ñ‚Ìæ“ªƒAƒhƒŒƒX		|
;---------------------------------------------------------------|
	DB	'-'			;•„†
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
	CMP	DX,10000		;‚P‚O‚O‚O‚O‚ÌˆÊ‚Í‚ ‚éH
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
	CMP	DX,1000			;‚P‚O‚O‚O‚ÌˆÊ‚ÍH
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
	CMP	DX,100			;‚P‚O‚O‚ÌˆÊ
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
	CMP	DX,10			;‚P‚O‚ÌˆÊ‚ÍH
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
	MOV	CS:[BX],AL		;‚P‚ÌˆÊ‚Í•K‚¸‘‚­
	
	MOV	DX,OFFSET ASC_16	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
;---------------------------------------------------------------|
;		‚P‚Ui”ƒR[ƒh`ASCII CODE(255)	i•„†•t‚«j	|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚P‚UiƒR[ƒh‚ð‚P‚Oi‚ÌƒAƒXƒL[ƒR[ƒh‚É•ÏŠ·	|
;	ˆø”							|
;		AH©•ÏŠ·‚µ‚½‚¢”’l				|
;	•Ô‚è’l							|
;		DX©•ÏŠ·‚µ‚½•¶Žš—ñ‚Ìæ“ªƒAƒhƒŒƒX		|
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
;		‚P‚Ui”ƒR[ƒh`ASCII CODE(65535)i•„†•t‚«j	|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚P‚UiƒR[ƒh‚ð‚P‚Oi‚ÌƒAƒXƒL[ƒR[ƒh‚É•ÏŠ·	|
;	ˆø”							|
;		AH©•ÏŠ·‚µ‚½‚¢”’l				|
;	•Ô‚è’l							|
;		DX©•ÏŠ·‚µ‚½•¶Žš—ñ‚Ìæ“ªƒAƒhƒŒƒX		|
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
;		‚P‚Ui”ƒR[ƒh`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚P‚UiƒR[ƒh‚ð‚P‚Oi‚ÌƒAƒXƒL[ƒR[ƒh‚É•ÏŠ·	|
;	ˆø”							|
;		AH©•ÏŠ·‚µ‚½‚¢”’l				|
;	•Ô‚è’l							|
;		DX©•ÏŠ·‚µ‚½•¶Žš—ñ‚Ìæ“ªƒAƒhƒŒƒX		|
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
;*		ƒtƒ@ƒCƒ‹ƒAƒNƒZƒXŠÖŒWƒ‹[ƒ`ƒ“				*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		ƒtƒ@ƒCƒ‹‚ÌƒI[ƒvƒ“				|
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
	MOV	CS:[F_ADD],BX		;ƒtƒ@ƒCƒ‹–¼æ“ªƒAƒhƒŒƒX‚Ì•Û‘¶

FLOP1:	CMP	CH,0			;Šg’£ŽqŽw’è‚Ì‚È‚¢ê‡
	JNZ	FL012			;'.SND'‚Æ‚·‚éB
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

FL020:	MOV	AX,3D00H		;ƒtƒ@ƒCƒ‹‚ÌƒI[ƒvƒ“
	INT	21H			;
	JNC	FL002			;
	JMP	FILE_OPEN_ERROR		;
FL002:	MOV	WORD PTR CS:[FILE_H],AX	;
	RET				;
;---------------------------------------------------------------|
;		ƒtƒ@ƒCƒ‹¨ƒƒ‚ƒŠ“]‘—iOPN Dataj		|
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
;		ƒtƒ@ƒCƒ‹‚ÌƒNƒ[ƒY				|
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
;*		ƒƒ‚ƒŠŠÖŒW						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		ƒƒ‚ƒŠŠm•ÛiOPN Dataj				|
;---------------------------------------------------------------|
MEMORY_OPEN:				;
	MOV	AH,48H			;
	MOV	BX,1000H		;64KByte ‚Ìƒf[ƒ^—Ìˆæ‚ÌŠm•Û
	INT	21H			;
	JNC	NOPERR			;Š„‚è“–‚ÄŽ¸”sŽž‚É”ò‚ÔB
	JMP	MEMORY_OPEN_ERROR	;
NOPERR:	MOV	CS:[DATSEG],AX		;Š„‚è“–‚Ä‚½ƒZƒOƒƒ“ƒgƒAƒhƒŒƒX‚Ì•Û‘¶B
	MOV	ES,AX			;
	RET				;
;---------------------------------------------------------------|
;		ƒƒ‚ƒŠŠJ•úiOPN Dataj				|
;---------------------------------------------------------------|
MEMORY_CLOSE:				;
	MOV	AX,CS:[DATSEG]		;
	MOV	ES,AX			;ƒZƒOƒƒ“ƒg‚ð“Ç‚ÞB
	MOV	AH,49H			;
	INT	21H			;ƒf[ƒ^—Ìˆæ‚ÌŠJ•ú
	JNC	MCLRET			;
	JMP	MEMORY_CLOSE_ERROR	;
MCLRET:	RET				;
;---------------------------------------------------------------|
;								|
;		‚b‚n‚lƒtƒ@ƒCƒ‹‚Ìƒƒ‚ƒŠ[Å¬‰»			|
;---------------------------------------------------------------|
;	ˆ—							|
;		‚b‚n‚lƒvƒƒOƒ‰ƒ€ŽÀsŽž‚Éƒƒ‚ƒŠ[‚ð		|
;		Å¬ŒÀ‚É‚·‚é					|
;	ˆø”							|
;		–³‚µ						|
;	•Ô‚è’l							|
;		DS©CS						|
;		Cy©'L' ‚Ì‚Æ‚«Bi³íI—¹j			|
;		BX©•ÏX‚µ‚½ƒƒ‚ƒŠ[‚Ì‘å‚«‚³B			|
;		Cy©'H' ‚Ì‚Æ‚«BiƒGƒ‰[j			|
;		BX©•ÏX‚Å‚«‚éÅ‘å‚Ì‘å‚«‚³			|
;		AX©INT21H Ì§Ý¸¼®Ý4AHŽQÆ			|
;---------------------------------------------------------------|
SMLME7:	DB	"ƒvƒƒOƒ‰ƒ€‚É‚æ‚éƒƒ‚ƒŠ[’†‚Ìƒf[ƒ^[‚Ì”j‰óB",0DH,0AH,"$"
SMLME8:	DB	"\•ª‚È‹ó‚«ƒƒ‚ƒŠ[‚ª–³‚¢B",0DH,0AH,"$"
SMLME9:	DB	"•s³‚Èƒƒ‚ƒŠ[ƒuƒƒbƒN‚ÌŽg—pB",0DH,0AH,"$"
COMSML:				;ƒƒ‚ƒŠ[‚ÌÅ¬‰»
	PUSH	DX		;
	PUSH	CX		;ƒŒƒWƒXƒ^‚Ì•Û‘¶
	
	MOV	ES,CS:[002CH]		;ŠÂ‹«ƒZƒOƒƒ“ƒg‚ÌŠJ•ú
	MOV	AH,49H			;
	INT	21H			;
	
	MOV	AX,CS		;
	MOV	DS,AX		;DS©CS
	MOV	ES,AX		;ES©CS
	MOV	BX,OFFSET CEND+BSTACK
	MOV	CL,4		;
	SHR	BX,CL		;
	INC	BX		;BX©ƒvƒƒOƒ‰ƒ€‚Ì‘å‚«‚³iƒpƒ‰ƒOƒ‰ƒt’PˆÊj
	MOV	AH,04AH		;
	INT	21H		;Å¬‰»
	PUSH	BX		;
	PUSH	AX		;•Ô‚è’l‚Ì•Û‘¶
	JC	SMLERR		;ƒGƒ‰[Žž‚É”ò‚Ô
	CLC			;Cy©'L'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLERR:				;ƒtƒ@ƒ“ƒNƒVƒ‡ƒ“4AH ‚Ì‚d‚q‚q‚n‚q
	CMP	AX,07H		;
	JNZ	SMLER8		;ERROR CODE=07H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME7
	INT	21H		;ƒƒbƒZ[ƒW‚Ì•\Ž¦
	STC			;Cy©'H'
	JMP	SMLRET		;RETURN
SMLER8:
	CMP	AX,08H		;
	JNZ	SMLER9		;ERROR CODE=08H
	MOV	AH,09H		;
	MOV	DX,OFFSET SMLME8
	INT	21H		;ƒƒbƒZ[ƒW‚Ì•\Ž¦
	STC			;Cy©'L'
	JMP	SMLRET		;RETURN
SMLER9:
	MOV	AH,09H		;ERROR CODE=09H
	MOV	DX,OFFSET SMLME9
	INT	21H		;ƒƒbƒZ[ƒW‚Ì•\Ž¦
	STC			;Cy©'H'
	JMP	SMLRET		;RETURN
;===============================================================|
SMLRET:				;‚q‚d‚s‚t‚q‚m
	POP	AX		;
	POP	BX		;
	POP	CX		;ƒŒƒWƒXƒ^[‚Ì•œ‹A
	POP	DX		;
	RET			;RETURN
;************************************************************************
;*									*
;*		ƒƒCƒ“ƒ‹[ƒ`ƒ“						*
;*									*
;************************************************************************
START:	MOV	AX,OFFSET CEND + BSTACK	;
	MOV	SP,AX			;

	MOV	AX,CS			;
	MOV	DS,AX			;
	MOV	ES,AX			;ƒZƒOƒƒ“ƒg‚ª‚¦‚Ö‚Ö‚ÖB
	MOV	SS,AX			;

	CALL	COMSML			;ƒƒ‚ƒŠ‚ÌÅ¬‰»

	CALL	MEMORY_OPEN		;ƒƒ‚ƒŠ‚ÌŠm•Û
	CALL	FILE_OPEN		;ƒtƒ@ƒCƒ‹‚ðŠJ‚­
	CALL	FILE_READ		;ƒtƒ@ƒCƒ‹‚Ì“Ç‚Ýž‚Ý
	CALL	FILE_CLOSE		;ƒtƒ@ƒCƒ‹‚ð•Â‚¶‚é
	CALL	UN_MML_COMPAILE		;‹t‚l‚l‚kƒRƒ“ƒpƒCƒ‹•”
	CALL	MEMORY_CLOSE		;ƒƒ‚ƒŠ‚Ì‰ð•ú
COMEND:					;
	STI				;Š„‚èž‚Ý‹–‰Â
	MOV	AX,04C00H		;
	INT	21H			;MS-DOS RET
;---------------------------------------------------------------|
;		ƒGƒ‰[ˆ—					|
;---------------------------------------------------------------|
FILE_OPEN_ERR_MES	DB	'ƒtƒ@ƒCƒ‹‚ªŒ©‚Â‚©‚è‚Ü‚¹‚ñB',0DH,0AH,'$'
FILE_NAME_NOTHING_MES	DB	'FF8MML[32;4m ƒtƒ@ƒCƒ‹–¼[.snd]'
			DB	'[32;0m [m',0DH,0AH,'$'
FILE_READ_ERR_MES	DB	'ƒtƒ@ƒCƒ‹‚ð“Ç‚ß‚Ü‚¹‚ñB',0AH,0DH,24H
FILE_CLOSE_ERR_MES	DB	'ƒtƒ@ƒCƒ‹ƒNƒ[ƒY‚ÉŽ¸”s‚µ‚Ü‚µ‚½',0DH,0AH,'$'
MEMORY_OPEN_ERR_MES	DB	'ƒƒ‚ƒŠ‚ª‘«‚è‚Ü‚¹‚ñB',0AH,0DH,24H
MEMORY_CLOSE_ERR_MES	DB	'ƒƒ‚ƒŠ‚Ì‰ð•ú‚ÉŽ¸”s‚µ‚Ü‚µ‚½',0DH,0AH,'$'
PRINT:					;
	PUSH	CS			;
	POP	DS			;DS©CS
	MOV	AH,09H			;
	INT	21H			;•\Ž¦
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
	END	COM
