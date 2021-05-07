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
.def reg_led = r20			;��������� �������� �����������
.equ START = 0				;0-� ������ ����� PD

.org $000
;***������� ����������***
	rjmp INIT				;��������� ������
	rjmp STOP_PRESSED		;��������� �������� ���������� INT0(STOP)	
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
		ldi temp,0x05		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD
		ldi temp,(1<< INT0)	;����������
		out GIMSK,temp		; ���������� INT0 (6 ��� GIMSK ��� GICR)
		ldi temp,0x00		;��������� ���������� INT0 
		out MCUCR,temp		; �� ������� ������
		sei					;���������� ����������	
WAITSTART:	sbic PIND,START	;�������� �������
		rjmp WAITSTART		;  ������ START
LOOP:	out PORTB,reg_led	;��������� ��
		rcall DELAY			;��������
		ser temp			;����������
		out PORTB,temp		; �����������
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
;***��������� ���������� �� ������ STOP***
STOP_PRESSED:
WAITSTART_2:				;��������
		sbic PIND,START		; �������
		rjmp WAITSTART_2	; ������ START
		reti
;*** �������� ***
DELAY:	ldi r17,2
d1:		ldi r18,2
d2:		ldi r19,2
d3:		dec r19
		brne d3
		dec r18
		brne d2
		dec r17
		brne d1
		ret
