module tribonacci_behav(clk, rst, s);

	input clk, rst;
	output [31:0] s;

	reg [31:0] reg_0;
	reg [31:0] reg_1;
	reg [31:0] reg_2;


	always @(posedge rst or posedge clk)
	begin
		if (rst == 1)
		begin
			reg_0 <= 32'b00000000000000000000000000000000;
			reg_1 <= 32'b00000000000000000000000000000001;
			reg_2 <= 32'b00000000000000000000000000000001;
		end
		else
		begin
			reg_0 <= reg_1;
			reg_1 <= reg_2;
			reg_2 <= reg_2 + reg_1 + reg_0;			
			
		end
	end

	assign s = reg_0;

endmodule
