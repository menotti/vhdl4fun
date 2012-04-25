// flip-flop d
module dff (d, clk, q);

// inputs d = data, clk = clock
input d, clk;

// outputs
output q;

// variáveis internas
reg q;

// lógica
always @ (posedge clk) begin
  q <= d;
end

endmodule
