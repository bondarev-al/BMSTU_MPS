;****************************************************************
;��������� 6.1 ��� �� ATx8515: ������������ ������ UART.
;��� ������� �� SW4 (START) ���������� ���������������� ��������
;�� ������ UART ��� ������ ���������, ����������� �� ����� flash-������. 
;��� ������� ���������� = 3,69 ���, 
;UBRR=11 �������� �������� 19219 ���.
;����������: PD4-SW4, PD1-TXD (PD0-RXD)
;*****************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"	;���� ����������� ATmega8515
.def temp = r16				;��������� �������
.def count = r17			;�������
.equ START = 4				;4-� ����� ����� PD

.org $000
		rjmp init
;***������������� ��
INIT:	ldi ZL,low(text*2)	;�������� ������ ������
		ldi ZH,high(text*2)	; ��������� � ������� Z
		ldi count,3		;��������� �������� ������
		clr temp			;���������
		out DDRD,temp		; ������ 
		ldi temp,(1<<PD4)	; ����� PD4
		out PORTD,temp		; �� ���� 
;***��������� UART �� �������� ������
	;///  ��� ATmega8515 ������� UCSRB ������ UCR, UBRRL
		ldi temp,(1<<TXEN)	;���������� 
		out UCSRB,temp		; �������� �� ������ UART
		ldi temp,11			;�������� ��������
		out UBRRL,temp		; 19219 ���
WAIT_START:	sbic PIND,START	;�������� �������
		rjmp WAIT_START		;  ������ START
OUTPUT:	lpm					;���������� ����� �� flash-������ � r0
		out UDR,r0			;����� ����� � ����������
	;///  ��� ATmega8515 ������� UCSRA ������ USR
		sbi UCSRA,TXC			; ����� ����� TXC
WAIT:	sbis UCSRA,TXC	;��������
		rjmp WAIT			; ���������� ��������
		adiw zl,1			;���������� ������ �� 1
		dec count			;���������� �������� �� 1
		brne OUTPUT			;����������� ������
fin:	rjmp fin			;�������� ���������
text: 	.db 'A','V','R'	
;(ASCI-���� $41,$56,$52)

