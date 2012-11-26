module fibonacci(clk, rst, s);

	input clk, rst;
	output [15:0] s;

	wire clk, rst;
	wire [15:0] s;

	reg [15:0] reg_0;
	reg [15:0] reg_1;

	always @(posedge rst or posedge clk)
	begin
		if (rst == 1)
		begin
			reg_0 <= 16'b0000000000000000;
			reg_1 <= 16'b0000000000000001;
		end
		else
		begin
			reg_0 <= reg_1;
			reg_1 <= reg_0 + reg_1; 
		end
	end

	assign s = reg_0;

endmodule
