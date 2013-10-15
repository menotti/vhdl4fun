`timescale 10 ns / 10 ps

module t_tribonacci; 

	reg clk, rst;
	wire [31:0] s;
	integer i;

	parameter cycles = 150;

	tribonacci DUT (.clk(clk), .rst(rst), .s(s));

	always
	begin
		#1
		clk <= ~clk;
	end

	initial begin
		clk <= 0;
		rst <= 1;
		#1
		rst <= 0;
	end 
	
	initial begin
		$dumpfile ("t_tribonacci.vcd");
		$dumpvars; 
	end 

endmodule 
