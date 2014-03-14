module sigmaquadrado( 
			input iClk,
			input ativa,
			input clk2x,
			input [18:0] omega0,
			input [26:0] miT,
			input [26:0] mi0,
			output reg [7:0] Level
);

wire [45:0] Fio0;
wire [45:0] Fio1;
wire [38:0] Fio2;
wire [38:0] Fio3;
wire [45:0] Fio4;
wire [38:0] Fio5;
wire [45:0] Fio6;
wire [45:0] Fio7;
wire [92:0] Fio8;
wire Fio9;

parameter MN = 307200;

multiplicacao_27_19 Multiplicao01(
		.clock(iClk),
		.dataa(miT),
		.datab(omega0),
		.result(Fio0)
);

multiplicacao_27_19 Multiplicacao02(
		.clock(iClk),
		.dataa(mi0),
		.datab(MN),
		.result(Fio1)
);

multiplicacao_19_19 Multiplicacao03(
		.clock(iClk),
		.dataa(omega0),
		.datab(MN),
		.result(Fio2)
);

multiplicacao_19_19 Multiplicacao04(
		.clock(iClk),
		.dataa(omega0),
		.datab(omega0),
		.result(Fio3)
);

subtracao_46_46 Subtracao01(
		.clock(iClk),
		.dataa(Fio0),
		.datab(Fio1),
		.result(Fio4)
);

subtracao_38_38 Subtracao02(
		.clock(iClk),
		.dataa(Fio2),
		.datab(Fio3),
		.result(Fio5)
);

Registrador DFF(
		.clock(iClk),
		.data(Fio5),
		.q(Fio7)
);

Divisao Divisao01(
		.clock(iClk),
		.numer(Fio4),
		.denom(Fio5),
		.quotient(Fio6),
		.remain()
);

multiplicacao_45_45 Multiplicacao05(
		.clock(iClk),
		.dataa(Fio7),
		.datab(Fio6),
		.result(Fio8)
);

reg [92:0] maiorsigma;

initial
Level = 8'd0;
initial
maiorsigma = 92'd0;

always @ (posedge iClk)
begin
if(ativa == 1'b1)
	if(Fio9 == 1'b1)
		Level <= Level + 1;
		maiorsigma <= Fio8;
end

comparador compara01(
		.dataa(Fio8),
		.datab(maiorsigma),
		.agb(Fio9)
);

endmodule












