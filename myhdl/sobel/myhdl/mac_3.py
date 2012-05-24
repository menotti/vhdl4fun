#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *
from pa_3 import Multibit_Adder
from dff import dff
from mul8 import mul8
 
def mac_3(aclr0, clock0, dataa_0, datab_0, datab_1, datab_2, result):
 
    """ Multiplicador 3x8bits
 
    I/O pins:
    --------
    aclr0    : clear
    clock0    : input clock 
    dataa_0    : input linha (8 bits)
    datab_x    : máscaras
    result    : output dados (18 bits)
 
    """    
    
    # saída dos componentes
    s0 = Signal(intbv(0)[15:])
    s1 = Signal(intbv(0)[15:])
    s2 = Signal(intbv(0)[15:])
    
    add0 = Signal(intbv(0)[17:])
    add1 = Signal(intbv(0)[17:])
    
    res = Signal(intbv(0)[17:])
    
    # instanciações
    m0 = mul8(dataa_0, datab_0, s0, clock0)
    m1 = mul8(dataa_0, datab_1, s1, clock0)
    m2 = mul8(dataa_0, datab_2, s2, clock0)
    
    soma0 = Multibit_Adder(s0, s1, add0)
    soma1 = Multibit_Adder(add0, s2, add1)
    
    dResult = dff(res, add1, clock0)

    @always(clock0.posedge, aclr0.negedge)
    def logic(): 
        if aclr0 == 0:
            result.next = 0
        else:
            result.next = res
    return logic, m0, m1, m2, soma0, soma1, dResult


# TESTES

def test_mac3():
 
    clear = Signal(1)
    clk = Signal(0)
    data_a = Signal(intbv(5)[7:])
    data_b0 = Signal(intbv(1)[7:])
    data_b1 = Signal(intbv(0)[7:])
    data_b2 = Signal(intbv(-1)[7:])
    saida = Signal(intbv(0)[17:])

    mac3_inst = mac_3(clear, clk, data_a, data_b0, data_b1, data_b2, saida)    
 
    @always(delay(10))
    def clkgen():
        clk.next = not clk
 
    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        raise StopSimulation
    
    return clkgen, mac3_inst, stimulus 

def simulate():
    tb = traceSignals(test_mac3)
    sim = Simulation(tb)
    sim.run(1000)
    
simulate()