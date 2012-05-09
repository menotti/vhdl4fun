`timescale 1ns / 100ps
module t_jc2;
  reg goLeft, goRight, stop, clk;
  wire [3:0] q;

  jc2 dut(goLeft, goRight, stop, clk, q);

  initial begin
    clk = 1;
    goLeft = 1;
    goRight = 1;
    stop = 1;
  end

  always
    #10 clk = !clk;

  initial begin
	#50 goLeft = 0;
	#20 goLeft = 1;
	#180 stop = 0;
	#20 stop = 1;
	#40 goRight = 0;
	#20 goRight = 1;
  end

  initial begin
	#510 $finish;
  end

  initial  begin
    $dumpfile ("t_jc2.vcd"); 
    $dumpvars; 
  end 

endmodule
