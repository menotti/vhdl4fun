/* contador parametrizado do tutorial modificado para 16 bits e contando de 10 em 10 para trás */

`timescale 1ns / 1ns
module counter_16 (count, clk, reset);
	parameter bits = 16;
	
	input clk, reset;
	output [bits-1:0] count;
	
	counter_8 contador (count, clk, reset);
		defparam contador.bits = bits;
endmodule


module counter_8 (count, clk, reset);
	parameter bits = 8;
	output [bits-1:0] count;
	input clk, reset;

	reg [bits-1:0] count;
	parameter tpd_reset_to_count = 3;
	parameter tpd_clk_to_count   = 2;

	function [bits-1:0] increment;
		input [bits-1:0] val;
		reg [3:0] i;
		reg carry;
		begin
			increment = val;
			carry = 1'b1;
    /* 
     * Exit this loop when carry == zero, OR all bits processed 
     */ 
			for (i = 4'b0; ((carry == 4'b1) && (i <= 7));  i = i+ 4'b1)
			begin
				increment[i] = val[i] ^ carry;
				carry = val[i] & carry;
			end
		end       
	endfunction

always @ (posedge clk or posedge reset)
  if (reset)
     count = 8'd0;
  else
     count <= count - 8'd10;

endmodule
