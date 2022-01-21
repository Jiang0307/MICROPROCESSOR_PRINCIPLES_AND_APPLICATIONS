#ifndef _UART_H
#define _UART_H

void UART_Initialize(void);
void VR_Initialize(void);
void PWM_initialize(void);
char * GetString();
void UART_Write(unsigned char data);
void UART_Write_Text(char* text);
void ClearBuffer();
void MyusartRead();

#endif