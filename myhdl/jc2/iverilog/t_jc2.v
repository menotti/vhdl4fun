`timescale 1ns / 100ps
module t_jc2;

  reg goLeft, goRight, stop, clk;
  wire q;

  initial begin
    clk = 1;
    goLeft = 1;
    goRight = 1;
    stop = 1;
  end

  always
    #10 clk = !clk;

  always @(negedge clk)
    #10 goLeft = !goLeft;

  always @(negedge clk)
    #13 stop = !stop;

  always @(negedge clk)
    #23 goRight = !goRight;

  initial begin
	#1000 $finish;
  end

  initial  begin
    $dumpfile ("t_jc2.vcd"); 
    $dumpvars; 
  end 

endmodule
