from myhdl import *
# -*- coding: utf-8 -*-

def mul8(x, y, s, clk):
        """ 
        entradas: x, y (operandos)
        saídas: s (resultado) 
        """
        res = x * y
        @always(clk.posedge)
        def logic():
            s.next = res
        return logic
    
def test_mul8():
 
    clock = Signal(0)
    result = Signal(intbv(0)[15:])
    x, y = [Signal(intbv(2)[7:]) for i in range(2)]
    
    mul8_inst = mul8(x, y, result, clock)
 
    @always(delay(10))
    def clkgen():
        clock.next = not clock
 
    @instance
    def stimulus():
        for i in range(3):
            yield clock.negedge
        raise StopSimulation
    
    return clkgen, mul8_inst, stimulus

def simulate():
    tb = traceSignals(test_mul8) 
    sim = Simulation(tb)
    sim.run(1000)
    
#simulate()