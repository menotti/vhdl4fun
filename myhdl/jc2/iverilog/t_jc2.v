// testbench johnson counter bidirecional 4 bits (verilog)

module t_jc2;

  reg goLeft, goRight, stop, clk;
  wire q;

  initial begin
    clk = 0;
    goLeft = 1;
    goRight = 1;
    stop = 1;
  end

  always
    #5 clk = !clk;

  always
    #7 goLeft = !goLeft;

  always
    #14 goRight = !goRight;

  initial begin
        #80 stop = 0;
	#100 $finish;
  end


  initial  begin
    $dumpfile ("t_jc2.vcd"); 
    $dumpvars; 
  end 

endmodule
