#include <avr/io.h>
#define uchar unsigned char
// Определения уровней сигналов бита (х) порта
#define sbit(x,PORT) ((PORT) |= (1<<x))
#define cbit(x,PORT) ((PORT) &= ~(1<<x))
// определения интерфейсных сигналов
// RST,LE,CS,RD,WR
#define srst sbit(0,PORTD)
#define crst cbit(0,PORTD)
#define sle sbit(1,PORTD)
#define cle cbit(1,PORTD)
#define scs sbit(2,PORTD)
#define ccs cbit(2,PORTD)
#define srd sbit(3,PORTD)
#define crd cbit(3,PORTD)
#define swr sbit(4,PORTD)
#define cwr cbit(4,PORTD)
// Вывод адресов/данных, ввод данных
#define out PORTC
#define in PINC

// 'Защёлкивание' адреса в регистре
void latch_it(void)
{ 
	cle;
	asm("nop");
	sle;
	asm("nop");
	cle;
}

int main()
{ 
	uchar temp;
	SPL = 0x54;
	SPH = 0x04;
	// Инициализация порта PD
	DDRD = 0xff;
	// Неактивные входы 8255A
	srd;
	swr;
	scs;
	// Разрешение 8255A и сброс
	ccs;
	srst;
	asm("nop"); asm("nop"); asm("nop");
	crst;
	//
	DDRC=0xff;
	out = 0x03; //адрес регистра управления 8255А
	latch_it();
	out = 0x82;
	cwr;
	asm("nop");
	swr;

	while(1)
	{ //
		DDRC=0xff;
		out = 0x01; //адрес на вывод
		latch_it();
		DDRC = 0; //KEY на ввод
		crd;
		asm("nop");
		temp = in; //данные KEY
		srd;
		//
		DDRC = 0xff;
		out = 0x00; //адрес на вывод
		latch_it();
		out = temp; //данные на LED
		cwr;
		asm("nop");
		swr;
	}
}
