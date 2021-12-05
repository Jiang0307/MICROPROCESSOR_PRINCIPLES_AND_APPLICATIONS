#include "xc.h"

extern unsigned char mysqrt(unsigned int a);

void main(void) 
{
    //volatile unsigned char sqrt_0 = mysqrt(0);
    //volatile unsigned char sqrt_10 = mysqrt(10);
    //volatile unsigned char sqrt_15 = mysqrt(15);
    //volatile unsigned char sqrt_400 = mysqrt(400);
    //volatile unsigned char sqrt_800 = mysqrt(800);
    //volatile unsigned char sqrt_1300 = mysqrt(1300);
    //volatile unsigned char sqrt_1600 = mysqrt(1600);
    volatile unsigned char sqrt_ = mysqrt(48);
    while(1){}
    
    return;
}