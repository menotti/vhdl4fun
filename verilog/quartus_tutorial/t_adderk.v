`timescale 10 ns / 10 ps

module t_adderk;
	parameter k = 8; 
	parameter cycles = 15;

	reg [k-1:0] X, Y;
	reg carryin;
	
	wire [k-1:0] S;
	wire carryout;
	
	integer i;

	reg [3*k+1:0] data [0:cycles-1];

	adderk DUT (.X(X), .Y(Y), .carryin(carryin), .S(S), .carryout(carryout));
		defparam DUT.k = k;

	initial
	begin
		data[0] = {8'd0,8'd0,1'b0,8'd0,1'b0};
		data[1] = {8'd25,8'd25,1'b0,8'd50,1'b0};
		data[2] = {8'd25,8'd25,1'b1,8'd51,1'b0};
		data[3] = {8'd0,8'd25,1'b1,8'd26,1'b0};
		data[4] = {8'd25,8'd0,1'b1,8'd26,1'b0};
		data[5] = {8'd25,8'd0,1'b0,8'd25,1'b0};
		data[6] = {8'd0,8'd25,1'b0,8'd25,1'b0};	
		data[7] = {8'd0,8'd0,1'b1,8'd1,1'b0};	
		data[8] = {8'd255,8'd1,1'b0,8'd0,1'b1};
		data[9] = {8'd255,8'd1,1'b0,8'd0,1'b1};
		data[10] = {8'd255,8'd200,1'b0,8'd199,1'b1};
		data[11] = {8'd255,8'd0,1'b1,8'd0,1'b1};
		data[12] = {8'd0,8'd255,1'b1,8'd0,1'b1};
		data[13] = {8'd255,8'd200,1'b1,8'd200,1'b1};
		data[14] = {8'd200,8'd255,1'b0,8'd199,1'b1};		
	end
	
	initial
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			X = data[i][25:18];
			Y = data[i][17:10];
			carryin  = data[i][9];
			#1;
			if (S !== data[i][8:1])
			begin
				$display("bad sum value");
				$finish;
			end
			if (carryout !== data[i][0])
			begin
				$display("carry out value");
				$finish;
			end
		end
	end
	
endmodule 