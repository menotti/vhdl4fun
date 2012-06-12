`timescale 1ns/1ns
			  
module Sobel( 
                    clock,// master clock
					 pin,  // pixel in, synchronous with the clock
					 pout,  // pixel out
					 control
				);
				
// Define the image size:				
parameter SIZE_X = 800,
         SIZE_Y = 600; 

input clock, control;
input  [9:0] pin;
output [9:0] pout;	
reg    [9:0] pout;			

// the 9 registers that hold the sliding pixel window:
reg [7:0] r00, r01, r02, 
         r10, r11, r12,
         r20, r21, r22;

// The two row shift registers:
reg [7:0] row0[0:SIZE_X-1-3],
		  row1[0:SIZE_X-1-3];

// intermediate registers to compute the result of the H and V filter:
reg [11:0] H, V;

// intermediate registers to compute the abs of H and V:
reg [11:0] H1, V1;

// iteration variable
integer i;
		  
// build a long shift-register with the top row of the sliding window,
// all the pixels up to the second row of the window, the second row of the window,
// the pixels up to the thrid row of the window and finaly the last row of the sliding window:
// r00-r01-r02-######row0######-r10-r11-r12-######row1######-r20-r21-r22
//
// for each new pixel, shift left the whole SR and input the new pixel into register r22:
always @(posedge clock)
begin

if (control) begin

	 r00 <= r01;
	 r01 <= r02;
	 r02 <= row0[0];

	 // note these loops are always unrolled before RTL synthesis:
	 for(i=0; i<SIZE_X-1-3; i=i+1)
		row0[i] <= row0[i+1];
		
	 row0[SIZE_X-1-3] <= r10;
	 r10 <= r11;
	 r11 <= r12;
	 r12 <= row1[0];

	 for(i=0; i<SIZE_X-1-3; i=i+1)
		row1[i] <= row1[i+1];
		
	 row1[SIZE_X-1-3] <= r20;
	 r20 <= r21;
	 r21 <= r22;
	 r22 <= pin[9:2];  
end
end
// The set of 9 registers rij contain a 3x3 pixel window of the input image.
// this block computes the H and V filters for the Sobel algorithm:
// H window coefficients:       V window coefficients:
//     -1 0 1                       -1 -2 -1
//     -2 0 2                        0  0  0
//     -1 0 1                        1  2  1
// 
// for each new pixel (i,j) loaded into r22 this computes the central pixel of the current window
// in position (i-1, j-1), thus with a latency equal to SIZE_X+1; 
// the pipelined datapath adds more 3 clocks:
always @(posedge clock)
begin
 // H and V must be 12 bit long (range of H or V result is [-2040,+2040])
 H <= -r00 + r02 - (r10<<1) + (r12<<1) - r20 + r22;
 V <= -r00 - (r01<<1) - r02 + r20 + (r21<<1) + r22;

 // ABS of H and V into H1 and V1:
 if ( H[11] ) // if negative, change sign
   H1 <= -H;
 else
   H1 <= H;

 if ( V[11] ) // if negative, change sign
   V1 <= -V;
 else
   V1 <= V;

end

always@(posedge clock) begin
    if (control)
	 // pixel out: add H and V (unsigned) and reduce to 8 bits:	
		pout <= (H1 + V1);
    else
      pout <= 0;
end

endmodule


