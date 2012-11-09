`timescale 10 ns / 10 ps

module t_somador; 

	reg i0, i1, ci;
	wire s, co;
	integer i;

	parameter cycles = 8;

	reg [4:0] data [0:cycles-1];

	somador DUT (.i0(i0), .i1(i1), .ci(ci), .s(s), .co(co));

	initial begin
		data[0] = 5'b00000;
		data[1] = 5'b00110;
		data[2] = 5'b01010;
		data[3] = 5'b01101;
		data[4] = 5'b10010;
		data[5] = 5'b10101;
		data[6] = 5'b11001;
		data[7] = 5'b11111;
	end

	initial begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			i0 = data[i][4];
			i1 = data[i][3];
			ci = data[i][2];
			#1
			if (s !== data[i][1])
			begin
				$display("bad sum value");
				$finish;
			end
			if (co !== data[i][0])
			begin
				$display("carry out value");
				$finish;
			end
		end
		$finish;
	end 
	


	initial begin
		$dumpfile ("t_somador.vcd");
		$dumpvars; 
	end 

endmodule 
