/*Программа 7.1 управляет переключением светодиодов, подключенных к выходам
порта PC.*/
#include <avr/interrupt.h>
#include <avr/io.h>

#define xtal 3686400
#define fled 0.5

unsigned char led_status=0x7f;

ISR(TIMER1_OVF_vect)
{
	TCNT1=0x10000-(xtal/1024/fled);
	led_status>>=1;
	led_status|=0x80;
	if (led_status==0xff) led_status=0x7f;
	PORTC=led_status;
}

int main(void)
{
	DDRC=0xff;
	PORTC=led_status;
	TCCR1A=0;
	TCCR1B=5;
	TCNT1=0x10000-(xtal/1024/fled);
	TIFR=0;
	TIMSK=0x80;
	GICR=0;
	sei();
	while (1);
}
