`timescale 10 ns / 10 ps

module t_fibonacci; 

	reg clk, rst;
	wire [31:0] s;
	integer i;

	parameter cycles = 150;

	//reg [16:0] data [0:cycles-1];

	fibonacci DUT (.clk(clk), .rst(rst), .s(s));

//	initial begin
//		data[0]  = 17'b10000000000000000;
//		data[1]  = 17'b00000000000000001;
//		data[2]  = 17'b00000000000000001;
//		data[3]  = 17'b00000000000000010;
//		data[4]  = 17'b00000000000000011;
//		data[5]  = 17'b00000000000000101;
//		data[6]  = 17'b00000000000001000;
//		data[7]  = 17'b10000000000001101;
//		data[8]  = 17'b00000000000010101;
//		data[9]  = 17'b00000000000100010;
//		data[10] = 17'b00000000000110111;
//		data[11] = 17'b00000000001011001;
//		data[12] = 17'b00000000010010000;
//		data[13] = 17'b00000000011101001;
//		data[14] = 17'b00000000101111001;
//	end

	always
	begin
		#1
		clk <= ~clk;
	end

	initial begin
		clk <= 0;
		rst <= 1;
		#1
		rst <= 0;
//		for (i = 0; i < cycles; i = i + 1)
//		begin
			//rst = data[i][16];
//			#2
//			if (s !== data[i][15:0])
//			begin
//				$display("bad value");
				//$finish;
//			end
//		end
//		$finish;
	end 
	
	initial begin
		$dumpfile ("t_fibonacci.vcd");
		$dumpvars; 
	end 

endmodule 
