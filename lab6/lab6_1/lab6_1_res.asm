;**********************************************************************
;��������� 6.2 ��� �� ATx8515: ������������ ������ ������ UART
;� ������ ������ ��� ��������� �������� ������������ ������.
;��� ������� ��������� ���������� 3,69 ���, 
;��� UBRR=11 �������� ������ 19219 ���.
;����������: ������� ���� PB-LED, PD5-SW5, PD0-RXD (PD1-TXD)
;**********************************************************************
;.include "8515def.inc"			;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.def temp = r16					;��������� �������
.def count = r17				;�������
.equ SHOW = 5					;������ ��������� �� 5-� ����� ����� PD

.org $000
		rjmp init
;***������������� ��
INIT:	ldi temp,low(RAMEND)	;���������
		out SPL,temp			; ��������� �����
		ldi temp,high(RAMEND)	; �� ���������
		out SPH,temp			; ������ ���
		ldi YL,0x80				;� �������� Y - �����, �� ��������
		ldi YH,0x01				; ���������� ������ �������� ������
		ldi count,11			;��������� �������� ������
		ser temp				;��������� 
		out DDRB,temp			; ����� PB �� �����
		out PORTB,temp			; � ���������� �����������
		clr temp				
		out DDRD,temp			;��������� 
		ldi temp,(1<<PD5)		; ������ PD5 
		out PORTD,temp			; �� ����  
;***��������� UART �� ���� ������
	;///  ��� ATmega8515 ������� UCSRB ������ UCR, UBRRL
		ldi temp,(1<<RXEN)		;���������� �����
		out UCSRB,temp			; �� ������ UART
		ldi temp,11				;�������� �����/��������
		out UBRRL,temp			; 19219 ���
	;///  ��� ATmega8515 ������� UCSRA ������ USR
WAIT_RXC:	sbis UCSRA,RXC	;��������
		rjmp WAIT_RXC		; ���������� �����
		in temp,UDR			;���� ����� �� ��������
		st Y+,temp			; � ���������� � ������
		dec count			;���������� �������� �� 1
		brne WAIT_RXC		;����������� ������
		clr temp			;������������ � 
		out PORTB,temp		; ���� ��������
LOOP:	ldi YL,0x80			;��������������� ��������� �����
		ldi count,11		;��������� �������� ������ 
WAIT_SHOW:	sbic PIND,SHOW	;�������� �������
		rjmp WAIT_SHOW		; ������ SW5
		ld temp, Y+			;���������� ����� �� ������
		com temp			;�������������� 
		out PORTB,temp		;����� �� ����������
		rcall DELAY			;��������
		dec count			;���� �������� �� ��� ������,
		brne WAIT_SHOW		; �� ����������� ��� ������� SW5
		ser temp			;����� �������
		out PORTB,temp		;���������� ��������
		rjmp LOOP			;���������� ������
;*** �������� ***
DELAY:	ldi r19,20
		ldi r20,255
		ldi r21,255
dd:		dec r21
		brne dd
		dec r20
		brne dd
		dec r19
		brne dd
		ret		
