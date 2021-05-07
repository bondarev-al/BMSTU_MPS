;********************************************************************
;��������� 4.1 ��� �� ATx8515:
;������������ ������ ������� �0 � ������ �������� �������;
;������� - ������� ������ SW0.
;���������� : ���� PA0�SW0, ���� PD-LED 
;���������� ���������� ����� ���������� ������� �� ������ SW0
;********************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.def temp = r16				;��������� �������
;***������� �������� ����������
.org $000
		rjmp INIT			;��������� ������
.org $007
		rjmp T0_OVF			;��������� ������������ ������� T0
;***������������� ��
INIT:	ldi temp,low(RAMEND);���������
		out SPL,temp		; ��������� �����
		ldi temp,high(RAMEND); �� ���������
		out SPH,temp		; ������ ���
		ser temp			;������������� ������� ����� PB
		out DDRB,temp		; �� �����
		clr temp			;������������� ������� ����� PA
		out DDRA,temp		; �� ����
		ldi temp,(1<<PA0)	;��������� ��������������� ���������
		out PORTA,temp		; ����� PA0
		ser temp			;������������� ������� ����� PD
		out DDRD,temp		; �� �����
		out PORTD,temp		;���������� �����������
		ldi temp,(1<<SE)	;���������� ��������
		out MCUCR,temp		; � ����� Idle
		sbi  PORTB, 0
;***��������� ������� �0 �� ����� �������� �������
		ldi temp,0x02		;���������� ���������� ��
		out TIMSK,temp		; ������������ �������
		ldi temp,0x07		;������������ ������� �0
		out TCCR0,temp		; �� �������������� �������� ����������
		sei					;���������� ����������
		ldi temp,0xFC		;$FC=-04 ���
		out TCNT0,temp		; ������� 4-� �������
LOOP:	sbic PINA, 0
		rjmp LOOP
		sbi  PORTB, 0
		cbi  PORTB, 0
		rcall DELAY_FOR_SWITCH
WAIT:	sbis PINA, 0
		rjmp WAIT 
		cbi  PORTB, 0
		sbi  PORTB, 0
		rcall DELAY_FOR_SWITCH
		rjmp LOOP		
;***��������� ���������� ��� ������������ ������� T0
T0_OVF:	clr temp			
		out PORTD,temp		;��������� �����������
		rcall DELAY			;��������
		ser temp			
		out PORTD,temp		;���������� �����������
		ldi temp,0xFC		;$FC=-04 ���
		out TCNT0,temp		; ������� 4-� �������
		reti
;*** �������� ***
DELAY:	ldi r19,6
		ldi r20,255
		ldi r21,255
dd:		dec r21
		brne dd
		dec r20
		brne dd
		dec r19
		brne dd
		ret

DELAY_FOR_SWITCH:	
		ldi r20,255
		ldi r21,255
dd1:	dec r21
		brne dd1
		dec r20
		brne dd1
		ret
