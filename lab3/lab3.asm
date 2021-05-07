;************************************************************************
;��������� ������������ � STK500 �������� �������������� �������� 
;��������, ���������, ���������, �������
;���� PD - ���� ���������� ��� ������ ��������� � ��������
;���� PB - ���� ��������� �������� ��������� � ����������� ��������
;���������� ��������: ���� PB-LED, ���� PD-SW
;************************************************************************
.include "m8515def.inc"	;���� ����������� ��� ATmega8515
;������ ����� PD
.equ SW_op_AL = 0	;������ ������ �������� op_AL
.equ SW_op_AH = 1	;������ ������ �������� op_AH
.equ SW_op_BL = 2	;������ ������ �������� op_�L
.equ SW_ADD = 3		;������ �������� res=op_AL+op_�L
.equ SW_SUB = 4		;������ ��������� res=op_AL-op_�L
.equ SW_MUL = 5		;������ ��������� op_AL x op_�L
.equ SW_DIV = 6		;������ ������� op_AH.op_AL/op_�L
.equ SW_SHOW = 7	;������ ��������� ��������� ��������-���������, 
					;�������� ����� ������������ ��� ������� ��� �������

.def op_AL = r16		;1-� ������� �L
.def op_AH = r17		;������� ���� �������� AH
.def op_BL = r18		;2-� ������� �L
.def res = r1			;��������� �������� (�����, ��������, 
						; ������� ���� ������������ ��� �������)
.def show = r31			;������� ��������� ��������-���������, 
				; �������� ����� ������������ ��� ������� ��� �������
.def mul_l = r21		;������� ���� ������������
.def mul_h = r22		;������� ���� ������������
.def copy_AH = r23		;����� �������� ����� ��������
.def copy_AL = r24		;����� �������� ����� ��������
.def copy_BL = r25		;����� ���������
.def temp = r26			;��������� �������
.def sw_reg = r27		;������� ��������� ������
.def count = r28		;����� ��������� � ������� ���������
.def c_bit = r29		;������� ������ ��������� (�������) 

.macro vvod			;���� ��������
	lpm				;���������� ����� �� flash-������ � r0
	mov @0,r0		; � ��������� � ������� �������� 
	mov res, r0
	adiw zl, 1		;���������� ��������� ������ �� 1
	dec count
	brne exit
	ldi ZL,low(tabl_op*2)	;������������ ������ ������� ���������
	ldi ZH,high(tabl_op*2)  ; � ������� Z
	ldi count, 10
exit: nop
.endmacro

.org $000
;�������������
	ldi temp,low(RAMEND);���������
	out SPL,temp		; ��������� �����
	ldi temp,high(RAMEND); �� ���������
	out SPH,temp		; ������ ���
	ser temp			;��������� 
	out DDRB,temp		; ����� PB
	out PORTB,temp 		; �� �����
	clr temp			;���������
	out DDRD,temp		; ����� PD
	ser temp			; ��
	out PORTD,temp		; ����
	ldi ZL,low(tabl_op*2)	;�������� ������ ������� ���������
	ldi ZH,high(tabl_op*2)	; � ������� Z
	ldi count,10		;����� ��������� 10
;����� ������ � ���������� �������� ��������
LOOP:	in sw_reg,PIND		 
	sbrs sw_reg,0	
	rjmp f_op_AL				
	sbrs sw_reg,1	
	rjmp f_op_AH				
	sbrs sw_reg,2
	rjmp f_op_BL				
	sbrs sw_reg,3
	rjmp add_bin				
	sbrs sw_reg,4
	rjmp sub_bin				
	sbrs sw_reg,5
	rjmp mul_bin				
	sbrs sw_reg,6
	rjmp div_bin				
	sbrc sw_reg,7
	rjmp loop
	mov res,show
	rjmp outled

;������� 1-�� �������� �� ������� ���������		
f_op_AL:	vvod op_AL
		rjmp outled
;������� �������� ����� 1-�� �������� (��� �������)
f_op_AH: 	vvod op_AH
		rjmp outled
;������� 2-�� �������� 
f_op_BL: 	vvod op_BL
		rjmp outled
;�������� 8-��������� ���������
add_bin: 	mov res,op_AL
		add res,op_BL
		in show,SREG	;������� �� �������� SREG
		rjmp outled	
;��������� 8-��������� ���������
sub_bin: 	mov res,op_AL
		sub res,op_BL
		in show,SREG	;������� �� �������� SREG
		rjmp outled
;���������  8-��������� ���������
mul_bin: 	clr mul_l	;������� �������� 
	clr mul_h			; � �������� ����� ������������
	ldi c_bit,8			;������� ������
	mov copy_BL,op_BL
L1:	clc					;������� ����� C
	sbrc copy_BL,0		;�������� �������� ���� ���������
	add mul_h,op_AL		;����������� ��������� AL
L2:	ror mul_h			;����� ������
	ror mul_l			; 2-� ������ ������������ 
	lsr copy_BL			;����� ��������� ������ 
L3:	dec c_bit			;���������� �������� ������
	brne L1				;���� �� 0, ���������� ���������
	mov res,mul_l		;��������� �������� - �������
	mov show,mul_h		; � ������� ����� ������������
	rjmp outled
;������� 16-���������� ����� �� 8-���������	
div_bin: sbrc op_AH,7	;������ �������� ������
	rjmp error
	sbrc op_BL,7
	rjmp error
	tst op_BL			;������ ��� ������� �� 0
	brsh error
	cp op_AH,op_BL		;������ ��� ������������
	brge error
	clr res				;�������� �������
	ldi c_bit,8			; ����� ��������
	mov copy_AH,op_AH
	mov copy_AL,op_AL
L4:	clc
	rol copy_AL			;�����
	rol copy_AH			; ��������
	lsl res				;����� �������� �����
	sub copy_AH,op_BL	;��������� ��������
	brcs recov			;���� ������� < 0,�������
	inc res				; ����� �������� 1 � �������
	rjmp L5
recov: 	add copy_AH,op_BL	;�������������� �������
L5:	dec c_bit
	brne L4
	mov show,copy_AH	;��������� �������
	rjmp outled
error: 	clr show
	out PORTB,show
	rcall delay
	ser show
	out PORTB,show
	rjmp wait

outled: com res
	out portb,res
	rcall delay
wait: 	in sw_reg,PIND	;�����, ���� ������ �� ��������
	com sw_reg			 
	brne wait
	rjmp loop

; ��������
DELAY: 	ldi r19,10
d1:	ldi r20,255
d2:	ldi r21,255
d3:	dec r21
	brne d3
	dec r20
	brne d2
	dec r19
	brne d1
	ret	
; ������� ���������	
tabl_op: .db 0xB5,0xD7,0xD4,0xC4,0x8B,0x4B,0x6D,0x4E
         .db 0xA8,0x94
