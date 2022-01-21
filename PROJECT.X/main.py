from time import *
from tkinter import S
import serial
from os import system, name

s = serial.Serial(port="COM6", baudrate=600)
count_VOLUME = 0
count_NONE = 0
count_time = 0


def clear():
    if name == 'nt':
        _ = system('cls')
    else:
        _ = system('clear')

def printline(str):
    str = f'{str}\r\n'
    s.write(str.encode('ascii', 'strict'))
    clear()
    s.flush()
    clear()   
    sleep(0.001)
    clear()

while 1:
    if s.in_waiting > 0:
        string = s.readline().decode().rstrip("\r\n")
        string.replace('\r','\0')
        string.replace('\n','\0')
        if(string == "SYNC"):
            cur_time = int(time())
            printline(cur_time)
            print(string,end='\n')
            clear()
            count_time = 0
        elif(string == "NONE"):
            clear()
            print(string,end='\n')
            count_time = 0
        elif(string == "VOLUME"):
            clear()
            print(string)
            continue
            count_time = 0
        else:
            if(count_time == 0):
                clear()
            print(string,end='\r')
            count_time += 1