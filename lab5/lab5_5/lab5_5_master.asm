;************************************************************
;��������� 5.1 ��� ������������ ������ ������ SPI 
;����������� ���������������� ATx8515 � ������ MASTER.
;����� ������  ��1 ���������� �������� ��� ������, 
;����������� �� ����� SRAM �� ������� �� �������� Z. 
;����������: PB5��1-PB5��2, PB7��1-PB7��2, PB0��1-PB4��2
;************************************************************
;.include "8515def.inc"		;���� ����������� AT90S8515
.include "m8515def.inc"		���� ����������� ATmega8515
.def temp = r16				;��������� �������
.def count = r17			;�������

.org $000
		rjmp init
;***������������� ��
INIT:	ldi temp,0xB1		;SCK/PB7, MOSI/PB5, 
		out DDRB,temp		; SS/PB4, PB0 ��� ������
		ldi ZL,0x70			;��������
		ldi ZH,0x01			; ������ �
		ldi temp,0x41		; ������
		st Z+,temp			; ������
		ldi temp,0x56		; c ��������������
		st Z+,temp			; ���������
		ldi temp,0x52		; ��������� �
		st Z+,temp			; ���������������
		ldi ZL,0x70
		ldi count,0x03		;��������� �������� �������
;***��������� SPI � ������ MASTER �� �������� ������
		ldi temp,(1<<SPE)|(1<<MSTR)
		out SPCR,temp
OUTPUT:		sbi PORTB,0		;������������ �������
		nop					; �� ������ PB0
		cbi PORTB,0			; �� 1 � 0
		ld temp,Z+			;���������� ����� �� ������
		out SPDR,temp		;����� ����� � ����������
Wait_Transmit:
		sbis SPSR,SPIF		; �������� ����� ��������
		rjmp Wait_Transmit
		dec count			;���������� �������� �� 1
		brne OUTPUT		
loop:	rjmp loop		
