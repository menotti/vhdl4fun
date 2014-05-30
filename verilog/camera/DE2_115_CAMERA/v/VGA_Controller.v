module	VGA_Controller(	//	Host Side
						iRed,
						iGreen,
						iBlue,
						oRequest,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,

						//	Control Signal
						iCLK,
						iRST_N,
						iZOOM_MODE_SW,
						Ret,
						x1,
						y1,
						x2,
						y2,
						puroR,
						puroG,
						puroB,
						padrao,
						morfologico,
						bSobel,
						freeze
							);

//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	48;
parameter	H_SYNC_ACT	=	640;	
parameter	H_SYNC_FRONT=	16;
parameter	H_SYNC_TOTAL=	800;

//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	33;
parameter	V_SYNC_ACT	=	480;	
parameter	V_SYNC_FRONT=	10;
parameter	V_SYNC_TOTAL=	525; 

//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
//	Host Side
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;
input		[9:0] puroR, puroG, puroB;
input padrao;
output	reg			oRequest;
//	VGA Side
output	reg	[9:0]	oVGA_R;
output	reg	[9:0]	oVGA_G;
output	reg	[9:0]	oVGA_B;
output	reg			oVGA_H_SYNC;
output	reg			oVGA_V_SYNC;
output	reg			oVGA_SYNC;
output	reg			oVGA_BLANK;
output reg freeze;
input Ret;
input [9:0] x1;
input [9:0] y1;
input [9:0] x2;
input [9:0] y2;
input [9:0] morfologico;

reg valido; 
reg [14:0] contador;
reg reset_busca, ativo, check;
reg reset_validacao;	
input [9:0] bSobel;

wire		[9:0]	mVGA_R;
wire		[9:0]	mVGA_G;
wire		[9:0]	mVGA_B;
reg					mVGA_H_SYNC;
reg					mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;

//	Control Signal
input				iCLK;
input				iRST_N;
input 				iZOOM_MODE_SW;

//	Internal Registers and Wires
reg		[12:0]		H_Cont, x1_search, x2_search, x1_search2, x2_search2;
reg		[12:0]		V_Cont, x1_achou, x2_achou, y1_achou, y2_achou, x1_achou2, x2_achou2, y1_achou2, y2_achou2;
reg [10:0] OkLinha, LinhaCheck, OkLinha2, LinhaCheck2;
reg [10:0] contadorBranco, contadorBranco2;
reg achou, achou2;

wire	[12:0]		v_mask;

assign v_mask = 13'd0 ;//iZOOM_MODE_SW ? 13'd0 : 13'd26;

////////////////////////////////////////////////////////

assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue	:	0;

						

						
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				oVGA_R <= 0;
				oVGA_G <= 0;
            oVGA_B <= 0;
				oVGA_BLANK <= 0;
				oVGA_SYNC <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0;
				achou <= 1'b0;
				contadorBranco <= 0;
				x1_search <= 0;
				x2_search <= 270;
				OkLinha <= 0;
				LinhaCheck <= 0;
				achou2 <= 1'b0;
				contadorBranco2 <= 0;
				x1_search2 <= 800;
				x2_search2 <= 530;
				OkLinha2 <= 0;
				LinhaCheck2 <= 0;
				ativo = 1'b0;
				check = 1'b0;
				reset_validacao <= 1'b0;
				freeze <= 1'b0;
			end
		else
			begin
				if(reset_busca == 1'b1) begin
					achou <= 1'b0;
					achou2 <= 1'b0;
					check <= 1'b0;
					reset_validacao <= 1'b1;
				end
				if(valido == 1'b1) begin
					check <= 1'b0;
					ativo <= 1'b1;
				end
				if(padrao == 1'b1 && achou == 1'b0 && achou2 == 1'b0) begin
					if(LinhaCheck == 50)begin
						OkLinha <= 0;
						LinhaCheck <= 0;
					end
					if(LinhaCheck2 == 50) begin
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
							if(contadorBranco >= 230) begin
								contadorBranco <= 0;
								OkLinha <= OkLinha + 1;
								if(OkLinha == 1) 
									LinhaCheck <= OkLinha;
							end
							else
								achou <= 1'b0;
						end
						if(OkLinha >= 44) begin
							x1_achou <= x1_achou - 15;
							y1_achou <= y1_achou;
							x2_achou <= H_Cont + 20;
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
							if(contadorBranco2 >= 230) begin
								contadorBranco2 <= 0;
								OkLinha2 <= OkLinha2 + 1;
								if(OkLinha2 == 1) 
									LinhaCheck2 <= OkLinha2;								
							end
							else
								achou2 <= 1'b0;
						end
						if(OkLinha2 >= 44) begin
							x1_achou2 <= x1_achou2 - 15;
							y1_achou2 <= y1_achou2;
							x2_achou2 <= H_Cont + 20;
							y2_achou2 <= V_Cont + 20;
							OkLinha2 <= 0;
							achou2 <= 1'b1;
						end
					end
					if(V_Cont >= V_SYNC_TOTAL && H_Cont == 0) begin
						x1_search <= x1_search + 5;
						x2_search <= x2_search + 5;
						x1_search2 <= x1_search2 - 5;
						x2_search2 <= x2_search2 - 5;
						if(x1_search == x1_search2) begin
							x1_search <= 0;
							x2_search <= 300;
							x1_search2 <= 800;
							x2_search2 <= 500;
						end
					end
				end
				if(achou == 1'b1 || achou2 == 1'b1)
					if(V_Cont == 0 && H_Cont == 1 && valido == 1'b0)
							check <= 1'b1;
				if(ativo == 1'b1)begin 
					if(achou == 1'b1)begin 
						freeze <= 1'b1;
						if(H_Cont >= x1_achou && H_Cont <= x2_achou && V_Cont >= y1_achou	&& V_Cont <= y2_achou) begin
							oVGA_R <= puroR;
							oVGA_G <= puroG;
							oVGA_B <= puroB;
							check <= 1'b0;
						end
						else begin
							oVGA_R <= 10'b0000000000;
							oVGA_G <= 10'b0000000000;
							oVGA_B <= 10'b0000000000;
							check <= 1'b0;
						end
					end
					else if(achou2 == 1'b1) begin
						freeze <= 1'b1;
						if(H_Cont >= x1_achou2 && H_Cont <= x2_achou2 && V_Cont >= y1_achou2	&& V_Cont <= y2_achou2) begin
							oVGA_R <= puroR;
							oVGA_G <= puroG;
							oVGA_B <= puroB;
						end
						else begin
							oVGA_R <= 10'b0000000000;
							oVGA_G <= 10'b0000000000;
							oVGA_B <= 10'b0000000000;
						end
					end
					else begin
							oVGA_R <= mVGA_R;
							oVGA_G <= mVGA_G;
							oVGA_B <= mVGA_B;
					end
				end
//retangulo de linhas finas aleatorio						
				else if(Ret == 1'b1) begin
					if (H_Cont == x1 && V_Cont >= y1 && V_Cont <= y2) begin
						oVGA_R <= 0;
						oVGA_G <= 1023; 
						oVGA_B <= 0;
					end
					else if (H_Cont == x2 && V_Cont >= y1 && V_Cont <= y2) begin
						oVGA_R <= 0;
						oVGA_G <= 1023; 
						oVGA_B <= 0;
					end
					else if (V_Cont == y1 && H_Cont >= x1 && H_Cont <= x2) begin
						oVGA_R <= 0;
						oVGA_G <= 1023; 
						oVGA_B <= 0;
					end
					else if (V_Cont == y2 && H_Cont >= x1 && H_Cont <= x2) begin
						oVGA_R <= 0;
						oVGA_G <= 1023; 
						oVGA_B <= 0;
					end
				end
				else begin
					oVGA_R <= mVGA_R;
					oVGA_G <= mVGA_G;
					oVGA_B <= mVGA_B;
				end
				oVGA_BLANK <= mVGA_BLANK;
				oVGA_SYNC <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;				
			end               
	end
	
	

always@(posedge iCLK or negedge iRST_N) begin
	if (!iRST_N)	begin
		contador <= 0;
		reset_busca <= 1'b0;
		valido <= 1'b0;
	end
	else begin	
		if(reset_validacao == 1'b1)
			reset_busca <= 1'b0;
		if(check == 1'b1) begin
			if(achou2 == 1'b1) begin
				if(H_Cont >= x1_achou2 && H_Cont <= x2_achou2 && V_Cont >= y1_achou2 && V_Cont <= y2_achou2) begin
					if(bSobel == 10'b1111111111)
						contador <= contador + 1;
				end
				if(V_Cont == y2_achou2 && H_Cont == x2_achou2) begin
					if(contador <= 7300) begin
						contador <= 0;
						reset_busca <= 1'b1;
					end
					else begin
						valido <= 1'b1;
						contador <= 0;
						reset_busca <= 0;
					end
				end
			end
			else begin
				if(H_Cont >= x1_achou && H_Cont <= x2_achou && V_Cont >= y1_achou && V_Cont <= y2_achou) begin
					if(bSobel == 10'b1111111111)
						contador <= contador + 1;
				end
				if(V_Cont == y2_achou && H_Cont == x2_achou) begin
					if(contador <= 7300) begin
						contador <= 0;
						reset_busca <= 1'b1;
					end
					else begin
						valido <= 1'b1;
						contador <= 0;
						reset_busca <= 0;
					end
				end
			end
		end
	end
end



//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	oRequest	<=	0;
	else
	begin
		if(	H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 40 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		mVGA_H_SYNC	<=	0;
		else
		mVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

endmodule
