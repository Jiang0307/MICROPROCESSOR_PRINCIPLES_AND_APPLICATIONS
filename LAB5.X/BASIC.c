#include "xc.h"

extern unsigned int divide(unsigned int a, unsigned int b);

void main(void) 
{
    volatile unsigned int res = divide(255,13);
    volatile unsigned char quotient = (res/256);
    volatile unsigned char remainder = res;

    while(1){}

    return;
}