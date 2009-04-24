;=======================================================================|
;									|
;	�ϊ��T�u���[�`��						|
;		10�i�iASCII�j	���@16�i(BIN)				|
;		16�i�iBIN�j	�|�@10�i�iASCII�j			|
;		16�i�iBIN�j	�|�@16�i�iASCII�j			|
;									|
;					Programmed by			|
;						��������		|
;									|
;=======================================================================|
;---------------------------------------------------------------|
;		�����Z���[�`��					|
;---------------------------------------------------------------|
;	����							|
;		AH���������鐔				|
;		AL�������鐔					|
;	�Ԃ�l							|
;		AX����						|
;	�R�����g						|
;		�|���Z���߂�����Z80�Ƃ���CPU�Ŏg����@		|
;		8086�Ȃ񂾂���MUL���ߎg���΂��������		|
;		�Ƃ��v�����ǁc�܂��A�����Ȃ��Ă邩�炢�����B	|
;		�{���ɁA�̂ɏ��������[�`���Ȃ񂾂Ȃ��`�B	|
;---------------------------------------------------------------|
KAKE8	proc	near			;
	PUSH	CX			;
	PUSH	DX			;���W�X�^�ۑ�
	XOR	DX,DX			;DX��0000<h>
	MOV	CH,0			;CH��0
	MOV	CL,1			;CL��00000001<h>
KLOOP0:	TEST	AH,CL			;Bit check
	JZ	KLOOP1			;if 'L' then *KLOOP1
	CALL	KADD			;���Z����(DX+AL*2^CL)
KLOOP1:	INC	CH			;CH��CH+1
	SHL	CL,1			;CL Bit shift ��
	JNC	KLOOP0			;CL>128�ŏI��
	MOV	AX,DX			;
	POP	DX			;
	POP	CX			;���W�X�^���A
	RET				;RETURN
KAKE8	endp				;
;		*************************
;		*	���Z����	*
;		*************************
KADD	proc	near			;DX �� DX+AL*2^CL
	PUSH	AX			;
	XOR	AH,AH			;AH��00h
	CMP	CH,1			;CH=1�Ȃ�Ή��Z�̂�
	JC	KADD1			;
	PUSH	CX			;
	MOV	CL,CH			;
	SHL	AX,CL			;AX��AX*2^CH
	POP	CX			;
KADD1:	ADD	DX,AX			;DX��DX+AX
	POP	AX			;
	RET				;
KADD	endp
;---------------------------------------------------------------|
;		ASCII CODE���P�U�i�R�[�h(-127�`255)		|
;---------------------------------------------------------------|
;	����							|
;		DS:DX���ϊ�������������擪�A�h���X		|
;	�Ԃ�l							|
;		AH���ϊ���					|
;		DS:BX�����̃A�h���X				|
;---------------------------------------------------------------|
HEX_8	DB	00H,00H,00H		;
DHEX8	DB	00H			;
F8FLAG	DB	00H			;
ASC2HEX8	proc	near		;
	PUSH	CX			;
	PUSH	DX			;
	XOR	CX,CX			;CX��0
	MOV	BX,DX			;BX��DX�i������擪�A�h���X�j
	MOV	DX,OFFSET HEX_8		;DX���ϊ��p�f�[�^�o�b�t�@
	XOR	AX,AX			;
	MOV	CS:[F8FLAG],AH		;�����t���O�̃��Z�b�g
	MOV	AH,DS:[BX]		;
	CMP	AH,'-'			;
	JNZ	A2H8L0			;
	INC	BX			;
	MOV	AH,0F8H			;Flag
	MOV	CS:[F8FLAG],AH		;Set
A2H8L0:	MOV	AH,DS:[BX]		;
	INC	BX			;
	SUB	AH,30H			;CHR CODE��HEX CODE
	JNC	A2H8L1			;AH<0�@��������ꎞ�ϊ��I��
	JMP	A2H8E1			;
A2H8L1:	CMP	AH,10			;
	JC	A2H8L2			;AH>10 ��������ꎞ�ϊ��I��
	JMP	A2H8E1			;
A2H8L2:	XCHG	BX,DX			;
	MOV	CS:[BX],AH		;�ۑ�
	INC	BX			;
	XCHG	BX,DX			
	INC	CL			;
	CMP	CL,3			;�R��ϊ�������ꎞ�ϊ��I��
	JZ	A2H8E0			;�i�ő�R��( 0~255)�j
	JMP	A2H8L0			;
A2H8E1:
	DEC	BX			;
A2H8E0:
	CMP	CL,0			;���l�����i-, 0~9�j���������ꍇ
	JNZ	A2H8L3			;�W�����v
	STC				;����ȊO�A
	INC	BX			;�G���[�Ŗ߂�
	JMP	A2H8EE			;
A2H8L3:					;
	MOV	CH,0			;
	MOV	CS:[DHEX8],CH		;
	MOV	CH,CL			;CH���ꎞ�ϊ��ŕϊ�����������
	MOV	CL,3			;CL�����v�Z�p
	XCHG	BX,DX			;	3�10^0	2�10^1	1�10^2
A2H8L4:	
	DEC	BX			;
	MOV	AH,CS:[BX]		;
	CALL	A2H8AA			;���v�Z
	DEC	CL			;
	DEC	CH			;
	JNZ	A2H8L4			;��������
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
	CMP	CL,1			;CL��	�P�̏ꍇ
	JNZ	A2H8C1			;AX��AH*100
	MOV	AL,100			;
	JMP	A2H8C3			;
A2H8C1:	CMP	CL,2			;	�Q�̏ꍇ
	JNZ	A2H8C2			;AX��AH*10
	MOV	AL,10			;
	JMP	A2H8C3			;
A2H8C2:	CMP	CL,3			;	�R�̏ꍇ
	JNZ	A2H8C4			;AX��AH*1
	MOV	AL,1			;
;	JMP	A2H8C3			;
A2H8C3:	CALL	KAKE8			;
	ADD	CS:[DHEX8],AL		;[DHEX8]��[DHEX8]*AX
	RET				;
A2H8C4:	MOV	CL,0			;�b�k������ȊO�̏ꍇ
	XCHG	BX,DX			;�G���[
	POP	DX			;
	MOV	DX,OFFSET A2H8EE	;
	PUSH	DX			;
	STC				;
	RET				;
ASC2HEX8	endp			;
;---------------------------------------------------------------|
;		ASCII CODE���P�U�i�R�[�h(-32767�`65535)		|
;---------------------------------------------------------------|
;	����							|
;		DS:DX���ϊ�������������擪�A�h���X		|
;	�Ԃ�l							|
;		AX���ϊ���					|
;		DS:BX�����̃A�h���X				|
;---------------------------------------------------------------|
HEX_16	DB	00H,00H,00H,00H,00H	;
DHEX16	DW	0000H			;
F6FLAG	DB	00H			;
ASC2HEX16	proc	near		;
	PUSH	CX			;
	PUSH	DX			;
	XOR	CX,CX			;CX��0
	MOV	BX,DX			;BX��DX�i������擪�A�h���X�j
	MOV	DX,OFFSET HEX_16	;DX���ϊ��p�f�[�^�o�b�t�@
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
	SUB	AH,30H			;CHR CODE��HEX CODE
	JNC	A2H6L1			;AH<0�@��������ꎞ�ϊ��I��
	JMP	A2H6E1			;
A2H6L1:	CMP	AH,10			;
	JC	A2H6L2			;AH>10 ��������ꎞ�ϊ��I��
	JMP	A2H6E1			;
A2H6L2:	XCHG	BX,DX			
	MOV	CS:[BX],AH		;�ۑ�
	INC	BX			;
	XCHG	BX,DX			
	INC	CL			;
	CMP	CL,5			;�T��ϊ�������ꎞ�ϊ��I��
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
;		�P�U�i���R�[�h�`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
	DB	'-'			;����
ASC_8	DB	'$$$$$'			;
HEX2ASC8	proc	near
	PUSH	AX			
	PUSH	BX			
	PUSH	CX			;���W�X�^�ۑ�
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
	JC	H2A8L3			;�P�O�O�̈ʂ���H
	
	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,100			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L3:	
	CMP	AL,' '			;AL=" "��������P�O�O�̈ʂ͖�������
	JNZ	H2A8E2			
	CMP	AH,10			;�P�O�̈ʂ���H
	JC	H2A8L2			
	
H2A8E2:	MOV	AL,AH			
	XOR	AH,AH			
	MOV	CH,10			
	DIV	CH			
	ADD	AL,30H			
	MOV	CS:[BX],AL		
	INC	BX			
H2A8L2:	
	ADD	AH,30H			;��̈ʂ͕K������
	MOV	CS:[BX],AH		;
	
	MOV	DX,OFFSET ASC_8		;�A�h���X
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC8	endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(65535)		|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AX���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
;---------------------------------------------------------------|
	DB	'-'			;����
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
	CMP	DX,10000		;�P�O�O�O�O�̈ʂ͂���H
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
	CMP	DX,1000			;�P�O�O�O�̈ʂ́H
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
	CMP	DX,100			;�P�O�O�̈�
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
	CMP	DX,10			;�P�O�̈ʂ́H
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
	MOV	CS:[BX],AL		;�P�̈ʂ͕K������
	
	MOV	DX,OFFSET ASC_16	
	POP	CX			
	POP	BX			
	POP	AX			
	RET				
HEX2ASC16	endp
;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(255)	�i�����t���j	|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
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
;		�P�U�i���R�[�h�`ASCII CODE(65535)�i�����t���j	|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
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
;		�P�U�i���R�[�h�`ASCII CODE(255)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�O�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;		�X�y�[�X�ŁA�E����				|
;	����							|
;		AH���ϊ����������l				|
;	�Ԃ�l							|
;		DX���ϊ�����������̐擪�A�h���X		|
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
;		�P�U�i���R�[�h�`ASCII CODE(FF)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�U�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		AL���ϊ����������l				|
;	�Ԃ�l							|
;		CS:DX���ϊ�����������̐擪�A�h���X		|
;	�R�����g						|
;		���̏������́A�������̋ߍ����B			|
;---------------------------------------------------------------|
dat2hex8_Print	db	'00$'
dat2hex8	proc	near	uses ax

		mov	ah,al		;
		shr	al,4		;ah������4bit
		and	ax,0f0fh	;al�����4bit

		cmp	al,0ah		;
		jc	dat2hex8_Low	;����4bit��0x0A�ȉ��H
		add	al,7		;
dat2hex8_Low:				;
		cmp	ah,0ah		;
		jc	dat2hex8_Hi	;���4bit��0x0A�ȉ��H
		add	ah,7		;
dat2hex8_Hi:				;
		add	ax,3030h	;

		mov	word ptr cs:[dat2hex8_Print],ax

		push	cs		;
		pop	ds		;ds:dx��far &(dat2hex8_Print)
		mov	dx,offset dat2hex8_Print

		ret			;
dat2hex8	endp			;

;---------------------------------------------------------------|
;		�P�U�i���R�[�h�`ASCII CODE(FF)			|
;---------------------------------------------------------------|
;	����							|
;		�P�U�i�R�[�h���P�U�i�̃A�X�L�[�R�[�h�ɕϊ�	|
;	����							|
;		ax���ϊ����������l				|
;	�Ԃ�l							|
;		CS:DX���ϊ�����������̐擪�A�h���X		|
;	�R�����g						|
;		���̏������́A�������̋ߍ����B			|
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
		pop	ds		;ds:dx��far &(dat2hex8_Print)
		mov	dx,offset dat2hex16_Print

		ret			;
dat2hex16	endp			;

