// contador johnson bidirecional de 4 bits 

module jc2 (goLeft, goRight, stop, clk, q);

// inputs
input goLeft, goRight, stop, clk;

// outputs
output [3:0] q;

// variáveis internas
reg [3:0] q = 4'b0;
reg [1:0] dir = 2'b0;

parameter stall=0, dirLeft=1, dirRight=2;

// lógica
always @(posedge clk)
	begin
		case (dir)
			dirLeft:
				begin
					q[4-1:1] <= q[3-1:0];
			        q[0] <= (!q[3]);
				end
			dirRight:	
				begin
					q[3-1:0] <= q[4-1:1];
			        q[3] <= (!q[0]);
				end
		endcase
	end

always @(posedge clk)
	begin
		if (stop == 0) begin
			dir = stall;
		end else if (goLeft == 0) begin
			dir = dirLeft;
		end else if (goRight == 0) begin
			dir = dirRight;
		end
	end

endmodule
