module decoder(
binary_in   , //  4 bit entrada binaria
decoder_out , //  16-bit saida 
enable        //  Ligar para decodificar
);

	input [3:0] binary_in;
	input  enable ; 
	output [15:0] decoder_out ; 
        
	wire [15:0] decoder_out ; 

	assign decoder_out = (enable) ? (1 << binary_in) : 16'b0 ;

endmodule