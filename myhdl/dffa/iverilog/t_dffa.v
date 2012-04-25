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
    #5 clk = !clk;

  always
    #7 d = !d;

  initial begin
        #80 rst = 0;
	#100 $finish;
  end


  initial  begin
    $dumpfile ("t_dffa.vcd"); 
    $dumpvars; 
  end 

endmodule
