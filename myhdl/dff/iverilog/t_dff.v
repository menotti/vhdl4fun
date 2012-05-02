`timescale 1ns / 100ps
module t_dff;
  reg d, clk;
  wire q;

  dff dut (d, clk, q);

  initial begin
    clk = 0;
    d = 0;
  end

  always
    #10 clk = !clk;

  always @(negedge clk)
    d = !d;

  initial begin
	#1000 $finish;
  end


  initial  begin
    $dumpfile ("t_dff.vcd"); 
    $dumpvars; 
  end 

endmodule
