;********************************************************************
;Программа 4.1 для МК ATx8515:
;демонстрация работы таймера Т0 в режиме счётчика событий;
;событие - нажатие кнопки SW0.
;Соединения : порт PA0–SW0, порт PD-LED 
;Светодиоды включаются после четвертого нажатия на кнопку SW0
;********************************************************************
;.include "8515def.inc"		;файл определений AT90S8515
.include "m8515def.inc"		;файл определений ATmega8515
.def temp = r16				;временный регистр
;***Таблица векторов прерываний
.org $000
		rjmp INIT			;обработка сброса
.org $007
		rjmp T0_OVF			;обработка переполнения таймера T0
;***Инициализация МК
INIT:	ldi temp,low(RAMEND);установка
		out SPL,temp		; указателя стека
		ldi temp,high(RAMEND); на последнюю
		out SPH,temp		; ячейку ОЗУ
		ser temp			;инициализация выводов порта PB
		out DDRB,temp		; на вывод
		clr temp			;инициализация выводов порта PA
		out DDRA,temp		; на ввод
		ldi temp,(1<<PA0)	;включение ‘подтягивающего’ резистора
		out PORTA,temp		; входа PA0
		ser temp			;инициализация выводов порта PD
		out DDRD,temp		; на вывод
		out PORTD,temp		;выключение светодиодов
		ldi temp,(1<<SE)	;разрешение перехода
		out MCUCR,temp		; в режим Idle
		sbi  PORTB, 0
;***Настройка таймера Т0 на режим счётчика событий
		ldi temp,0x02		;разрешение прерывания по
		out TIMSK,temp		; переполнению таймера
		ldi temp,0x07		;переключение таймера Т0
		out TCCR0,temp		; по положительному перепаду напряжения
		sei					;разрешение прерываний
		ldi temp,0xFC		;$FC=-04 для
		out TCNT0,temp		; отсчёта 4-х нажатий
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
;***Обработка прерывания при переполнении таймера T0
T0_OVF:	clr temp			
		out PORTD,temp		;включение светодиодов
		rcall DELAY			;задержка
		ser temp			
		out PORTD,temp		;выключение светодиодов
		ldi temp,0xFC		;$FC=-04 для
		out TCNT0,temp		; отсчёта 4-х нажатий
		reti
;*** Задержка ***
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
