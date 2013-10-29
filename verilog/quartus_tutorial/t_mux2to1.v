`timescale 10 ns / 10 ps

// k-bit 2-to-1 multiplexer combinational
module t_mux2to1;

	parameter k = 8; 
	parameter cycles = 8;
	
	integer i;

	reg [k-1:0] V, W; 
	reg Sel;
	wire [k-1:0] F; 

	reg [3*k:0] data [0:cycles-1];

	mux2to1 DUT (.V(V), .W(W), .Sel(Sel), .F(F));
		defparam DUT.k = k;

	initial begin
		data[0] = {8'd3,8'd5,1'b0,8'd3};
		data[1] = {8'd3,8'd5,1'b1,8'd5};
		data[2] = {8'd3,8'd7,1'b1,8'd7};
		data[3] = {8'd2,8'd7,1'b1,8'd7};
		data[4] = {8'd2,8'd7,1'b0,8'd2};
		data[5] = {8'd9,8'd1,1'b0,8'd9};
		data[6] = {8'd4,8'd1,1'b0,8'd4};
		data[7] = {8'd6,8'd7,1'b1,8'd7};
	end 

	initial begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			V = data[i][24:17];
			W = data[i][16:9];
			Sel = data[i][8];
			#1;
			if (F !== data[i][7:0])
			begin
				$display("bad F value");

				$finish;
			end
		end
	end
	
	
	initial begin
		$dumpfile ("t_mux2to1.vcd");
		$dumpvars; 
	end 

endmodule




//
//
//module t_somador; 
//
//
//	parameter cycles = 8;
//
//	reg [4:0] data [0:cycles-1];
//
//	somador DUT (.i0(i0), .i1(i1), .ci(ci), .s(s), .co(co));
//
//	initial begin
//		data[0] = 5'b00000;
//		data[1] = 5'b00110;
//		data[2] = 5'b01010;
//		data[3] = 5'b01101;
//		data[4] = 5'b10010;
//		data[5] = 5'b10101;
//		data[6] = 5'b11001;
//		data[7] = 5'b11111;
//	end
//
//	initial begin
//		for (i = 0; i < cycles; i = i + 1)
//		begin
//			i0 = data[i][4];
//			i1 = data[i][3];
//			ci = data[i][2];
//
//			#1
//			if (s !== data[i][1])
//			begin
//				$display("bad sum value");
//
//				$finish;
//			end
//			if (co !== data[i][0])
//			begin
//				$display("carry out value");
//				$finish;
//			end
//		end
//
//		$finish;
//
//	end 
//	
//
//
//	initial begin
//		$dumpfile ("t_somador.vcd");
//		$dumpvars; 
//	end 
//
//endmodule 
