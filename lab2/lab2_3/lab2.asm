;**********************************************************************
;Программа 2.1 для поочерёдного переключения светодиодов (СД)
;при нажатии на кнопку START(SW0).
;После нажатия на кнопку STOP (SW2) переключение прекращается и 
;возобновляется с места остановки при повторном нажатии на кнопку START
;Соединения: SW0-PD0, SW2-PD2, LED-PB
;**********************************************************************
;.include "8515def.inc"		;файл определений для AT90S8515
.include "m8515def.inc"		;файл определений для ATmega8515
.def temp = r16				;временный регистр
.def status = r21			;статус
.def reg_led = r20			;состояние регистра светодиодов

.org $000
;***Векторы прерываний***
	rjmp INIT				;обработка сброса
.org $002
	rjmp START_PRESSED		;обработка внешнего прерывания INT1(START)
.org $00D
	rjmp STOP_PRESSED		;обработка внешнего прерывания INT2(STOP)
;***Инициализация МК***
INIT:	ldi reg_led,0xFE
		ldi temp,$5F		;установка
		out SPL,temp		; указателя стека
		ldi temp,$02		; на последнюю
		out SPH,temp		; ячейку ОЗУ
		sec					;C=1
		set					;T=1		
		ser temp			;инициализация выводов 
		out DDRB,temp		; порта PB на вывод
		out PORTB,temp		;погасить СД
		clr temp			;инициализация 
		out DDRD,temp		; порта PD на ввод
		ldi temp,0x08		;включение подтягивающих 
		out PORTD,temp		; резисторов порта PD
		ldi temp,0x01		;включение подтягивающих 
		out PORTE,temp		; резисторов порта PE
		ldi temp,(1<< INT1 | 1<< INT2)	;разрешение
		out GIMSK,temp		; прерывания INT1 (6 бит GIMSK или GICR)
		ldi temp,0x08		;обработка прерывания INT1
		out MCUCR,temp		; по спаду
		ldi temp,0x00		;обработка прерывания INT2
		out EMCUCR,temp		; по спаду
		sei					;разрешение прерываний	

		ldi status, 0x00

WAIT_START:

LOOP:	sbrs status, 0
		rjmp WAIT_START
		out PORTB,reg_led	;включение СД
		rcall DELAY			;задержка
		brts LEFT			;переход, если флаг T установлен
		sbrs reg_led,0		;пропуск следующей команды,
							; если 0-й разряд reg_led установлен
		set					;T=1
		ror reg_led			;сдвиг reg_led вправо на 1 разряд 
		rjmp LOOP			
LEFT:	sbrs reg_led,7		;пропуск следующей команды, 
							;если 7-й разряд reg_led установлен
		clt					;T=0
		rol reg_led			;сдвиг reg_led влево на 1 разряд 	
		rjmp LOOP	
;***Обработка прерывания от кнопки START***
START_PRESSED:		
		ldi status, 0x01
		reti
;***Обработка прерывания от кнопки STOP***
STOP_PRESSED:				
		ldi status, 0x00	
		reti
;*** Задержка ***
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
