;**********************************************************************
;Программа 6.2 для МК ATx8515: демонстрация работы канала UART
;в режиме приема трёх байтовбез проверки флаговошибки приема.
;При частоте тактового генератора 3,69 МГц, 
;при UBRR=11 скорость обмена 19219 бод.
;Соединения: шлейфом порт PB-LED, PD5-SW5, PD0-RXD (PD1-TXD)
;**********************************************************************
;.include "8515def.inc"			;файл определений AT90S8515
.include "m8515def.inc"		;файл определений ATmega8515
.def temp = r16					;временный регистр
.def count = r17				;счётчик
.equ SHOW = 5					;кнопка просмотра на 5-й вывод порта PD

.org $000
		rjmp init
;***Инициализация МК
INIT:	ldi temp,low(RAMEND)	;установка
		out SPL,temp			; указателя стека
		ldi temp,high(RAMEND)	; на последнюю
		out SPH,temp			; ячейку ОЗУ
		ldi YL,0x80				;в регистре Y - адрес, по которому
		ldi YH,0x01				; происходит запись принятых данных
		ldi count,11			;установка счётчика байтов
		ser temp				;настройка 
		out DDRB,temp			; порта PB на вывод
		out PORTB,temp			; и выключение светодиодов
		clr temp				
		out DDRD,temp			;настройка 
		ldi temp,(1<<PD5)		; вывода PD5 
		out PORTD,temp			; на ввод  
;***Настройка UART на приём данных
	;///  для ATmega8515 регистр UCSRB вместо UCR, UBRRL
		ldi temp,(1<<RXEN)		;разрешение приёма
		out UCSRB,temp			; по каналу UART
		ldi temp,11				;скорость приёма/передачи
		out UBRRL,temp			; 19219 бод
	;///  для ATmega8515 регистр UCSRA вместо USR
WAIT_RXC:	sbis UCSRA,RXC	;ожидание
		rjmp WAIT_RXC		; завершения приёма
		in temp,UDR			;ввод байта из приёмника
		st Y+,temp			; и сохранение в памяти
		dec count			;уменьшение счётчика на 1
		brne WAIT_RXC		;продолжение приема
		clr temp			;сигнализация – 
		out PORTB,temp		; приём завершен
LOOP:	ldi YL,0x80			;восстанавливаем начальный адрес
		ldi count,11		;установка счётчика байтов 
WAIT_SHOW:	sbic PIND,SHOW	;ожидание нажатия
		rjmp WAIT_SHOW		; кнопки SW5
		ld temp, Y+			;считывание байта из памяти
		com temp			;инвертирование 
		out PORTB,temp		;вывод на светодиоды
		rcall DELAY			;задержка
		dec count			;если показаны не все данные,
		brne WAIT_SHOW		; то продолжение при нажатии SW5
		ser temp			;вывод окончен
		out PORTB,temp		;светодиоды погашены
		rjmp LOOP			;повторение вывода
;*** Задержка ***
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
