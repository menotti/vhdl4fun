
// Copyright (c) 2000-2009 Bluespec, Inc.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// $Revision: 17872 $
// $Date: 2009-09-18 14:32:56 +0000 (Fri, 18 Sep 2009) $

`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

// Bluespec primitive module which allows creation of clocks
// with non-constant periods.  The CLK_IN and COND_IN inputs
// are registered and used to compute the CLK_OUT and
// CLK_GATE_OUT outputs.
module MakeClock ( CLK, RST_N,
                   CLK_IN, CLK_IN_EN,
                   COND_IN, COND_IN_EN,
                   CLK_VAL_OUT, COND_OUT,
                   CLK_OUT, CLK_GATE_OUT );

   parameter initVal = 0;
   parameter initGate = 1;

   input  CLK;
   input  RST_N;

   input  CLK_IN;
   input  CLK_IN_EN;
   input  COND_IN;
   input  COND_IN_EN;

   output CLK_VAL_OUT;
   output COND_OUT;
   output CLK_OUT;
   output CLK_GATE_OUT;
   
   reg current_clk;
   reg current_gate;
   reg new_gate;
   
   always @(posedge CLK or negedge RST_N)
   begin
     if (RST_N == 0)
     begin
       current_clk <= initVal;
       new_gate    <= initGate;
     end
     else
     begin
       if (CLK_IN_EN)
         current_clk <= CLK_IN;
       if (COND_IN_EN)
         new_gate <= COND_IN;
     end
   end


   // Use latch to avoid glitches
   // Gate can only change when clock is low
   always @( CLK_OUT or new_gate )
     begin
        if (CLK_OUT == 0)
          current_gate <= `BSV_ASSIGNMENT_DELAY new_gate ;
     end

   assign CLK_OUT      = current_clk & current_gate;
   assign CLK_GATE_OUT = current_gate;
   assign CLK_VAL_OUT  = current_clk;
   assign COND_OUT     = new_gate;
   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      #0 ;
      current_clk  = 1'b0 ;
      current_gate = 1'b1 ;
      new_gate     = 1'b1 ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS
   
endmodule
   
   
