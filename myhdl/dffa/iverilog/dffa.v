// flip flop d com entrada reset assíncrona
module dffa (d, clk, q, rst);

// inputs d = data, clk = clock, rst = reset
input d, clk, rst;

// outputs
output q;

// variáveis internas
reg q;

// lógica
always @ ( posedge clk)
if (~rst) begin
  q <= 1'b0;
end else begin
  q <= d;
end

endmodule
