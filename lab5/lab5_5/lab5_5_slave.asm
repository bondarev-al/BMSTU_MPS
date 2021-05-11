;********************************************************************
;��������� 5.2 ��� ������������ ������ ������ SPI 
;���������������� ATx8515 � ������ SLAVE.
;����� ������  ��2 ���������� ����� ��� ������, ������������ � SRAM
;�� ������� �� �������� X.
;�� ��������� ����� ���������� ��� ����������.
;��� ���������������� ������� �� SW5 (SHOW) ���������� ������ ������
;� ����� �� �� ����������.
;����������: SW5-PD5, ������� ���� PC-LED
;********************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		;���� ����������� ATmega8515
.equ DD_MISO = 6		
.def temp = r16				;��������� �������
.def count = r17			;�������
.equ SHOW = 5				;5-� ����� ����� PD

.org $000
	rjmp init
;***������������� ��
INIT:
	ldi temp,low(RAMEND)	;���������
	out SPL,temp			; ��������� �����
	ldi temp,high(RAMEND)	; �� ���������
	out SPH,temp			; ������ ���
	ldi temp,(1<<DD_MISO)
	out DDRB,temp
	ldi temp,0xB0
	out PORTB,temp
	clr temp			;���������
	out DDRD,temp		; ������ ����� PD5
	sbi PORTD,SHOW		; �� ����
	ser temp			;��������� 
	out DDRC,temp		; ������� ����� PC
	out PORTC,temp		; �� �����
	ldi count,0x03		;��������� �������� ������
	ldi XL,0x80			;� �������� X �����, �� ��������
	ldi XH,0x01			; ���������� ������ �������� ������
;***��������� SPI � ������ SLAVE �� ���� ������
	ldi temp,(1<<SPE)
	out SPCR,temp	
INPUT:	sbis SPSR,SPIF	;�������� ����� ������
	rjmp INPUT
	in temp,SPDR		;���� ����� �� ��������
	st X+,temp			;���������� ����� � ������
	dec count			;���������� �������� �� 1
	brne INPUT
	rcall OUTLED		;����� �� ���������
loop: 	rjmp loop
;***����� �� ����������***	
OUTLED:	clr temp		;������������ - 
	out PORTC,temp		; ���� ��������
	ldi XL,0x80			;��������� ���������� ������
	ldi count,3			;��������� �������� ������ 	
WAIT_SHOW:	sbic PIND,SHOW	;�������� �������
	rjmp WAIT_SHOW		; ������ SHOW
	ld temp,X+			;���������� ����� �� ������
	com temp			;�������������� �
	out PORTC,temp		;����� �� ����������
	rcall DELAY			;��������
	dec count			;���� �������� �� ��� ������,
	brne WAIT_SHOW		; ����������� �� ������� SHOW
	ret		
;***��������***
DELAY:	ldi r19,10
	ldi r20,255
	ldi r21,255
dd:	dec r21
	brne dd
	dec r20
	brne dd
	dec r19
	brne dd
	ret	
