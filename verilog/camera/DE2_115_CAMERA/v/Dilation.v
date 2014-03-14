/* 
(C) OOMusou 2008 http://oomusou.cnblogs.com

Filename    : Dilation.v
Compiler    : Quartus II 8.0
Description : Demo how to implement Dilation in Verilog
Release     : 09/27/2008 1.0
*/

module Dilation (
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
		X1 <=	0;
		X2 <=	0;
		X3 <=	0;
		X4 <=	0;
		X5 <=	0;
		X6 <=	0;
		X7 <=	0;
		X8 <=	0;
		X9 <=	0;
		oDVAL <= 0;
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
      oDATA <= 0;  
	end
end

endmodule