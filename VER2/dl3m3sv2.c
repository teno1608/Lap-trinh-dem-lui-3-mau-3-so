/*****************************************************
Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

// Declare your global variables here

volatile int d_type=0, donvi, chuc, tram, d_anod=0, cou_dr=0, cou_dg=0, cou_dy=0, i=0;
volatile int cou_r=0, cou_g=0, cou_y=0, cou_1s=0, f_yell=0;
volatile int cou_r_pre=200, cou_g_pre=200, cou_y_pre=10, f_red=0, f_gree=0, kds_cv=0; 
volatile bit f_cv=0, gree=0, yell=0, red=0;    

#define li_r PINB.1
#define li_g PINB.2 

#define leddch PORTC.0
#define ledxch PORTC.1                
#define ledvdv PORTC.2
#define ledxdv PORTC.3
#define ledddv PORTC.4
#define ledxtr PORTC.5
#define leddtr PORTB.5

#include <setup_interupt.c>
#include <segdisplay.c> 
#include <calculate.c>


// Timer 0 overflow interrupt service routine: overflow at 1ms
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x82;
// Place your code here
d_anod++;
dislay7seg();

}

// Timer1 overflow interrupt service routine: overflow at 25ms
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0x9E57 >> 8;
TCNT1L=0x9E57 & 0xff;
// Place your code here

switch (d_type)
            {
            case 1: cou_r++;
                    if ((li_r ==1)&&(li_g ==0)) 
                        { 
                        cou_dr++; d_type=2; 
                        if (kds_cv <=0) cou_r_pre =cou_r/40; 
                        cou_r =0; 
                        }
                    if (cou_dr >=5)
                        {cou_dr =0; f_red =cou_r_pre; }
                    break;
            case 2: cou_g++;
                    if ((li_r ==1)&&(li_g ==1)) 
                        { 
                        cou_dg++; d_type=3; 
                        if (kds_cv <=0) cou_g_pre =cou_g/40; 
                        cou_g =0; 
                        }
                    if (cou_dg >=5)
                        {cou_dg =0; f_gree =cou_g_pre; }
                    break;
            case 3: cou_y++;
                    if ((li_r ==0)&&(li_g ==1)) 
                        { 
                        cou_dy++; d_type=1; 
                        if (kds_cv <=0) cou_y_pre =cou_y/40; 
                        cou_y =0; 
                        }
                    if (cou_dy >=5) 
                        {cou_dy =0; f_yell =cou_y_pre; }
                    break;
            }  

        cou_1s++;

}

// Declare your global variables here

void main(void)
{

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=1 State4=T State3=T State2=T State1=T State0=T 
PORTB=0x20;
DDRB=0x20;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=T State5=1 State4=1 State3=1 State2=1 State1=1 State0=1 
PORTC=0x3F;
DDRC=0x3F;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1 
PORTD=0x00;
DDRD=0xFF;

if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3;

set_interupt01();

while (1)
      {
      // Place your code here
      if(kds_cv <=0) { kds_cv =0; calculate();}
      
      while(1)
        {
        if(kds_cv <=0) { kds_cv =0; calculate();}

        if(kds_cv >1) 
        {
        while(f_cv ==1)
            {
            if ((li_r ==0)|(li_g ==0)) 
                {
                set_interupt01();
                f_cv=0;
                if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3; 
                }
            }
        for(i=0; i <2; i++)
        {
        gree =0; yell =0; red =0;    
        cou_r_pre =f_red;
        cou_g_pre =f_gree;
        cou_y_pre =f_yell;
        while ((gree ==0)&(yell ==0)&(red ==0))
            {
            if (d_type ==1) red =1;
            if (d_type ==2)    gree =1;
            if (d_type ==3) yell =1;
            calculate();                                                                         
            }          
        }
        kds_cv =0;
        }

      }
    }   
 
}