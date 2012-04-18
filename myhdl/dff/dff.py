#!/usr/bin/env python

from myhdl import *
from random import randrange

def dff(q, d, clk):
 
    @always(clk.posedge)
    def logic():
        q.next = d
    return logic

def t_dff():
 
    q, d, clk = [Signal(bool(0)) for i in range(3)]
 
    dff_inst = dff(q, d, clk)
 
    @always(delay(10))
    def clkgen():
        clk.next = not clk
 
    @always(clk.negedge)
    def stimulus():
        d.next = randrange(2)
 
    return dff_inst, clkgen, stimulus
 
def simulate(timesteps):
    tb = traceSignals(t_dff)
    sim = Simulation(tb)
    sim.run(timesteps)

def convert():
    q, d, clk = [Signal(bool(0)) for i in range(3)]
    toVerilog(dff, q, d, clk)
    toVHDL(dff, q, d, clk)
 
simulate(2000)
convert() 
