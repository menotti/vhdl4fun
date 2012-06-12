#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *

def Sobel(clock, pin, pout, control):
    
    SIZE_X = 800
    SIZE_Y = 600

    r00, r01, r02, r10, r11, r12, r20, r21, r22 = [Signal(intbv(0)[8:]) for i in range(9)]     

    row0 = [Signal(intbv(0)[8:]) for i in range(SIZE_X-3)]
    row1 = [Signal(intbv(0)[8:]) for i in range(SIZE_X-3)]

    H, V, H1, V1 = [Signal(intbv(0)[12:]) for i in range(4)]

    @always(clock.posedge)
    def shift_registers(): 
        if (control):
            r00.next = r01
            r01.next = r02
            r02.next = row0[0]
            
            for i in range(SIZE_X-1-3):
                row0[i].next = row0[i+1]

            row0[SIZE_X-1-3].next = r10
            r10.next = r11
            r11.next = r12
            r12.next = row1[0]

            for i in range(SIZE_X-1-3):
                row1[i].next = row1[i+1]
            
            row1[SIZE_X-1-3].next = r20
            r20.next = r21
            r21.next = r22
            r22.next = pin[10:2]

    @always(clock.posedge)
    def calc():
        H.next = -r00 + r02 - (r10<<1) + (r12<<1) - r20 + r22
        V.next = -r00 - (r01<<1) - r02 + r20 + (r21<<1) + r22
    
        if (H[11]):
            H1.next = -H
        else:
            H1.next = H

        if (V[11]):
            V1.next = -V
        else:
            V1.next = V

    @always(clock.posedge)
    def result():
        if (control):
            pout.next = ( H1 + V1 )
        else:
            pout.next = 0

    return instances()
    
def convert():
    pin, pout = [Signal(intbv(0)[10:]) for i in range(2)]
    clk, ctrl = [Signal(bool(0)) for i in range(2)]
    toVerilog(Sobel, clk, pin, pout, ctrl)
    toVHDL(Sobel, clk, pin, pout, ctrl)
    
#simulate()
convert()
