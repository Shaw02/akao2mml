;************************************************************************
;*									*
;*		�t�l�l�k��						*
;*									*
;************************************************************************
;---------------------------------------------------------------|
;		�����o��					|
;---------------------------------------------------------------|
;	����							|
;		�����E�I�N�^�[�u���v�Z���ďo��			|
;	����							|
;		al	Note Number				|
;---------------------------------------------------------------|
c_output_note_N		dw	offset c_output_note_C
			dw	offset c_output_note_Ds
			dw	offset c_output_note_D
			dw	offset c_output_note_Es
			dw	offset c_output_note_E
			dw	offset c_output_note_F
			dw	offset c_output_note_Gs
			dw	offset c_output_note_G
			dw	offset c_output_note_As
			dw	offset c_output_note_A
			dw	offset c_output_note_B
			dw	offset c_output_note_H
c_output_note_C		db	'c$'
c_output_note_Ds	db	'c+$'
c_output_note_D		db	'd$'
c_output_note_Es	db	'd+$'
c_output_note_E		db	'e$'
c_output_note_F		db	'f$'
c_output_note_Gs	db	'f+$'
c_output_note_G		db	'g$'
c_output_note_As	db	'g+$'
c_output_note_A		db	'a$'
c_output_note_B		db	'a+$'
c_output_note_H		db	'b$'
c_output_note_O		db	'o$'

c_output_note	proc	near
	pusha

	xor	ah,ah			;ax �� Note
	mov	dl,12			;
	div	dl			;ah �� octave
	xchg	al,ah			;al �� note


	push	ax
	mov	dx,offset c_output_note_O
	mov	ah,09h
	int	21h			;'o'�̕\��
	pop	ax

	push	ax
	dec	ah			
	call	hex2asc8
	mov	ah,09h
	int	21h			;�I�N�^�[�u�l
	pop	ax

	xor	ah,ah			;ax��Note Number
	shl	ax,1
	mov	bx,offset c_output_note_N
	add	bx,ax
	mov	dx,cs:[bx]
	mov	ah,09h
	int	21h			;�����̏o��

c_output_note_End:
	popa
	ret
c_output_note	endp
;---------------------------------------------------------------|
;		�����o��					|
;---------------------------------------------------------------|
;	����							|
;		�����i�`�`�������j�ƁA				|
;		����ɁA�t�_�����t�������v�Z����B		|
;	����							|
;		ax	����					|
;	�R�����g						|
;		�̏��������̃A���S���Y�������A			|
;		�ŋߌ�����A������Ă�̂�����Ȃ��������B	|
;		�����ƁA�R�����g�����Ă������B		|
;		���b���ꃉ�C�N�ɏ���������			|
;---------------------------------------------------------------|
timebase	equ	48
c_output_length	proc	near

	local	c_output_length_Now:word

	pusha

	mov	c_output_length_Now,ax
	xor	cx,cx			;�܂��A�t�_�����O

	.if	(ax!=0)

		.while	(cx<14)
			mov	bx,0001h		;
			.if	(cx>0)			;�@�@�@�@�@�@�@�@�@(2^�t�_�̐�)
				shl	bx,cl		;ax = ���� �~ ����������������������
			.endif				;�@�@�@�@�@�@�@�@(2^(�t�_�̐�+1)-1)
			mul	bx			;�@�@�@���@���@���@���@��
			shl	bx,1			;�t�_������������ꍇ�̉������v�Z���Ă���B
			dec	bx			;
			div	bx			;

			.if	(dx==0)			;����Z�ŁA�]�肪��������A�ʖ�
				mov	bx,ax		;
				xor	dx,dx		;
				xor	ax,ax		;
				mov	al,timebase	;
				shl	ax,2		;
				div	bx		; (timebase�~4)������
				.if	(dx==0)		;����Z�ŁA�]�肪��������A�ʖ�
					.break
				.endif
			.endif

			mov	ax,c_output_length_Now
			inc	cx			;

		.endw				;�t�_�̐����₵�Ă�蒼���B

		.if	(cx==14)		;
			xor	cx,cx		;bx reset
			push	ax		;�iStep�Ŏw�肷��B�j
			mov	dl,'%'		;�Ăԏꍇ�́ABX=0�Ƃ��鎖
			mov	ah,02h		;
			int	21h		;
			pop	ax		;
		.endif

	.endif

	call	hex2asc16		;
	mov	ah,09h			;
	int	21h			;

	.while	(cx>0)			;�t�_�\��
		mov	dl,'.'		;
		mov	ah,02h		;
		int	21h		;
		dec	cx		;
	.endw

c_output_length_End:			;
	popa				;
	ret				;
