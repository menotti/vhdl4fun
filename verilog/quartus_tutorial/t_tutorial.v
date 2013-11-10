`timescale 10 ns / 10 ps

module t_tutorial;

	parameter n = 16;
	parameter cycles = 8;
	
	integer i;

	reg [n-1:0] A, B; 
	reg Clock, Reset, Sel, Addsub;
	wire [n-1:0] Z;
	wire Overflow;

	reg [3*n+3:0] data [0:cycles-1];

	tutorial DUT (.A(A), .B(B), .Clock(Clock), .Reset(Reset), .Sel(Sel), .AddSub(Addsub), .Z(Z), .Overflow(Overflow));
		defparam DUT.n = n;

	initial 
	begin
		data[0] = {16'd0,16'd0,1'b0,1'b0,1'b1,16'd0,1'b0};
		data[1] = {16'd54,16'd1850,1'b0,1'b0,1'b0,16'd0,1'b0};
		data[2] = {16'd132,16'd63,1'b0,1'b1,1'b0,16'd0,1'b0};
		data[3] = {16'd0,16'd0,1'b0,1'b0,1'b0,16'd69,1'b0};
		data[4] = {16'd750,16'd120,1'b0,1'b1,1'b0,16'd0,1'b0};
		data[5] = {16'd0,16'd7000,1'b1,1'b0,1'b0,16'd630,1'b0};
		data[6] = {16'd0,16'd30000,1'b1,1'b0,1'b0,16'd7630,1'b0};
		data[7] = {16'd0,16'd0,1'b1,1'b0,1'b0,16'd37630,1'b1};
	end 

	initial
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			Clock = 1'b0;
			A = data[i][51:36];
			B = data[i][35:20];
			Sel = data[i][19];
			Addsub = data[i][18];
			Reset = data[i][17];
			#1;
			Clock = ~Clock;
			#1;
			if(Z !== data[i][16:1])
			begin
				$display("saída Z errada");
			end
			if(Overflow !== data[i][0])
			begin
				$display("overflow errado");
			end
		end
	end


endmodule