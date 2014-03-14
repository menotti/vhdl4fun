module Ddilation (
	input						CLOCK,
	input						RESET_N,
	input						iDVAL,
	input				[9:0]	input_data,
	output	reg			oDVAL,
	output	reg	[9:0]	output_data
);

wire [9:0] linebuffer0;
wire [9:0] linebuffer1;
wire [9:0] linebuffer2;
reg  [9:0] Pixel_1, Pixel_2, Pixel_3, Pixel_4, Pixel_5, Pixel_6, Pixel_7, Pixel_8, Pixel_9;

linebufferBuffer_erosion b0    (
  .clken(iDVAL),
  .clock(CLOCK),
  .shiftin(input_data),
  .taps0x(linebuffer0),
  .taps1x(linebuffer1),
  .taps2x(linebuffer2)
);

always@(posedge CLOCK, negedge RESET_N) begin
    if(!RESET_N) begin
        Pixel_1 <=    10'b1111111111;
        Pixel_2 <=    10'b1111111111;
        Pixel_3 <=    10'b1111111111;
        Pixel_4 <=    10'b1111111111;
        Pixel_5 <=    10'b1111111111;
        Pixel_6 <=    10'b1111111111;
        Pixel_7 <=    10'b1111111111;
        Pixel_8 <=    10'b1111111111;
        Pixel_9 <=    10'b1111111111;
        oDVAL <= 1'b1;
    end
    else begin    
        Pixel_1    <= Pixel_2;
		Pixel_2    <= Pixel_3;
		Pixel_3    <= linebuffer2;
		Pixel_4    <= Pixel_5;
        Pixel_5    <= Pixel_6;
		Pixel_6    <= linebuffer1;
		Pixel_7    <= Pixel_8;
		Pixel_8    <= Pixel_9;
		Pixel_9    <= linebuffer0;
		oDVAL <= iDVAL;

	  
    if (iDVAL)
        output_data <= (Pixel_9 & Pixel_8 & Pixel_7 & Pixel_6 & Pixel_5 & Pixel_4 & Pixel_3 & Pixel_2 & Pixel_1);
    else
        output_data <= 10'b1111111111;  
    end
end

endmodule
