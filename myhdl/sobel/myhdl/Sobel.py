#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *
from pa_3 import PA_3
from LineBuffer_3 import LineBuffer_3
from mac_3 import mac_3
from sqrt import sqrt
 
def Sobel(iDVAL, iCLK, iDATA, iTHRESHOLD, iRST_N, oDATA):
 
    """ Sobel 
 
    I/O pins:
    --------
    iDVAL    : input enable do buffer
    iCLK    : input clock 
    iDATA    : input linha (10 bits)
    iTHRESHOLD    : input threshold (não utilizado)
    iRST_N    : input reset que ativa em baixa
    oDATA    : saída do sobel
 
    """
    
    #x1,x2,x3,x4,x5,x6,x7,x8,x9 = [intbv() for i in range(9)]
    x1 = 0xFF
    x2 = 0x00
    x3 = 0x01
    x4 = 0xFE
    x5 = 0x00
    x6 = 0x02
    x7 = 0xFF
    x8 = 0x00
    x9 = 0x01
    
    #y1,y2,y3,y4,y5,y6,y7,y8,y9 = [intbv() for i in range(9)]
    y1 = 0x01
    y2 = 0x02
    y3 = 0x01
    y4 = 0x00
    y5 = 0x00
    y6 = 0x00
    y7 = 0xFF
    y8 = 0xFE
    y9 = 0xFF
    
    Line0, Line1, Line2 = [Signal(intbv(0)[7:]) for i in range(3)]
    mac_x0, mac_x1, mac_x2, mac_y0, mac_y1, mac_y2 = [Signal(intbv(0)[17:]) for i in range(6)]

    buffer = LineBuffer_3(iDVAL, iCLK, iDATA[9:2], Line0, Line1, Line2)
    
    mx0 = mac_3(iRST_N, iCLK, Line0, x9, x8, x7, mac_x0)
    mx1 = mac_3(iRST_N, iCLK, Line1, x6, x5, x4, mac_x1)
    mx2 = mac_3(iRST_N, iCLK, Line2, x3, x2, x1, mac_x2)
    my0 = mac_3(iRST_N, iCLK, Line0, y9, y8, y7, mac_y0)
    my1 = mac_3(iRST_N, iCLK, Line1, y6, y5, y4, mac_y1)
    my2 = mac_3(iRST_N, iCLK, Line2, y3, y2, y1, mac_y2)
    
    pa_x, pa_y = [Signal(intbv(0)[19:]) for i in range(2)]
    pa0 = PA_3(iCLK, mac_x0, mac_x1, mac_x2, pa_x)
    pa1 = PA_3(iCLK, mac_y0, mac_y1, mac_y2, pa_y)
    
    abs_mag = Signal(intbv(0)[15:])
    sqrt0 = sqrt(iCLK, pa_x * pa_x + pa_y * pa_y, abs_mag)
    
    @always(iCLK.posedge)
    def logic(): 
        if (iDVAL):
            oDATA.next = abs_mag
        else:
            oDATA.next = intbv(0)
    return instances()


# TESTES

#def test_Sobel():
# 
#    clear = Signal(1)
#    clk = Signal(0)
#    data_a = Signal(intbv(5)[7:])
#    data_b0 = Signal(intbv(1)[7:])
#    data_b1 = Signal(intbv(0)[7:])
#    data_b2 = Signal(intbv(-1)[7:])
#    saida = Signal(intbv(0)[17:])
#
#    mac3_inst = mac_3(clear, clk, data_a, data_b0, data_b1, data_b2, saida)    
# 
#    @always(delay(10))
#    def clkgen():
#        clk.next = not clk
# 
#    @instance
#    def stimulus():
#        for i in range(3):
#            yield clk.negedge
#        raise StopSimulation
#    
#    return clkgen, mac3_inst, stimulus 
#
#def simulate():
#    tb = traceSignals(test_mac3)
#    sim = Simulation(tb)
#    sim.run(1000)
#    
#simulate()