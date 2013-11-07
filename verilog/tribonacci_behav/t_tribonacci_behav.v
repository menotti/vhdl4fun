`timescale 10 ns / 10 ps

module t_tribonacci_behav; 

	reg clk, rst;
	wire [31:0] s;
	integer i;

	parameter cycles = 21;

	tribonacci_behav DUT (.clk(clk), .rst(rst), .s(s));
	
	reg[32:0] data [0:cycles - 1];

	initial
	begin
		data[0] = {1'b1, 32'd0};
		data[1] = {1'b0, 32'd1};
		data[2] = {1'b0, 32'd1};
		data[3] = {1'b0, 32'd2};
		data[4] = {1'b0, 32'd4};
		data[5] = {1'b0, 32'd7};
		data[6] = {1'b0, 32'd13};
		data[7] = {1'b0, 32'd24};	
		data[8] = {1'b0, 32'd44};
		data[9] = {1'b0, 32'd81};
		data[10] = {1'b0, 32'd149};
		data[11] = {1'b0, 32'd274};
		data[12] = {1'b0, 32'd504};
		data[13] = {1'b0, 32'd927};
		data[14] = {1'b0, 32'd1705};
		data[15] = {1'b0, 32'd3136};
		data[16] = {1'b0, 32'd5768};
		data[17] = {1'b0, 32'd10609};
		data[18] = {1'b0, 32'd19513};
		data[19] = {1'b0, 32'd35890};
		data[20] = {1'b0, 32'd66012};
	end
	
	initial
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin	
			rst = data[i][32];
			clk = 1'b1;
			#1
			clk = ~clk;
			#1
			begin
			if (s !== data[i][31:0])
				$display("valor errado");
			end
		end
	end

endmodule 
