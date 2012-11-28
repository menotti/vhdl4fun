import BRAM::*;

interface MaxValue;
    method Bit#(32) pegar_valor();
endinterface

(*synthesize*)
module mkMaxValue(MaxValue);
    BRAM2Port#(Bit#(11), Bit#(32)) ram <- mkBRAM2Server(defaultValue);
    Reg#(Bit#(32)) maior_valor <- mkReg(0);
    Reg#(Bit#(11)) current_addr <- mkReg(0);
    rule consultar_valores (current_addr < maxBound);
        ram.portA.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr, datain: ?});
        ram.portB.request.put(BRAMRequest{write: False, responseOnWrite: False, address: current_addr+1, datain: ?});
        current_addr <= current_addr + 2;
    endrule
    rule pegar_respostas;
        let valor1 <- ram.portA.response.get();
        let valor2 <- ram.portB.response.get();
        let novo_maior_valor = maior_valor;
        if(valor1 > novo_maior_valor)
            novo_maior_valor = valor1;
        if(valor2 > novo_maior_valor)
            novo_maior_valor = valor2;
        maior_valor <= novo_maior_valor;
    endrule
    method Bit#(32) pegar_valor() if (current_addr == maxBound);
        return maior_valor;
    endmethod
endmodule
