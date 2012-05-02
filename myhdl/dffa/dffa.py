#!/usr/bin/env python

from myhdl import *
from random import randrange

def dffa(q, d, clk, rst):
 
    @always(clk.posedge, rst.negedge)
    def logic():
	if rst == 0:
	    q.next = 0
	else:
	    q.next = d
    return logic

def tb_dffa():
 
    q, d, clk = [Signal(bool(0)) for i in range(3)]
    rst = Signal(bool(1))
 
    dffa_inst = dffa(q, d, clk, rst)
 
    @always(delay(10))
    def clkgen():
        clk.next = not clk
 
    @always(clk.negedge)
    def stimulus():
        d.next = not d;

    @instance
    def rstgen():
        yield delay(800)
        rst.next = 0;

    return dffa_inst, clkgen, stimulus, rstgen
 
def simulate(timesteps):
    tb = traceSignals(tb_dffa)
    sim = Simulation(tb)
    sim.run(timesteps)

def convert():
    q, d, clk, rst = [Signal(bool(0)) for i in range(4)]
    toVerilog(dffa, q, d, clk, rst)
    toVHDL(dffa, q, d, clk, rst)
 
simulate(1000)
convert() 
