// k-bit 2-to-1 multiplexer combinational
module mux2to1 (V, W, Sel, F);

	parameter k = 8; 

	input [k-1:0] V, W; 
	input Sel;
	output [k-1:0] F; 
	reg [k-1:0] F;

	always @(V or W or Sel) 
		if (Sel==0) 
			F = V; 
		else 
			F = W;
endmodule