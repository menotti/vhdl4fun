// contador johnson bidirecional de 4 bits 

module jc2 (goLeft, goRight, stop, clk, q);

// inputs
input goLeft, goRight, stop, clk;

// outputs
output [3:0] q;

// variáveis internas
reg [3:0] q;

// lógica
always @(posedge clk)

    if (stop == 1) begin
	// precedência ao lado esquerdo caso ambos estejam ativos
        if (goLeft == 0) begin
            q[4-1:1] <= q[3-1:0];
            q[0] <= (!q[3]);
        end
        else if (goRight == 0) begin
            q[3-1:0] <= q[4-1:1];
            q[3] <= (!q[0]);
        end

    end

endmodule