c_output_length	endp
;---------------------------------------------------------------|
;		�������[�v���					|
;---------------------------------------------------------------|
;	����							|
;		�������[�v�A�h���X����������B			|
;	����							|
;		bx	�`�����l���̊J�n�A�h���X		|
;---------------------------------------------------------------|
UCMOLS_LOOP_msg1	DB	'/*Loop=0x$'
UCMOLS_LOOP_msg2	DB	'*/$'
UCMOLS_LOOP_msg3	DB	'�����W�����v�����G����$'
UCMOLS_LOOP_msg4	DB	'���s�[�g���΂���$'

UCMOLS_LOOP_PTY		equ	8
UCMOLS_LOOP_ADDRESS	DW	UCMOLS_LOOP_PTY	dup(0)
UCMOLS_LOOP_Count	dw	0

UCMO_LOOP_SEARCH	proc	near	uses ax bx cx dx di

	local	ptStart:WORD		;�`�����l���̊J�n�A�h���X
	local	tempBX:WORD		;�����W�����v��̕ۑ�
	local	iCount:WORD		;0xFE07�̃J�E���g�p

;	�f�o�b�O�p
	mov	dx,offset UCMOLS_LOOP_msg1
	mov	ah,09h
	int	21h

	;���[�v�A�h���X���Z�b�g
	push	es
	xor	ax,ax			;ax��0 �ϐ��N���A�p
	mov	cx,UCMOLS_LOOP_PTY	;�񐔃Z�b�g
	mov	di,offset UCMOLS_LOOP_ADDRESS
	push	cs			
	pop	es			;es:di �� �A�h���X
  rep	stosw				;�ꊇ�Z�b�g
	pop	es

	mov	cs:[UC_LoopCountData],ax	;���s�[�g�����p

	mov	cs:[UCMOLS_LOOP_Count],ax	;�������[�v�p
	mov	tempBX,ax			;
	mov	iCount,1			;iCount��1


  .repeat		;0xFE07 �R�}���h�Ɋ֘A���郊�s�[�g�Ƃ���

    .repeat		;0xFE06 �R�}���h���������A�����W�����v�ɂ�郊�s�[�g

	MOV	AX,BX				;
	MOV	ptStart,AX		;�擪�A�h���X�ۑ�

      .repeat		;EoC������܂ł̃��s�[�g

	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ��݁@��
	MOV	DX,OFFSET UCMO_COMMAND_SIZE
	ADD	DX,AX			;
	MOV	AH,AL			;AH���R�}���h
	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�f�[�^�ǂݍ��݁@��͏��
	XCHG	BX,DX			;

ifdef	SPC	;------------------------
	;���[�v���߂̉��	;-------
	.if	(ah==comRepeatStart)
		inc	bx		;�R�}���h�̕������i�܂���
		call	Loop_StartEx
		.continue
	.elseif	(ah==comRepeatExit)
		inc	bx		;�R�}���h�̕������i�܂���
		call	Loop_ExitEx
		.continue
	.elseif	(ah==comRepeatEnd)
		inc	bx		;�R�}���h�̕������i�܂���
		call	Loop_EndEx
		.continue
	.endif
	;-------------------------------
endif	;--------------------------------

	.if	((al==0)||(al==9))	;�����EEoC�������ꍇ�̏���
ifdef	SPC	;------------------------
		mov	al,1	;
endif	;--------------------------------
ifdef	PS1	;------------------------
		.if	(ah<0F0h)	;
			mov	al,1	;
		.else
			mov	al,2	;
		.endif
endif	;--------------------------------
	.endif

	.if	(al==6)
ifdef	ff8	;------------------------
		MOV	AX,ES:[BX]		;

		.if	(ax==006FEh)
			MOV	DX,BX		;DX��FE06h�R�}���h�̃A�h���X
			ADD	BX,2		;
			MOV	AX,ES:[BX]	;
			TEST	AX,AX		;
			JZ	UCMOL_EE	;If AX=0 Then Return
			add	bx,ax		;BX�����[�v��A�h���X
			mov	ax,bx		;AX��BX
			.break
		.elseif	(ax==007FEh)
			.if	(tempBX!=0)
				;�f�o�b�O�p
				push	ax
				mov	dx,offset UCMOLS_LOOP_msg3
				mov	ah,09h
				int	21h
				pop	ax
			.endif
			inc	iCount		;
			add	bx,3		;
			mov	ax,es:[bx]	;
			add	ax,bx		;
			mov	tempBX,ax	;�����W�����v��
			add	bx,2		;FF8�́A�Ō�ɃJ�E���g

		.elseif	((ax==004FEh)||(ax==01DFEh)||(ax==01EFEh)||(ax==01FFEh))
			add	bx,2
		.elseif	((ax==010FEh)||(ax==014FEh)||(ax==01CFEh))
			add	bx,3
		.elseif	(ax==009FEh)
			add	bx,5
		.else
			add	bx,4
		.endif
else	;--------------------------------
		.if	(tempBX!=0)
			;�f�o�b�O�p
			push	ax
			mov	dx,offset UCMOLS_LOOP_msg3
			mov	ah,09h
			int	21h
			pop	ax
		.endif
		inc	iCount			;
		add	bx,1			;
		mov	ax,es:[bx]		;
		add	bx,2			;���̃R�}���h
  ifdef	SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;ax���߂���΃A�h���X
  endif	;--------------------------------
  ifdef	PS1	;------------------------
		add	ax,bx			;
  endif	;--------------------------------
		mov	tempBX,ax		;�����W�����v��ۑ�
endif	;--------------------------------

	.elseif	(al==7)
		jmp	UCMOL_EE		;�I��

	.elseif	(al==8)
		mov	dx,bx			;
		ADD	BX,1			;
		MOV	AX,ES:[BX]		;
		TEST	AX,AX			;
		JZ	UCMOL_EE		;If AX=0 Then Return
ifdef	SPC	;------------------------
		sub	ax,cs:[UC_ADDER]	;ax���߂���΃A�h���X
endif	;--------------------------------
ifdef	PS1	;------------------------
		add	ax,MUSIC_ADDRESSa
		add	ax,bx			;ax���߂���΃A�h���X
endif	;--------------------------------
		mov	bx,ax			;BX��AX
		.break
	.else
		MOV	AH,0		;
		ADD	BX,AX		;

	.endif

      .until	0	;���̃��s�[�g�́A".break"�Ŕ�����B



	;�����W�����v��������A���̃W�����v��ł܂��J��Ԃ��B
    .until	((ptStart<=ax)&&(dx>=ax))



	mov	ax,cs:[UCMOLS_LOOP_Count]	;
	shl	ax,1				;
	push	ax				;bx������鏊
	MOV	ax,bx				;ax���������[�v��
	pop	bx				;�������[�v�A�h���X�̓o�^
	MOV	CS:[UCMOLS_LOOP_ADDRESS + bx],ax

	;�f�o�b�O�p�o��
	call	dat2hex16	;
	MOV	AH,09H		;
	INT	21H		;
	mov	dl,2ch		;
	mov	ah,02h		;
	int	21h		;

	mov	bx,tempBX			;���̊J�n�_
	mov	tempBX,0			;�ꉞ�N���A

	inc	cs:[UCMOLS_LOOP_Count]		;�������[�v���@�{�{
	dec	iCount				;0xFE07�p
  .until	(iCount==0)

UCMOL_EE:					;�������[�v�����I
	;�f�o�b�O�p
	mov	dx,offset UCMOLS_LOOP_msg2
	mov	ah,09h
	int	21h

	RET
UCMO_LOOP_SEARCH	endp
;---------------------------------------------------------------|
;		�R�}���h�ϊ�					|
;---------------------------------------------------------------|
;	����							|
;		�P�R�}���h�����AMML�Ƀf�R�[�h���ďo�͂���	|
;	����							|
;		ds	��cs�ł��鎖				|
;		es:bx	�R�}���h�̃|�C���^			|
;	�Ԓl							|
;		es:bx	���̃R�}���h�̃|�C���^			|
;	�j��							|
;		�قڑS�Ẵ��W�X�^				|
;---------------------------------------------------------------|
;�t�l�l�k�ϊ����̂���A�h���X
;���̂́A�^�C�g�����̒�`�t�@�C���B
UC_DATA_ADDRESS:
	DW	OFFSET UC_D00	;�R�}���h00h
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

ifdef	PS1	;---------------
c_decode_Length:
	db	1
	db	2
	db	4
	db	8
	db	16
	db	32
	db	64
	db	6
	db	12
	db	24
	db	48
endif	;-----------------------

c_decode	proc	near

	local	UCMO_ComStartFlag:byte

	mov	UCMO_ComStartFlag,1

	;�R�}���h�ǂݍ���
	XOR	AX,AX			;
	MOV	AL,ES:[BX]		;�f�[�^�ǂݍ���
	INC	BX			;�|�C���^�C���N�������g

ifdef	Rhythm12	;---------------
	.if	((ax<(Rhythm12*12))&&(cs:[UC_Rhythm_flag]==1))
		pusha

		mov	dl,Rhythm12
		div	dl		;cl������
		mov	cx,ax		;ch���]��

		push	ax

		mov	dl,'$'
		mov	ah,02h
		int	21h		;$

		.if	(cl<6)
			mov	dl,'x'
			add	cl,30h
		.else
			mov	dl,'y'
			add	cl,30h-6
		.endif
		push	dx
		mov	dl,cl
		mov	ah,02h
		int	21h		;�ԍ��i0�`5�j

		pop	dx
		mov	ah,02h
		int	21h		;�}�N���@�p����

		pop	ax

  ifdef	PS1	;-----------------------
		;�����̕\��
		mov	bx,cs:[UC_Rhythm_Address]
		xor	ah,ah
		add	bx,ax
		shl	ax,2
		add	bx,ax
		inc	bx		;bx += ax*5 + 1
		mov	al,es:[bx]
		call	c_output_note

		;�����̕\��
		.if	(byte ptr cs:[UC_Step_work]==0)
			xor	ax,ax
			mov	al,ch		;ax���������R�[�h
			mov	bx,offset c_decode_Length
			add	bx,ax
			mov	ah,cs:[bx]
		.else
			mov	dl,'%'
			mov	ah,02h			;
			int	21h			;
			mov	ah,byte ptr cs:[UC_Step_work]
		.endif
		call	hex2asc8
		mov	ah,09h
		int	21h			;
  endif	;-------------------------------

		popa
	.endif
endif	;-------------------------------

	SHL	AX,1			;
	PUSH	BX			;
	MOV	BX,OFFSET UC_DATA_ADDRESS
	ADD	BX,AX			;BX���ϊ����A�h���X�i�[�A�h���X
	MOV	DX,CS:[BX]		;DX���ϊ����A�h���X
	POP	BX			;

	;EoC����Ȃ��Ԃ�������A�������[�v�B
	.while	(byte ptr cs:[c_Command_EoC]==00h)

	XCHG	BX,DX			;
	MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
	INC	BX			;
	XCHG	BX,DX			;

	.if	(al==00h)
		;�ϊ�����0x00����������A.break
		.break				;End

	.elseif	(al==10h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		CALL	HEX2ASC8		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==11h)
		PUSH	DX			;
		MOV	AH,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		CALL	FH2A8			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==12h)
		PUSH	DX
		MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		INC	BX			;�|�C���^�C���N�������g
		CALL	HEX2ASC16		;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==13h)
		PUSH	DX			;
		MOV	AX,ES:[BX]		;�f�[�^�ǂݍ���
		INC	BX			;�|�C���^�C���N�������g
		INC	BX			;�|�C���^�C���N�������g
		CALL	FH2A16			;
		MOV	AH,09H			;
		INT	21H			;
		POP	DX			;

	.elseif	(al==20h)

ifdef	Rhythm12	;---------------
ifdef	PS1	;-----------------------
	    .if	((UCMO_ComStartFlag==1)&&(byte ptr es:[bx-1]<(Rhythm12*12))&&(cs:[UC_Rhythm_flag]==1))

	    .else
endif	;-------------------------------
endif	;-------------------------------

		.if	((UCMO_ComStartFlag==1)&&(byte ptr es:[bx-1]<=Music_Note)&&(byte ptr cs:[UC_Step_work]!=0))

			XCHG	BX,DX			;
			push	dx

			mov	dl,cs:[bx]		;1�����\��
			mov	ah,02h			;
			int	21h			;

			mov	dl,cs:[bx+1]		;
			.if	(dl=='+')
				inc	bx		;1
				mov	ah,02h		;
				int	21h		;�����\��
			.endif
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

		.else

			PUSH	DX			;
			MOV	AH,09H			;�\��
			INT	21H			;
			POP	DX			;

		.endif

ifdef	Rhythm12	;---------------
ifdef	PS1	;-----------------------
	    .endif
endif	;-------------------------------
endif	;-------------------------------

		.repeat
			XCHG	BX,DX			;
			MOV	AL,CS:[BX]		;�ϊ����ǂݍ���
			INC	BX			;
			XCHG	BX,DX			;
		.until	(al=='$')

	;���̉������A�^�C�t������������B
	.elseif	(al==21h)

		PUSH	BX			;
		PUSH	DX			;

		.repeat

		XOR	AX,AX			;
		MOV	AL,ES:[BX]		;�f�[�^�ǂݍ��݁@��
		MOV	DX,OFFSET UCMO_COMMAND_SIZE
		ADD	DX,AX			;
		XCHG	BX,DX			;
		MOV	AL,CS:[BX]		;�f�[�^�ǂݍ��݁@��͏��
		XCHG	BX,DX			;

		.if	(al==0)			;�O�F��͏I���i���� or �x���j
			.if	(byte ptr cs:[UC_portamento_D]!=0)
				mov	dl,'B'		;
				mov	ah,02h		;
				int	21h		;
			;	ifdef	SPC	;-------
				mov	dl,'W'		;
				mov	ah,02h		;
				int	21h		;
				mov	ax,word ptr cs:[UC_Detune_D]	;
				mov	byte ptr cs:[UC_portamento_D],0
				CALL	HEX2ASC16	;�o��
			;	endif	;---------------
			;	ifdef	PS1	;-------
			;	mov	dl,'S'		;
			;	mov	ah,02h		;
			;	int	21h		;
			;	mov	ax,0		;
			;	mov	ah,byte ptr cs:[UC_Detune_D]	;
			;	mov	byte ptr cs:[UC_portamento_D],0
			;	CALL	HEX2ASC8	;�o��
			;	endif	;---------------
				MOV	AH,09H		;
				INT	21H		;�s�b�`�x���h�̃��Z�b�g
			.endif
			.break

		.elseif	(al==6)			;�U�F��͏I��
ifdef	ff8	;------------------------
			MOV	AX,ES:[BX]
			.if	(ax==006FEh)
				.break
			.elseif	((ax==004FEh)||(ax==01DFEh)||(ax==01EFEh)||(ax==01FFEh))
				add	bx,2
			.elseif	((ax==010FEh)||(ax==014FEh)||(ax==01CFEh))
				add	bx,3
			.elseif	((ax==007FEh)||(ax==009FEh))
				add	bx,5
			.else
				add	bx,4
			.endif
else	;--------------------------------
			.break
endif	;--------------------------------

		.elseif	((al==7)||(al==8))	;�V, �W�F��͏I���iEnd of Channel�j
			.break

		.elseif	(al==9)			;�X�F���̉����ƃ^�C�Ōq���B
			mov	dl,'&'		;
			mov	ah,02h		;
			int	21h		;
			.break

		.else				;���̑��̃P�[�X�́A���Z
			MOV	AH,0		;
			ADD	BX,AX		;

		.endif

		.until	0

		POP	DX			;
		POP	BX			;


	.elseif	(al==24h)
		;����1Byte���o�͂���B
		XCHG	BX,DX			;
		PUSH	DX			;
		MOV	AH,02H			;
		MOV	DL,CS:[BX]		;�\�����ǂݍ���
		INT	21H			;�\��
		INC	BX			;
		POP	DX			;
		XCHG	BX,DX			;

	.elseif	(al==0f0h)
		;�|�C���^��i�߂邾��
		INC	BX			;�|�C���^�C���N�������g

	.elseif	(al==0ffh)
		;����word�Ɏ������Address��call����B
		PUSH	DX			;
		PUSH	BX			;
		MOV	BX,DX			;
		MOV	DX,CS:[BX]		;
		POP	BX			;
		CALL	DX			;
		POP	DX			;

		INC	DX			;
		INC	DX			;

		.break	.if	(byte ptr cs:[c_Command_EoC]==01h)

	.else
		;���̑��̃R�[�h���o�Ă�����A���̃`�����l���̋tMML�I��
		mov	byte ptr cs:[c_Command_EoC],01h
		.break

	.endif

	mov	UCMO_ComStartFlag,0

	.endw

	ret
c_decode	endp
;---------------------------------------------------------------|
;		�����ϊ�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�^�C�g���A��ȁA�^�C���x�[�X�̕\��			|
;	�Q�D�f�[�^���						|
;		(1) �g�p�p�[�g��				|
;---------------------------------------------------------------|
MML2MID_HED1:
	db	'8z	@0	/*Instrument of percussion 1z*/'		,0dh,0ah,24h

MML2MID_HED2:
	db	'9z	@48	/*Instrument of percussion 2z*/'		,0dh,0ah,24h

MML2MID_HED3:
	db	0dh,0ah
ifdef	ff7	;------------------------
	DB	'#include "define.mml"',0dh,0ah
else	;--------------------------------
	DB	'#include "init.mml"',0dh,0ah
endif	;--------------------------------
	db	0dh,0ah,24h		;���s�́Aff8mml�ł��o�͂���B

UC_START	proc	near
	;�w�b�_�[�o��
	MOV	DX,OFFSET MML2MID_HED	;����� define��
	MOV	AH,09H			;
	INT	21H			;

	mov	dl,24h			;$�̕\��
	mov	ah,02h			;
	int	21h			;
	MOV	DX,OFFSET MML2MID_HED1	;
	MOV	AH,09H			;
	INT	21H			;

	mov	dl,24h			;$�̕\��
	mov	ah,02h			;
	int	21h			;
	MOV	DX,OFFSET MML2MID_HED2	;
	MOV	AH,09H			;
	INT	21H			;

	MOV	DX,OFFSET MML2MID_HED3	;
	MOV	AH,09H			;
	INT	21H			;

	;---------------------------------------
	;���`�����l�����̃`�F�b�N
ifdef	SPC	;------------------------
	MOV	CS:[UC_PART],8		;�p�[�g���W
endif	;---------------------------------------

ifdef	PS1	;------------------------
;	dword ptr es:[PARTF_ADDRESS"]�ɂ��āA
;	�r�b�g��"Hi"�̐����`�F�b�N����B���`�����l�����B
;	�����Ӂ�
;	�r�b�g����є�тɂȂ��Ă��Ă��A
;	�`�����l���f�[�^�̃w�b�_�[�͔�є�тɂȂ�Ȃ��B

	push	cx

	mov	cl,0			;Counter
	mov	ch,32			;�p�[�g���ő�

	mov	dx,0000h		;
	mov	ax,0001h		;dx:ax�ŁA32bit���Ƃ���B

	.repeat
		test	word ptr es:[PARTF_ADDRESS+0],ax
		jnz	UC_START_1	;
		test	word ptr es:[PARTF_ADDRESS+2],dx
		jnz	UC_START_1	;
		jmp	UC_START_2	
UC_START_1:
		inc	cl
UC_START_2:
		shl	ax,1		;
		rcl	dx,1		;

		dec	ch		;
	.until	(zero?)

	MOV	CS:[UC_PART],cl		;

	pop	cx
endif	;---------------------------------------

	;---------------------------------------
	;���A�h���X�␳�l�̌v�Z
ifdef	SPC	;------------------------
 ifdef	MUSIC_DATA	;-----------------------
  ifdef	MUSIC_START	;----------------
	MOV	AX,ES:[MUSIC_START]	;ch0���t�A�h���X(ROM��)
  else	;--------------------------------
	MOV	AX,ES:[MUSIC_ADDRESS]	;ch0���t�A�h���X(ROM��)
  endif	;--------------------------------
	SUB	AX,MUSIC_DATA		;�f�[�^�A�h���X(SPC��)
 else	;---------------------------------------
	mov	ax,-0100h		;SPC��SPC700�Ƃł́A0100h �A�h���X���Ⴄ�B
 endif	;---------------------------------------
	MOV	CS:[UC_ADDER],AX	;SPC�A�h���X�ɂ���ׂ̕␳�l
endif	;---------------------------------------

	RET				;
UC_START	endp
;---------------------------------------------------------------|
;		����ϊ�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�l�l�k�o�͕��ł������F�̃}�N����`���o��		|
;---------------------------------------------------------------|
UC_END_VOICE_ADD:
ifdef	PS1	;------------------------
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
endif	;--------------------------------
ifndef	ff7	;------------------------	FF7�ȊO�ŗv��
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
endif	;--------------------------------
ifdef	PS1	;------------------------
UCE_VOICE_0A	DB	'0a	',24h
UCE_VOICE_1A	DB	'1a	',24h
UCE_VOICE_2A	DB	'2a	',24h
UCE_VOICE_3A	DB	'3a	',24h
UCE_VOICE_4A	DB	'4a	',24h
UCE_VOICE_5A	DB	'5a	',24h
UCE_VOICE_6A	DB	'6a	',24h
UCE_VOICE_7A	DB	'7a	',24h
UCE_VOICE_0B	DB	'0b	',24h
UCE_VOICE_1B	DB	'1b	',24h
UCE_VOICE_2B	DB	'2b	',24h
UCE_VOICE_3B	DB	'3b	',24h
UCE_VOICE_4B	DB	'4b	',24h
UCE_VOICE_5B	DB	'5b	',24h
UCE_VOICE_6B	DB	'6b	',24h
UCE_VOICE_7B	DB	'7b	',24h

UCE_VOICE_Program:
 ifdef	ff7	;------------------------
		db	46	;harp
 else	;--------------------------------
		db	48	;strings
 endif	;--------------------------------
		db	1
		db	2
		db	3
		db	4
		db	5
		db	6
		db	7
		db	8
		db	9
		db	10
		db	11
		db	12
		db	13
		db	14
		db	15
endif	;--------------------------------

ifndef	ff7	;------------------------	FF7�ȊO�ŗv��
UCE_VOICE_0C	DB	'0c	',24h
UCE_VOICE_1C	DB	'1c	',24h
UCE_VOICE_2C	DB	'2c	',24h
UCE_VOICE_3C	DB	'3c	',24h
UCE_VOICE_4C	DB	'4c	',24h
UCE_VOICE_5C	DB	'5c	',24h
UCE_VOICE_6C	DB	'6c	',24h
UCE_VOICE_7C	DB	'7c	',24h
UCE_VOICE_0D	DB	'0d	',24h
UCE_VOICE_1D	DB	'1d	',24h
UCE_VOICE_2D	DB	'2d	',24h
UCE_VOICE_3D	DB	'3d	',24h
UCE_VOICE_4D	DB	'4d	',24h
UCE_VOICE_5D	DB	'5d	',24h
UCE_VOICE_6D	DB	'6d	',24h
UCE_VOICE_7D	DB	'7d	',24h
UCE_VOICE_0E	DB	'0e	',24h
UCE_VOICE_1E	DB	'1e	',24h
UCE_VOICE_2E	DB	'2e	',24h
UCE_VOICE_3E	DB	'3e	',24h
UCE_VOICE_4E	DB	'4e	',24h
UCE_VOICE_5E	DB	'5e	',24h
UCE_VOICE_6E	DB	'6e	',24h
UCE_VOICE_7E	DB	'7e	',24h
UCE_VOICE_0F	DB	'0f	',24h
UCE_VOICE_1F	DB	'1f	',24h
UCE_VOICE_2F	DB	'2f	',24h
UCE_VOICE_3F	DB	'3f	',24h
UCE_VOICE_4F	DB	'4f	',24h
UCE_VOICE_5F	DB	'5f	',24h
UCE_VOICE_6F	DB	'6f	',24h
UCE_VOICE_7F	DB	'7f	',24h
endif	;--------------------------------

UCE_VOICE_M0		db	'0z	k127	v127	y100,2	y101,0	y6,64	H0,0	@',24h
UCE_VOICE_M0_VGM	db	'	k127	v127					@',24h

ifdef	Rhythm12	;---------------
UC_Rhythm_Add	dw	offset UC_Rhythm_0x
		dw	offset UC_Rhythm_1x
		dw	offset UC_Rhythm_2x
		dw	offset UC_Rhythm_3x
		dw	offset UC_Rhythm_4x
		dw	offset UC_Rhythm_5x
		dw	offset UC_Rhythm_0y
		dw	offset UC_Rhythm_1y
		dw	offset UC_Rhythm_2y
		dw	offset UC_Rhythm_3y
		dw	offset UC_Rhythm_4y
		dw	offset UC_Rhythm_5y

UC_Rhythm_0x	db	'0x	',24h
UC_Rhythm_1x	db	'1x	',24h
UC_Rhythm_2x	db	'2x	',24h
UC_Rhythm_3x	db	'3x	',24h
UC_Rhythm_4x	db	'4x	',24h
UC_Rhythm_5x	db	'5x	',24h
UC_Rhythm_0y	db	'0y	',24h
UC_Rhythm_1y	db	'1y	',24h
UC_Rhythm_2y	db	'2y	',24h
UC_Rhythm_3y	db	'3y	',24h
UC_Rhythm_4y	db	'4y	',24h
UC_Rhythm_5y	db	'5y	',24h

  ifdef	SPC	;------------------------	���}�T�K�R�ݒ�b��
UCE_VOICE_M1	db	'1z	k127	v127	J',24h
  endif	;-------------------------------
  ifdef	PS1	;------------------------	�o�r�p
UCE_VOICE_M1	db	'1z	k127		J',24h
  endif	;-------------------------------

UCE_VOICE_Note:
  ifdef	SPC	;------------------------	���}�T�K�R�ݒ�b��
		db	36	;B.Drum 1
		db	49	;Cymbal 1
		db	38	;S.Drum 1
		db	57	;Cymbal 2
		db	40	;S.Drum 2
		db	53	;Bell
		db	42	;H.H.Close
		db	42	;H.H.Close
		db	67	;Agogo 
		db	70	;Maracas 
		db	46	;H.H.Open
		db	35	;B.Drum 2
  endif	;-------------------------------
  ifdef	PS1	;------------------------	�e�e�V�ݒ�H�b��
		db	36	;B.Drum 1
		db	37	;
		db	38	;S.Drum 1
		db	39	;
		db	40	;S.Drum 2
		db	41	;
		db	42	;H.H.Close
		db	43	;
		db	44	;H.H.Pedal
		db	45	;
		db	46	;H.H.Open
		db	47	;
  endif	;-------------------------------

endif	;-------------------------------

UCE_VOICE_cr	db	0dh,0ah,24h

UC_Instrument	proc	near

	local	iMultiSample:BYTE

	mov	iMultiSample,0

ifdef	PS1	;------------------------
	XOR	CX,CX			;CL��0
	MOV	SI,OFFSET UC_END_VOICE_ADD
	mov	di,offset UCE_VOICE_Program
  ifdef	ff7	;------------------------
	MOV	BX,OFFSET UC_VoiceExWork
  else	;--------------------------------
	MOV	BX,VOICE_ADDRESS	;�]�����F���A�h���X
	MOV	DX,ES:[BX]		;
	.if	(dx==0000h)
		mov	cx,16
	.else
		add	bx,dx		;BX���]�����F���擪�A�h���X
	.endif
  endif	;--------------------------------

	.while	(cx<16)

  ifdef	ff7	;------------------------
		mov	ax,cs:[bx]		;AL�����F�o�^���
  else	;--------------------------------
		mov	ax,es:[bx]		;AL�����F�o�^���
  endif	;--------------------------------
		.break	.if	(ax==0ffffh)

		mov	dl,'$'
		mov	ah,02h
		int	21h

		lodsw				;�o�͂��ׂ�������̃A�h���X
		mov	dx,ax			;
		MOV	AH,09H			;
		INT	21H			;�o��

		.if	(cs:[D_Debug] & 02h)
		  mov	dx,offset UCE_VOICE_M0_VGM
		.else
		  mov	dl,'$'
		  mov	ah,02h
		  int	21h
		  mov	dx,offset UCE_VOICE_M0
		.endif
		mov	ah,09h
		int	21h

		.if	((cs:[D_Debug] & 02h) && (cx==0))
		  mov	ah,0
		.else
		  mov	ah,cs:[di]
		.endif
		call	hex2asc8
		mov	ah,09h
		int	21h

		mov	dx,offset UCE_VOICE_cr
		MOV	AH,09H			;
		INT	21H			;�o��

		INC	BX			;
		INC	BX			;�A�h���X�C���N�������g
		INC	CX			;
		inc	di

		inc	iMultiSample
	.endw
endif	;-------------------------------



ifndef	ff7	;------------------------
	XOR	CX,CX			;CL��0
	MOV	SI,OFFSET UC_END_VOICE_ADD
  ifdef	PS1	;------------------------
	add	si,32			;PS�́A�]�����F�̕��A���Z����
  endif	;--------------------------------
	MOV	BX,OFFSET UC_VOICE	;

	.while	(cx<64)

		mov	al,cs:[bx]		;AL�����F�o�^���
		.break	.if	(al==0ffh)

		push	ax

		mov	dl,'$'
		mov	ah,02h
		int	21h
		lodsw				;�o�͂��ׂ�������̃A�h���X
		mov	dx,ax			;
		MOV	AH,09H			;
		INT	21H			;�o��

		.if	(cs:[D_Debug] & 02h)
		  mov	dx,offset UCE_VOICE_M0_VGM
		.else
		  mov	dl,'$'
		  mov	ah,02h
		  int	21h
		  mov	dx,offset UCE_VOICE_M0
		.endif
		mov	ah,09h
		int	21h

		pop	ax

		.if	(cs:[D_Debug] & 02h)
		  add	al,iMultiSample
		.endif
		mov	ah,al
		call	hex2asc8
		MOV	AH,09H			;
		INT	21H			;�o��

		mov	dx,offset UCE_VOICE_cr
		MOV	AH,09H			;
		INT	21H			;�o��

		INC	BX			;
		INC	CX			;

	.endw
endif	;-------------------------------
	mov	dx,offset UCE_VOICE_cr
	MOV	AH,09H			;
	INT	21H			;�o��



ifdef	Rhythm12	;---------------
	mov	cx,12
	mov	bx,offset UCE_VOICE_Note
	mov	si,offset UC_Rhythm_Add
  ifdef	PS1	;-----------------------
	mov	di,cs:[UC_Rhythm_Address]
	cmp	di,0
	je	UC_Instrument_NoRhythm	;�p�[�J�b�V��������������f���Ȃ�
  endif	;-------------------------------

	.repeat
		mov	dl,'$'
		mov	ah,02h
		int	21h

		lodsw
		mov	dx,ax
		mov	ah,09h
		int	21h

  ifdef	SPC	;-----------------------
		mov	dl,'$'
		mov	ah,02h
		int	21h

		mov	dx,offset UCE_VOICE_M1
		mov	ah,09h
		int	21h

		mov	ah,cs:[bx]
		call	hex2asc8
		mov	ah,09h
		int	21h
  endif	;-------------------------------
  ifdef	PS1	;-----------------------

		call	UC_Instrument_Phythm_PS1

  endif	;-------------------------------

		mov	dx,offset UCE_VOICE_cr
		MOV	AH,09H			;
		INT	21H			;�o��

		inc	bx
	.untilcxz
UC_Instrument_NoRhythm:
endif	;-------------------------------

	RET
UC_Instrument	endp
;---------------------------------------------------------------|
;		�o�r�P	���Y����`�o��				|
;---------------------------------------------------------------|
UC_Instrument_Phythm_PS1_M1	db	"	/*J",24h
UC_Instrument_Phythm_PS1_M2	db	"	/*",24h
UC_Instrument_Phythm_PS1_ME	db	"*/",24h
UC_Instrument_Phythm_PS1_E	db	"	E",24h
UC_Instrument_Phythm_PS1_P	db	"	p",24h

UC_Instrument_Phythm_PS1	proc	near	uses bx

	;[0]: Voice
	mov	dl,'$'
	mov	ah,02h
	int	21h

	xor	ax,ax				;
	mov	al,es:[di]			;
	inc	di				;
	mov	dx,OFFSET UC_VOICE_NAME		;
	add	dx,ax				;
	add	dx,ax				;
	add	dx,ax				;
	mov	ah,09h
	int	21h

	;[1]:Note Number
	mov	dx,offset UC_Instrument_Phythm_PS1_M1
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h
	mov	dx,offset UC_Instrument_Phythm_PS1_ME
	mov	ah,09h
	int	21h

	;[2]:unknown
	mov	dx,offset UC_Instrument_Phythm_PS1_M2
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h
	mov	dx,offset UC_Instrument_Phythm_PS1_ME
	mov	ah,09h
	int	21h

	;[3]:Expression
	mov	dx,offset UC_Instrument_Phythm_PS1_E
	mov	ah,09h
	int	21h

	xor	ax,ax				;
	mov	al,es:[di]
	inc	di
	MOV	BX,OFFSET UC_Volume_TABLE	;
	ADD	BX,AX				;
	MOV	AH,CS:[BX]			;
	call	hex2asc8
	mov	ah,09h
	int	21h

	;[4]:Panpot
	mov	dx,offset UC_Instrument_Phythm_PS1_P
	mov	ah,09h
	int	21h
	mov	ah,es:[di]
	inc	di
	call	hex2asc8
	mov	ah,09h
	int	21h


	ret
UC_Instrument_Phythm_PS1	endp
;---------------------------------------------------------------|
;		�l�l�k�o�͕�					|
;---------------------------------------------------------------|
;	����							|
;	�P�D�l�l�k�o��						|
;	�Q�D�g�p����Ă��鉹�F�ԍ��̋L��			|
;---------------------------------------------------------------|
UC_PART		DB	?			;�p�[�g��
UC_PART_ASC:
ifdef	SPC	;------------------------
		DB	'A	$',0	;1ch
		DB	'B	$',0	;2ch
		DB	'C	$',0	;3ch
		DB	'D	$',0	;4ch
		DB	'E	$',0	;5ch
		DB	'F	$',0	;6ch
		DB	'G	$',0	;7ch
		DB	'H	$',0	;8ch
UC_ADDER	DW	?			;�擪�A�h���X����
endif	;-------------------------------
ifdef	PS1	;------------------------
		DB	'0A	$'	;1ch
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
endif	;-------------------------------
UC_CR		DB	0Dh,0Ah,24h
UCMO_LOOP_OUTPUT:			;
	DB	'/*L1*/[$'		;
UCMO_LOOP_OUTPUT2:			;
	DB	'/*L2*/[$'		;

c_Command_EoC	db	?		;End of Channel

UC_MML_OUTPUT	proc	near	uses	ax bx cx dx

	local	stAddr:word
	local	endAddr:word

ifdef	MUSIC_EOF	;----------------
	mov	ax,es:[MUSIC_EOF]	;
  ifdef	SPC	;------------------------
	sub	ax,cs:[UC_ADDER]	;
  endif	;--------------------------------
	mov	endAddr,ax		;�I���A�h���X�̐ݒ�
endif	;--------------------------------

	MOV	CL,CS:[UC_PART]		;CL���g�p�p�[�g��
	MOV	CH,0			;CH�����݂̃p�[�g

	;�`�����l������do�`while()��
	.while	(cl!=ch)

	push	cx			;

	XOR	DX,DX			;
	MOV	DL,CH			;
	SHL	DX,1			;
	PUSH	DX			;�A�h���X�v�Z�p
	SHL	DX,1			;
	ADD	DX,OFFSET UC_PART_ASC	;AX��UC_PART_ASC + CH * 4
	MOV	AH,09H			;
	INT	21H			;�p�[�g�\��

	POP	AX			;AX���p�[�g�ԍ����Q
	ADD	AX,MUSIC_ADDRESS	;AX���p�[�g���{AX
	MOV	BX,AX			;
	mov	bx,es:[bx]		;

ifdef	SPC	;------------------------
ifndef	MUSIC_EOF	;----------------
	.if	(bx==0)
		jmp	c_Command_Ch_END	;�|�C���^�`�F�b�N
	.endif
endif	;--------------------------------
endif	;--------------------------------

ifdef	SPC	;------------------------
	sub	bx,cs:[UC_ADDER]	;
endif	;--------------------------------
ifdef	PS1	;------------------------
	add	bx,MUSIC_ADDRESSa	;
	ADD	BX,AX			;BX�����t�A�h���X
endif	;--------------------------------

	mov	stAddr,bx		;�擪�A�h���X

ifdef	MUSIC_EOF	;----------------
	.if	(bx>=endAddr)
		jmp	c_Command_Ch_END	;�|�C���^�`�F�b�N
	.endif
endif	;--------------------------------

	CALL	UCMO_LOOP_SEARCH	;�������[�v���

	call	UC_INIT			;�ϐ�������

;---------------------------------------

	mov	byte ptr cs:[c_Command_EoC],00h

	;"End of Channel"������܂ł�while()��	
	.while	(byte ptr cs:[c_Command_EoC]==00h)

ifdef	MUSIC_EOF	;----------------
		.break	.if	(bx>=endAddr)
endif	;--------------------------------

		;���[�v�A�h���X�̃`�F�b�N
		push	es
		mov	ax,bx			;ax���A�h���X
		mov	cx,UCMOLS_LOOP_PTY	;�񐔃Z�b�g
		mov	di,offset UCMOLS_LOOP_ADDRESS
		push	cs			
		pop	es			;es:di �� �A�h���X
		.repeat
			scasw
			.if	(ZERO?)
				push	ax
				MOV	DX,OFFSET UCMO_LOOP_OUTPUT
				MOV	AH,09H			;
				INT	21H			;
				pop	ax
			.endif
		.untilcxz
		pop	es

		call	c_decode

	.endw

;---------------------------------------
;�`�����l���̏I��

c_Command_Ch_END:

	MOV 	DX,OFFSET UC_CR		;
	MOV	AH,09H	 		;
	INT	21H			;���s
	MOV	DX,OFFSET UC_CR		;
	MOV	AH,09H			;
	INT	21H			;���s

	POP	CX			;
	INC	CH			;�p�[�g�ԍ��C���N�������g

	.endw

;---------------------------------------
c_Command_END:				;
	RET				;RETURN
UC_MML_OUTPUT	endp
;---------------------------------------------------------------|
;		�t�l�l�k�����C�����[�`��			|
;---------------------------------------------------------------|
UN_MML_COMPAILE	proc	near	uses ax es

	MOV	AX,CS:[segAKAO_File]	;
	MOV	ES,AX			;ES��AKAO SEGMENT

	CALL	UC_START	;�����ݒ�
	CALL	UC_MML_OUTPUT	;�l�l�k�o�͕�
	CALL	UC_Instrument	;����ݒ�

	RET			;RETURN
UN_MML_COMPAILE	endp
