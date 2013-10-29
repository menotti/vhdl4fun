// sequencial, pois o clock dispara processos do circuito e não todas as entradas...
module tutorial (A, B, Clock, Reset, Sel, AddSub, Z, Overflow);

	parameter n = 16;

	input [n-1:0] A, B;
	input Clock, Reset, Sel, AddSub; 
	
	output [n-1:0] Z;
	output Overflow;

	reg SelR, AddSubR, Overflow;
	reg [n-1:0] Areg, Breg, Zreg; 
	
	wire [n-1:0] G, H, M, Z;
	wire carryout, over_flow;

	// Define combinational logic circuit 
	assign H = Breg ^ {n{AddSubR}}; //xor
	
	mux2to1 multiplexer (Areg, Z, SelR, G);
		defparam multiplexer.k = n;

	adderk nbit_adder (AddSubR, G, H, M, carryout);
		defparam nbit_adder.k = n;

	assign over_flow = carryout ^ G[n-1] ^ H[n-1] ^ M[n-1]; 
	assign Z = Zreg;

	// Define flip-flops and registers 
	always @(posedge Reset or posedge Clock)
	if (Reset == 1) 
	begin
		Areg <= 0; 
		Breg <= 0; 
		Zreg <= 0;
		SelR <= 0; 
		AddSubR <= 0; 
		Overflow <= 0; 
	end
	else 
	begin
		Areg <= A; 
		Breg <= B; 
		Zreg <= M;
		SelR <= Sel; 
		AddSubR <= AddSub; 
		Overflow <= over_flow; 
	end
endmodule





