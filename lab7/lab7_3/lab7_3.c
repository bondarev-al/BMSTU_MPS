#include <avr/io.h>
#define uchar unsigned char
// ����������� ������� �������� ���� (�) �����
#define sbit(x,PORT) ((PORT) |= (1<<x))
#define cbit(x,PORT) ((PORT) &= ~(1<<x))
// ����������� ������������ ��������
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
// ����� �������/������, ���� ������
#define out PORTC
#define in PINC

// '������������' ������ � ��������
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
	// ������������� ����� PD
	DDRD = 0xff;
	// ���������� ����� 8255A
	srd;
	swr;
	scs;
	// ���������� 8255A � �����
	ccs;
	srst;
	asm("nop"); asm("nop"); asm("nop");
	crst;
	//
	DDRC=0xff;
	out = 0x03; //����� �������� ���������� 8255�
	latch_it();
	out = 0x82;
	cwr;
	asm("nop");
	swr;

	while(1)
	{ //
		DDRC=0xff;
		out = 0x01; //����� �� �����
		latch_it();
		DDRC = 0; //KEY �� ����
		crd;
		asm("nop");
		temp = in; //������ KEY
		srd;
		//
		DDRC = 0xff;
		out = 0x00; //����� �� �����
		latch_it();
		out = temp; //������ �� LED
		cwr;
		asm("nop");
		swr;
	}
}
