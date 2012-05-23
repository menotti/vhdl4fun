#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *
from math import sqrt as python_sqrt
 
def sqrt(clk, radical, q):
 
    """ Raiz quadrada
 
    I/O pins:
    --------
    clk     : input clock 
    radical : input dados (32 bits)
    q       : output dados (16 bits)
 
    """    
    r = int(python_sqrt(radical))
    

    @always(clk.posedge)
    def logic(): 
        q.next = r
    return logic


# TESTES

def test_sqrt():
 
    clk = Signal(0)
    q = Signal(intbv(0)[16:])
    radical = Signal(intbv(9)[32:])
    
    sqrt_inst = sqrt(clk, radical, q)
 
    @always(delay(10))
    def clkgen():
        clk.next = not clk
 
    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        raise StopSimulation
    
    return clkgen, sqrt_inst, stimulus

def simulate():
    tb = traceSignals(test_sqrt) 
    sim = Simulation(tb)
    sim.run(1000)
    
simulate()