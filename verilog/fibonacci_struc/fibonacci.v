`timescale 1ns / 1ps

module fibonacci(clk, rst, s);

wire [15:0] s0, s1, s2;
input clk;
input rst;
output [15:0] s;


reg16 regX(
	.clk(clk),
	.rst(rst),
	.d(s1),
	.q(s0));

reg16 #(.rst_value(1)) 
	regY(
	.clk(clk),
	.rst(rst),
	.d(s2),
	.q(s1));
	
	assign s2 = s1 + s0;
	assign s = s0;	
endmodule



module reg16(clk, rst, d, q);

	parameter rst_value = 0;

	input clk, rst;
	input [15:0] d;
	output [15:0] q;
	reg [15:0] q;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 1)
			q <= rst_value;
		else
			q <= d;
	end
endmodule
