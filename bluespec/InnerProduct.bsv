import BRAM::*;

interface InnerProduct;
    method Bit#(32) pegar_valor();
endinterface

(*synthesize*)
module mkInnerProduct(InnerProduct);
    BRAM2Port#(Bit#(11), Bit#(32)) ramA <- mkBRAM2Server(defaultValue);
    BRAM2Port#(Bit#(11), Bit#(32)) ramB <- mkBRAM2Server(defaultValue);
    Reg#(Bit#(32)) valor <- mkReg(0);
    Reg#(Bit#(11)) current_addr <- mkReg(0);
    rule consultar_valores (current_addr < maxBound);
        ramA.portA.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr, datain: ?});
        ramA.portB.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr+1, datain: ?});
        ramB.portA.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr, datain: ?});
        ramB.portB.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr+1, datain: ?});
        current_addr <= current_addr + 2;
    endrule
    rule pegar_respostas;
        let valor1A <- ramA.portA.response.get();
        let valor2A <- ramA.portB.response.get();
        let valor1B <- ramB.portA.response.get();
        let valor2B <- ramB.portB.response.get();
        valor <= valor + (valor1A*valor1B + valor2A*valor2B);
    endrule
    method Bit#(32) pegar_valor() if (current_addr == maxBound);
        return valor;
    endmethod
endmodule
