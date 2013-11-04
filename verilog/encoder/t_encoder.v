`timescale 10 ns / 10 ps

module t_encoder;
 

	wire [3:0] binary_out ;
	reg  enable ; 
	reg [15:0] encoder_in ; 

	integer i;

	parameter cycles = 16;

	reg [20:0]	data [0:cycles-1];

	encoder DUT (.binary_out(binary_out), .enable(enable), .encoder_in(encoder_in));

	initial
	begin
		data[0] = {4'd0, 1'b0, 16'd1};
		data[1] = {4'd1, 1'b1, 16'd2};
		data[2] = {4'd2, 1'b1, 16'd4};
		data[3] = {4'd3, 1'b1, 16'd8};
		data[4] = {4'd4, 1'b1, 16'd16};
		data[5] = {4'd5, 1'b1, 16'd32};
		data[6] = {4'd6, 1'b1, 16'd64};
		data[7] = {4'd7, 1'b1, 16'd128};
		data[8] = {4'd8, 1'b1, 16'd256};
		data[9] = {4'd9, 1'b1, 16'd512};
		data[10] = {4'd10, 1'b1, 16'd1024};
		data[11] = {4'd11, 1'b1, 16'd2048};
		data[12] = {4'd12, 1'b1, 16'd4096};
		data[13] = {4'd13, 1'b1, 16'd8192};
		data[14] = {4'd14, 1'b1, 16'd16384};
		data[15] = {4'd15, 1'b1, 16'd32768};
	end
	initial
	
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			encoder_in = data[i][15:0];
			enable = data[i][16];
			#1
			if (binary_out !== data[i][20:17])
			begin
				$display("erro");
				$finish;
			end
		end
	end
 
	initial begin
		$dumpfile ("t_encoder.vcd");
		$dumpvars; 
	end 

endmodule 
