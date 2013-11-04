`timescale 10 ns / 10 ps

module t_multiplier;
 
	reg a, b;
	wire prod;
	integer i;

	parameter cycles = 4;

	reg [2:0]data [0:cycles-1];
	
	multiplier DUT (.a(a), .b(b), .prod(prod));
		
	initial
	begin
		data[0] = 3'b000;
		data[1] = 3'b100;
		data[2] = 3'b010;
		data[3] = 3'b111;
	end

	initial
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			a = data[i][2];
			b = data[i][1];
			#1
			if (prod !== data[i][0])
			begin
				$display("erro");
				$finish;
			end
		end
		$finish;
	end

	initial 
	begin
		$dumpfile ("t_multiplier.vcd");
		$dumpvars; 
	end 
endmodule
