module Erosion (
  input            iCLK,
  input            iRST_N,
  input            iDVAL,
  input      [9:0] iDATA,
  output reg       oDVAL,
  output reg [9:0] oDATA
);

wire [9:0] Line0;
wire [9:0] Line1;
wire [9:0] Line2;
reg  [9:0] X1, X2, X3, X4, X5, X6, X7, X8, X9;

LineBuffer_dilation b0	(
  .clken(iDVAL),
  .clock(iCLK),
  .shiftin(iDATA),
  .taps0x(Line0),
  .taps1x(Line1),
  .taps2x(Line2)
);

always@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		X1 <=	10'b1111111111;
		X2 <=	10'b1111111111;
		X3 <=	10'b1111111111;
		X4 <=	10'b1111111111;
		X5 <=	10'b1111111111;
		X6 <=	10'b1111111111;
		X7 <=	10'b1111111111;
		X8 <=	10'b1111111111;
		X9 <=	10'b1111111111;
		oDVAL <= 1;
	end
	else begin
	  oDVAL <= iDVAL;
		X9    <= Line0;
		X8    <= X9;
		X7    <= X8;
		X6    <= Line1;
		X5    <= X6;
		X4    <= X5;
		X3    <= Line2;
		X2    <= X3;
		X1    <= X2;
		
    if (iDVAL)
      oDATA <= X9 | X8 | X7 | X6 | X5 | X4 | X3 | X2 | X1;
    else
      oDATA <= 10'b1111111111;  
	end
end

endmodule