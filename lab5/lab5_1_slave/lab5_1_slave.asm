;********************************************************************
;Программа 5.2 для демонстрации работы канала SPI 
;микроконтроллера ATx8515 в режиме SLAVE.
;После сброса  МК2 происходит прием трёх байтов, записываемых в SRAM
;по адресам из регистра X.
;По окончании приёма загораются все светодиоды.
;При последовательном нажатии на SW5 (SHOW) происходит чтение данных
;и вывод их на светодиоды.
;Соединения: SW5-PD5, шлейфом порт PC-LED
;********************************************************************
;.include "8515def.inc"		;файл определений AT90S8515
.include "m8515def.inc"		;файл определений ATmega8515
.equ DD_MISO = 6		
.def temp = r16				;временный регистр
.def count = r17			;счётчик
.equ SHOW = 5				;5-й вывод порта PD

.org $000
	rjmp init
;***Инициализация МК
INIT:
	ldi temp,low(RAMEND)	;установка
	out SPL,temp			; указателя стека
	ldi temp,high(RAMEND)	; на последнюю
	out SPH,temp			; ячейку ОЗУ
	ldi temp,(1<<DD_MISO)
	out DDRB,temp
	ldi temp,0xB0
	out PORTB,temp
	clr temp			;настройка
	out DDRD,temp		; вывода порта PD5
	sbi PORTD,SHOW		; на ввод
	ser temp			;настройка 
	out DDRC,temp		; выводов порта PC
	out PORTC,temp		; на вывод
	ldi count,0x03		;установка счётчика байтов
	ldi XL,0x80			;в регистре X адрес, по которому
	ldi XH,0x01			; происходит запись принятых данных
;***Настройка SPI в режиме SLAVE на приём данных
	ldi temp,(1<<SPE)
	out SPCR,temp	
INPUT:	sbis SPSR,SPIF	;проверка флага приема
	rjmp INPUT
	in temp,SPDR		;ввод байта из приёмника
	st X+,temp			;сохранение байта в памяти
	dec count			;уменьшение счётчика на 1
	brne INPUT
	rcall OUTLED		;вывод на индикацию
loop: 	rjmp loop
;***Вывод на индикаторы***	
OUTLED:	clr temp		;сигнализация - 
	out PORTC,temp		; приём завершен
	ldi XL,0x80			;установка начального адреса
	ldi count,3			;установка счётчика байтов 	
WAIT_SHOW:	sbic PIND,SHOW	;ожидание нажатия
	rjmp WAIT_SHOW		; кнопки SHOW
	ld temp,X+			;считывание байта из памяти
	com temp			;инвертирование и
	out PORTC,temp		;вывод на светодиоды
	rcall DELAY			;задержка
	dec count			;если показаны не все данные,
	brne WAIT_SHOW		; продолжение по нажатию SHOW
	ret		
;***Задержка***
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
