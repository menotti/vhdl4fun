module histo_control(
			input iClk,
			input clk2x,
			input VS, 
			input VGA_Read,
			input [7:0] Valor_Pixel,
			output [18:0] val_hist,
			output [26:0] val_hist_area
);

reg [7:0] Address;
reg		 enable;
reg [7:0] counter_add;
reg [7:0] contador;
reg		 en;

wire [18:0] Histo_data;
wire [18:0] qd;

parameter tons_cinza = 255;

always @ (posedge iClk)
	begin
			if(VS == 1'b1)
				begin
						contador = 0;
						counter_add = 0;
				end
			else
				begin
					if(contador < tons_cinza)
						begin
								contador = contador + 1;
								en = 1'b1;
						end
					else
						en = 1'b0;
						if(contador <= tons_cinza)
								counter_add = contador;
				end
					Address <= counter_add;
					enable <= en;
	end
	
hist_area Histograma_area(
		.iClk(iClk),
		.sel(VS & VGA_Read),
		.clk2x(clk2x),
		.endereco_pixel(Valor_Pixel),
		.endereco_contador(Address),
		.dados_saida(val_hist)
);

histograma Histograma(
		.iClk(iClk),
		.sel(VS & VGA_Read),
		.clk2x(VS & VGA_Read),
		.endereco_pixel(Valor_Pixel),
		.endereco_contador(Address),
		.dados_saida(val_hist)
);

endmodule

