// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	VGA_Controller
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN Peli Li:| 22/07/2010:| Initial Revision
// --------------------------------------------------------------------

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
						morfologico
							);
`include "VGA_Param.h"

`ifdef VGA_640x480p60
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

`else
 // SVGA_800x600p60
////	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	128;         //Peli
parameter	H_SYNC_BACK	=	88;
parameter	H_SYNC_ACT	=	800;	
parameter	H_SYNC_FRONT=	40;
parameter	H_SYNC_TOTAL=	1056;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	4;
parameter	V_SYNC_BACK	=	23;
parameter	V_SYNC_ACT	=	600;	
parameter	V_SYNC_FRONT=	1;
parameter	V_SYNC_TOTAL=	628;

`endif
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
input Ret;
input [9:0] x1;
input [9:0] y1;
input [9:0] x2;
input [9:0] y2;
input [9:0] morfologico;

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
reg		[12:0]		H_Cont, x1_search, x2_search;
reg		[12:0]		V_Cont, x1_achou, x2_achou, y1_achou, y2_achou;
reg [5:0] OkLinha;
reg [7:0] contadorBranco;
reg achou;

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
			end
		else
			begin
// 1)busca um retangulo branco na imagem, que no caso é a placa, com uma margem de erro para a resolução
// de 100x32.5
				if(padrao == 1'b1 && achou == 1'b0) begin
// verificação em uma linha de 100 pixels
					if(H_Cont >= x1_search && H_Cont <= x2_search) begin
// caso o pixel for branco entra no if e o contador do pixel acumula + 1
						if(morfologico == 10'b0000000000) begin
							contadorBranco <= contadorBranco + 1;
// se o contador passar ou chegar à 85, que é a margem deixada dentro de 100 pixels, ele volta para 0 e busca de novo
// essa linha recebe ok e o procedimento espera a próxima linha
							if(contadorBranco >= 85) begin
								contadorBranco <= 0;
								OkLinha <= OkLinha + 1;
							end
// se na linha determinada no procedimento 1 não foi encontrado o número minimo de pixels brancos, a linha não recebe ok
// e com isso o processo esquece o que foi computado anteriormente, assim as coordenadas são dadas neste ponto, pois no 
// próximo clock tudo é feito novamente
							else begin
								x1_achou <= H_Cont;
								y1_achou <= V_Cont;
								OkLinha <= 0;
								achou <= 1'b0;
							end
						end
// se no procedimento 1) conseguuiu achar 28 linhas ok, dentro de um universo de 32,5 é satisfatório, isso quer dizer
// que nessas coordenadas pode existir um retângulo com a devida proporção de uma placa automotiva
// dessa forma as cordernadas de x2_achou e y2_achou recebem com uma margem de 10 pixels as coordenadas atuais em que
// estava sendo procurado o retangulo
						if(OkLinha >= 28) begin
							x2_achou <= H_Cont + 10;
							y2_achou <= V_Cont + 10;
							OkLinha <= 0;
							achou <= 1'b1;
						end
					end
//2)se o contador do vga controller em relação as linhas horizontais, V_Cont, chegou ao fim é somado mais um no parametro
// de busca do procedimento 1)
					if(V_Cont >= V_SYNC_TOTAL) begin
						x1_search <= x1_search + 1;
						x2_search <= x2_search + 1;
// e se x2_search for maior em relação ao parametro inicial H_SYNC_TOTAL, o procedimento 1) volta para o começo da linha
// horizontal de 100 pixels para iniciar nova busca 
						if(x2_search > H_SYNC_TOTAL) begin
							x1_search <= 0;
							x2_search <= 100;
						end
					end
				end
// se achou, teoricamente, a placa, mostra ela em colorido
				else if(padrao == 1'b1 && achou == 1'b1) begin
					if(H_Cont >= x1_achou && H_Cont <= x2_achou && V_Cont >= y1_achou && V_Cont <= y2_achou) begin
						oVGA_R <= puroR;
						oVGA_G <= puroG;
						oVGA_B <= puroB;
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