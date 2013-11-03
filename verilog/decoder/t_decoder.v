`timescale 10 ns / 10 ps

module t_decoder;

	reg [3:0] binary_in;
	reg enable;
	
	wire [15:0] decoder_out;
	
	integer i;

	parameter cycles = 16;

	reg [20:0] data [0:cycles-1];

	decoder DUT (.binary_in(binary_in), .enable(enable), .decoder_out(decoder_out));

	initial
	begin
		data[0] = {4'b1111, 1'b0, 16'b0000000000000000};
		data[1] = {4'b0001, 1'b1, 16'b0000000000000010};
		data[2] = {4'b0010, 1'b1, 16'b0000000000000100};
		data[3] = {4'b0011, 1'b1, 16'b0000000000001000};
		data[4] = {4'b0100, 1'b1, 16'b0000000000010000};
		data[5] = {4'b0101, 1'b1, 16'b0000000000100000};
		data[6] = {4'b0110, 1'b1, 16'b0000000001000000};
		data[7] = {4'b0111, 1'b1, 16'b0000000010000000};
		data[8] = {4'b1000, 1'b1, 16'b0000000100000000};
		data[9] = {4'b1001, 1'b1, 16'b0000001000000000};
		data[10] = {4'b1010, 1'b1, 16'b0000010000000000};
		data[11] = {4'b1011, 1'b1, 16'b0000100000000000};
		data[12] = {4'b1100, 1'b1, 16'b0001000000000000};
		data[13] = {4'b1101, 1'b1, 16'b0010000000000000};
		data[14] = {4'b1110, 1'b1, 16'b0100000000000000};
		data[15] = {4'b1111, 1'b1, 16'b100000000000000};
		
	end
	
	initial
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			binary_in = data[i][20:17];
			enable = data[i][16];
			#1
			if (decoder_out !== data[i][15:0])
			begin
				$display("erro");
				$finish;
			end
		end
	end
endmodule 