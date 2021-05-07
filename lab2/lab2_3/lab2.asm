;**********************************************************************
;��������� 2.1 ��� ����������� ������������ ����������� (��)
;��� ������� �� ������ START(SW0).
;����� ������� �� ������ STOP (SW2) ������������ ������������ � 
;�������������� � ����� ��������� ��� ��������� ������� �� ������ START
;����������: SW0-PD0, SW2-PD2, LED-PB
;**********************************************************************
;.include "8515def.inc"		;���� ����������� ��� AT90S8515
.include "m8515def.inc"		;���� ����������� ��� ATmega8515
.def temp = r16				;��������� �������
.def status = r21			;������
.def reg_led = r20			;��������� �������� �����������

.org $000
;***������� ����������***
	rjmp INIT				;��������� ������
.org $002
	rjmp START_PRESSED		;��������� �������� ���������� INT1(START)
.org $00D
	rjmp STOP_PRESSED		;��������� �������� ���������� INT2(STOP)
;***������������� ��***
INIT:	ldi reg_led,0xFE
		ldi temp,$5F		;���������
		out SPL,temp		; ��������� �����
		ldi temp,$02		; �� ���������
		out SPH,temp		; ������ ���
		sec					;C=1
		set					;T=1		
		ser temp			;������������� ������� 
		out DDRB,temp		; ����� PB �� �����
		out PORTB,temp		;�������� ��
		clr temp			;������������� 
		out DDRD,temp		; ����� PD �� ����
		ldi temp,0x08		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD
		ldi temp,0x01		;��������� ������������� 
		out PORTE,temp		; ���������� ����� PE
		ldi temp,(1<< INT1 | 1<< INT2)	;����������
		out GIMSK,temp		; ���������� INT1 (6 ��� GIMSK ��� GICR)
		ldi temp,0x08		;��������� ���������� INT1
		out MCUCR,temp		; �� �����
		ldi temp,0x00		;��������� ���������� INT2
		out EMCUCR,temp		; �� �����
		sei					;���������� ����������	

		ldi status, 0x00

WAIT_START:

LOOP:	sbrs status, 0
		rjmp WAIT_START
		out PORTB,reg_led	;��������� ��
		rcall DELAY			;��������
		brts LEFT			;�������, ���� ���� T ����������
		sbrs reg_led,0		;������� ��������� �������,
							; ���� 0-� ������ reg_led ����������
		set					;T=1
		ror reg_led			;����� reg_led ������ �� 1 ������ 
		rjmp LOOP			
LEFT:	sbrs reg_led,7		;������� ��������� �������, 
							;���� 7-� ������ reg_led ����������
		clt					;T=0
		rol reg_led			;����� reg_led ����� �� 1 ������ 	
		rjmp LOOP	
;***��������� ���������� �� ������ START***
START_PRESSED:		
		ldi status, 0x01
		reti
;***��������� ���������� �� ������ STOP***
STOP_PRESSED:				
		ldi status, 0x00	
		reti
;*** �������� ***
DELAY:	ldi r17,250
d1:		ldi r18,200
d2:		ldi r19,2
d3:		dec r19
		brne d3
		dec r18
		brne d2
		dec r17
		brne d1
		ret
