//  combinational adder
module adderk (carryin, X, Y, S, carryout);
	parameter k = 8;
	
	input [k-1:0] X, Y; 
	input carryin;
	
	output [k-1:0] S; 
	output carryout; 
	
	reg [k-1:0] S;
	reg carryout;
	
	// saida depende da combinacao de entradas
	always @(X or Y or carryin) 
		{carryout, S} = X + Y + carryin;
endmodule