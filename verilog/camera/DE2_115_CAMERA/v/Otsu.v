module Otsu(
		input iClk,
		input clk2x,
		input reset,
		input VS,
		input VGA_Read,
		input [7:0] Valor_Pixel,
		output [7:0] Level
);
	
reg sel;
	
wire [18:0] Fio0;
wire [26:0] Fio1;
wire [26:0] Fio2;
wire [26:0] Fio3;
wire [26:0] Fio4;
	
histo_control Histograma(
					.iClk(iClk),
					.clk2x(clk2x),
					.VS(VS),
					.VGA_Read(VGA_Read),
					.Valor_Pixel(Valor_pixel),
					.val_hist(Fio0),
					.val_hist_area(Fio1)	
);

histograma_acc Histograma_Acumulado(
					.iClk(iClk),
					.clk2x(clk2x),
					.sel(sel),
					.valor_hist(Fio0),
					.dados_saida(Fio3)
);

histograma_area_acc Histograma_Area_Acumulado(
					.iClk(iClk),
					.clk2x(clk2x),
					.sel(sel),
					.valor_area(Fio1),
					.miT(Fio4),
					.dados_saida(Fio2)
);
	
sigmaquadrado Sigmaquadrado(
					.iClk(iClk),
					.clk2x(clk2x),
					.ativa(sel),
					.omega0(Fio3),
					.miT(Fio4),
					.mi0(Fio2),
					.Level(Level)
);

endmodule	