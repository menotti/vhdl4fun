`timescale 1ns / 1ps

module fibonacci(clk, rst, s);

parameter width = 32;

wire [width-1:0] s0, s1, s2, s3;
input clk;
input rst;
output [width-1:0] s;


reg16 #(.width(width))
	regX(
	.clk(clk),
	.rst(rst),
	.d(s1),
	.q(s0));

reg16 #(.rst_value(1), .width(width)) 
	regY(
	.clk(clk),
	.rst(rst),
	.d(s2),
	.q(s1));

reg16 #(.rst_value(1), .width(width)) 
	regZ(
	.clk(clk),
	.rst(rst),
	.d(s3),
	.q(s2));
	
	assign s3 = s2 + s1 + s0;
	assign s = s0;	
endmodule



module reg16(clk, rst, d, q);

	parameter rst_value = 0;
	parameter width = 16;

	input clk, rst;
	input [width-1:0] d;
	output [width-1:0] q;
	reg [width-1:0] q;
	
	always @(posedge clk or posedge rst)
	begin
		if (rst == 1)
			q <= rst_value;
		else
			q <= d;
	end
endmodule
