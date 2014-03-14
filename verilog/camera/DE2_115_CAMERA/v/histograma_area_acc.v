module histograma_area_acc(
			input iClk,
			input sel,
			input clk2x,
			input [26:0] valor_area,
			output reg [26:0] miT,
			output [26:0] dados_saida
);

reg [7:0] contador;
reg [7:0] contador_dois;
reg [26:0] dados;
reg [7:0] wraddress;
wire [26:0] lixo;
initial 
contador = 8'd1;

initial
contador_dois = 8'd0;

initial
dados = valor_area;

always @ (posedge iClk)
begin
	if (sel == 1'b1)
		begin
			if(contador == 8'd255)
				begin
					contador <= 1;
					miT <= dados;
				end
			else
				dados <= dados + valor_area;
				wraddress = contador;
				contador <= contador + 1;
		end
	else
		begin
			if(contador_dois == 8'd255)
					contador_dois <= 0;
			else
					dados <= 0;
					wraddress = contador_dois;
					contador_dois <= contador_dois + 1;
		end
end		

mem_2port_27bits Memoria_Hist_Area_ACC_27_bits(
		.data(dados),
		.inclock(clk2x),
		.outclock(iClk),
		.rdaddress(wraddress),
		.wraddress(wraddress),
		.wren(iClk),
		.q(dados_saida)
);		
	
mem_2port1 ram2port1(
		.clock(clk2x),
		.data(dados),
		.rdaddress(wraddress),
		.rden(~(iClk) &(sel)),
		.wraddress(wraddress),
		.wren(iClk),
		.q(dados_saida)
);

mem_2port2 ram2port2(
		.clock(clk2x),
		.data(dados),
		.rdaddress(wraddress),
		.rden(iClk &(~(sel))),
		.wraddress(wraddress),
		.wren(iClk),
		.q(lixo)
);


endmodule	


