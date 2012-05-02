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

  always begin
    #110 goLeft = !goLeft;
    #20 goLeft = !goLeft;
    #200 goRight = !goRight;
    #20 goRight = !goRight;
  end

  initial begin
	#1000 $finish;
  end

  initial  begin
    $dumpfile ("t_jc2.vcd"); 
    $dumpvars; 
  end 

endmodule
