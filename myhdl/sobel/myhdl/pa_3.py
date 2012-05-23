#!/usr/bin/env python
# -*- coding: utf-8 -*-

from myhdl import *
 
def PA_3(clock, data0x, data1x, data2x, result):
 
    """ Somador paralelo para 3 entradas de 18 bits
 
    I/O pins:
    --------
    clock     : input clock 
    dataxx    : input dados
    result    : output de 20 bits
 
    """
 
    def Half_adder(x, y, q, c):
        """ 
        entradas: x, y
        saídas: q (soma), c (carry) 
        """
        @always_comb
        def logic():
            q.next = x ^ y
            c.next = x & y
        return logic
    
    def Full_Adder(x, y, c_in, q, c_out):
        """ 
        entradas: x, y, c_in (carry in) 
        saídas: q (soma), c_out (carry out) 
        """
        q_ha1, c_ha1, c_ha2 = [Signal(bool()) for i in range(3)]
        ha1 = Half_adder(x=c_in, y=x, q=q_ha1, c=c_ha1)
        ha2 = Half_adder(x=q_ha1, y=y, q=q, c=c_ha2)
        
        @always_comb
        def logic():
            c_out.next = c_ha1 | c_ha2    
        return ha1, ha2, logic

    def Multibit_Adder(a, b, s):
        """
        somador para número 's' de bits
        """
        N = len(s)-1
        # al e bl = listas de entradas
        al = [a(i) for i in range(N)]
        bl = [b(i) for i in range(N)]
        # cl = lista de carry e sl = lista de saídas
        cl = [Signal(bool()) for i in range(N+1)]
        sl = [Signal(bool()) for i in range(N+1)]
        # configura o primeiro carry para 0 e a última saída para o valor do carry
        cl[0] = 0
        sl[N] = cl[N]
        # sc = "registrador" para a saída
        sc = ConcatSignal(*reversed(sl))
     
        # atribui a próxima saída
        @always_comb
        def assign():
            s.next = sc
     
        # cria uma lista de somadores
        add = [None] * N
        for i in range(N):
            add[i] = Full_Adder(x=al[i], y=bl[i], q=sl[i], c_in=cl[i], c_out=cl[i+1])
     
        return add, assign
    
    
    s_0 = Signal(intbv(0)[19:])
    s_1 = Signal(intbv(0)[19:]) 
    m0 = Multibit_Adder(data0x, data1x, s_0)
    m1 = Multibit_Adder(s_0, data2x, s_1)
    
    @always(clock.posedge)
    def logic():
        """
        somador paralelo 3x18
        """ 
        result.next = s_1
    return m0, m1, logic


# TESTES

def test_PA3():
 
    clock = Signal(0)
    result = Signal(intbv(0)[20:])
    data0x, data1x, data2x = [Signal(intbv(5)[18:]) for i in range(3)]
    
    pa3_inst = PA_3(clock, data0x, data1x, data2x, result)
 
    @always(delay(10))
    def clkgen():
        clock.next = not clock
 
    @instance
    def stimulus():
        for i in range(3):
            yield clock.negedge
        raise StopSimulation
    
    return clkgen, pa3_inst, stimulus

def simulate():
    tb = traceSignals(test_PA3) 
    sim = Simulation(tb)
    sim.run(1000)
    
simulate()
