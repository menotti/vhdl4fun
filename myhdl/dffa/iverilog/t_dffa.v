`timescale 1ns / 100ps
module t_dffa;
  reg d, clk, rst;
  wire q;

  dffa dut (d, clk, q, rst);

  initial begin
    clk = 0;
    d = 0;
    rst = 1;
  end

  always
    #10 clk = !clk;

  always @(negedge clk)
    d = !d;

  initial begin
        #800 rst = 0;
  end

  initial begin
	#0 force q = 0; // garante um valor inicial para a saída
        #10 release q;
	#1000 $finish;
  end

  initial  begin
    $dumpfile ("t_dffa.vcd"); 
    $dumpvars; 
  end 

endmodule
