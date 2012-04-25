module t_dff;
  reg d, clk;
  wire q;

  dff dut (d, clk, q);

  initial begin
    clk = 0;
    d = 0;
  end

  always
    #5 clk = !clk;

  always
    #7 d = !d;

  initial begin
	#100 $finish;
  end


  initial  begin
    $dumpfile ("t_dff.vcd"); 
    $dumpvars; 
  end 

endmodule
