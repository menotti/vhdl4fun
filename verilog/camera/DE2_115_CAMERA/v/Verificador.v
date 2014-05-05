module Verificador(
			Clk,
			Rst,
			morfologico,
			padrao,
			H_Cont,
			V_Cont,
			V_SYNC_TOTAL,
			x1,
			x2,
			y1,
			y2,
			ativo
			);
			
			
input		[12:0]		H_Cont;
input		[12:0]		V_Cont, V_SYNC_TOTAL;
reg [10:0] OkLinha, LinhaCheck, OkLinha2, LinhaCheck2;
reg [10:0] contadorBranco, contadorBranco2;
reg achou, achou2;
input [9:0] morfologico;
input Clk, Rst, padrao;


output reg [12:0] x1, x2, y1, y2;
output reg ativo;

reg [12:0] x1_achou, x2_achou, y1_achou, y2_achou, x1_achou2, x2_achou2, y1_achou2, y2_achou2;
reg [12:0] x1_search, x2_search,x1_search2, x2_search2;

always@(posedge Clk or negedge Rst) begin
		if (!Rst)	begin
				achou <= 1'b0;
				contadorBranco <= 0;
				x1_search <= 0;
				x2_search <= 250;
				OkLinha <= 0;
				LinhaCheck <= 0;
				achou2 <= 1'b0;
				contadorBranco2 <= 0;
				x1_search2 <= 800;
				x2_search2 <= 550;
				OkLinha2 <= 0;
				LinhaCheck2 <= 0;
				ativo = 1'b0;
		end
		else
			begin
				if(padrao == 1'b1 && achou == 1'b0 && achou2 == 1'b0) begin
					if(LinhaCheck == 75)begin
						OkLinha <= 0;
						LinhaCheck <= 0;
					end
					if(LinhaCheck2 == 75) begin
						OkLinha2 <= 0;
						LinhaCheck2 <= 0;
					end				
					if(H_Cont == x2_search)
						LinhaCheck <= LinhaCheck + 1;
					if(H_Cont == x1_search2)
						LinhaCheck2 <= LinhaCheck2 + 1;
					if(H_Cont >= x1_search && H_Cont <= x2_search) begin
						if(H_Cont == x1_search)
								contadorBranco2 <= 0;
						if(morfologico == 10'b1111111111) begin
							if(OkLinha == 0 && contadorBranco == 0) begin
								x1_achou <= H_Cont;
								y1_achou <= V_Cont;
							end
							contadorBranco <= contadorBranco + 1;
							if(contadorBranco >= 180) begin
								contadorBranco <= 0;
								OkLinha <= OkLinha + 1;
								if(OkLinha == 1) 
									LinhaCheck <= OkLinha;
							end
							else
								achou <= 1'b0;
						end
						if(OkLinha >= 55) begin
							x1_achou <= x1_achou - 15;
							y1_achou <= y1_achou - 10;
							x2_achou <= H_Cont + 30;
							y2_achou <= V_Cont + 20;
							OkLinha <= 0;
							achou <= 1'b1;
						end
					end
					if(H_Cont >= x2_search2 && H_Cont <= x1_search2) begin
						if(H_Cont == x2_search2)
								contadorBranco <= 0;
						if(morfologico == 10'b1111111111) begin
							if(OkLinha2 == 0 && contadorBranco2 == 0) begin
								x1_achou2 <= H_Cont;
								y1_achou2 <= V_Cont;
							end
							contadorBranco2 <= contadorBranco2 + 1;
							if(contadorBranco2 >= 180) begin
								contadorBranco2 <= 0;
								OkLinha2 <= OkLinha2 + 1;
								if(OkLinha2 == 1) 
									LinhaCheck2 <= OkLinha2;								
							end
							else
								achou2 <= 1'b0;
						end
						if(OkLinha2 >= 55) begin
							x1_achou2 <= x1_achou2 - 15;
							y1_achou2 <= y1_achou2 - 10;
							x2_achou2 <= H_Cont + 30;
							y2_achou2 <= V_Cont + 20;
							OkLinha2 <= 0;
							achou2 <= 1'b1;
						end
					end
					if(V_Cont >= V_SYNC_TOTAL && H_Cont == 0) begin
						x1_search <= x1_search + 10;
						x2_search <= x2_search + 10;
						x1_search2 <= x1_search2 - 10;
						x2_search2 <= x2_search2 - 10;
						if(x1_search == x1_search2) begin
							x1_search <= 0;
							x2_search <= 300;
							x1_search2 <= 800;
							x2_search2 <= 500;
						end
					end
				end
			if(achou == 1'b1) begin
				x1 <= x1_achou;
				x2 <= x2_achou;
				y1 <= y1_achou;
				y2 <= y2_achou;
				ativo = 1'b1;
			end
			if(achou2 == 1'b1) begin
				x1 <= x1_achou2;
				x2 <= x2_achou2;
				y1 <= y1_achou2;
				y2 <= y2_achou2;
				ativo = 1'b1;
			end			
		end
end
endmodule
