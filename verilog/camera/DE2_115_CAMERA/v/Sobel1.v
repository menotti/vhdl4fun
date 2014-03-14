module Sobel1 (
  input         CLOCK,
  input         RESET_N,
  input   [9:0] input_data,
  input         iDVAL,
  input   [7:0] thresh,
  output  [9:0] output_data
);

parameter X1 = 8'b11111111, X2 = 8'b00000000, X3 = 8'b00000001;
parameter X4 = 8'b11111110, X5 = 8'b00000000, X6 = 8'b00000010;
parameter X7 = 8'b11111111, X8 = 8'b00000000, X9 = 8'b00000001;
parameter Y1 = 8'b00000001, Y2 = 8'b00000010, Y3 = 8'b00000001;
parameter Y4 = 8'b00000000, Y5 = 8'b00000000, Y6 = 8'b00000000;
parameter Y7 = 8'b11111111, Y8 = 8'b11111110, Y9 = 8'b11111111;

wire  [7:0] linebuffer0;
wire  [7:0] linebuffer1;
wire  [7:0] linebuffer2;

wire  [17:0]  altmult_add_x0;
wire  [17:0]  altmult_add_x1;
wire  [17:0]  altmult_add_x2;

wire  [17:0]  altmult_add_y0;
wire  [17:0]  altmult_add_y1;
wire  [17:0]  altmult_add_y2;

wire  [19:0]  parallel_add_x;
wire  [19:0]  parallel_add_y;

wire  [15:0]  magnitude;

assign  output_data = (magnitude > thresh) ? 0 : 10'b1111111111;

linebuffer b0 (
  .clken(iDVAL),
  .clock(CLOCK),
  .shiftin(input_data[9:2]),
  .taps0x(linebuffer0),
  .taps1x(linebuffer1),
  .taps2x(linebuffer2)
);

// X
altmult_add_3 x0 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer0),
  .datab_0(X9),
  .datab_1(X8),
  .datab_2(X7),
  .result(altmult_add_x0)
);

altmult_add_3 x1 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer1),
  .datab_0(X6),
  .datab_1(X5),
  .datab_2(X4),
  .result(altmult_add_x1)
);

altmult_add_3 x2 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer2),
  .datab_0(X3),
  .datab_1(X2),
  .datab_2(X1),
  .result(altmult_add_x2)
);

// Y
altmult_add_3 y0 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer0),
  .datab_0(Y9),
  .datab_1(Y8),
  .datab_2(Y7),
  .result(altmult_add_y0)
);

altmult_add_3 y1 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer1),
  .datab_0(Y6),
  .datab_1(Y5),
  .datab_2(Y4),
  .result(altmult_add_y1)
);

altmult_add_3 y2 (
  .aclr0(!RESET_N),
  .clock0(CLOCK),
  .dataa_0(linebuffer2),
  .datab_0(Y3),
  .datab_1(Y2),
  .datab_2(Y1),
  .result(altmult_add_y2)
);

paralleladd parallel_add0 (
  .clock(CLOCK),
  .data0x(altmult_add_x0),
  .data1x(altmult_add_x1),
  .data2x(altmult_add_x2),
  .result(parallel_add_x)
);

paralleladd parallel_add1 (
  .clock(CLOCK),
  .data0x(altmult_add_y0),
  .data1x(altmult_add_y1),
  .data2x(altmult_add_y2),
  .result(parallel_add_y)
);

SQRT sqrt0 (
  .clk(CLOCK),
  .radical(parallel_add_x * parallel_add_x + parallel_add_y * parallel_add_y),
  .q(magnitude)
);

endmodule
