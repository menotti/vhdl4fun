#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *
 
def LineBuffer_3(clken, clock, shiftin, taps0x, taps1x, taps2x):
 
    """ Multiplicador 3x8bits
 
    I/O pins:
    --------
    aclr0    : clear
    clocken    : input clock enable
    clock    : input clock 
    shiftin  : input linha (8 bits)
    shiftin  : output linha (8 bits)
    taps    : output buffer (8 bits)
 
    """    
    
    reg = Signal(intbv()[23:])
    
    @always(clock.posedge)
    def logic():
        reg.next[23:16] = reg[15:8]
        reg.next[15:8] = reg[7:]
        reg.next[7:] = shiftin
    
    @always_comb
    def dump():
        if (clken):
            taps0x.next = reg[23:16]
            taps1x.next = reg[15:8]
            taps2x.next = reg[7:]
    
    return instances()


# TESTES

def test_LineBuffer_3():
 
    clk = Signal(0)
    clken = Signal(1)
    shiftin = Signal(intbv(1)[7:])
    
    taps0x, taps1x, taps2x = [Signal(intbv(0)[7:]) for i in range(3)]

    LineBuffer_3_inst = LineBuffer_3(clken, clk, shiftin, taps0x, taps1x, taps2x)    
 
    @always(delay(10))
    def clkgen():
        clk.next = not clk
 
    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        raise StopSimulation
    
    return instances() 

def simulate():
    tb = traceSignals(test_LineBuffer_3)
    sim = Simulation(tb)
    sim.run(1000)
    
simulate()