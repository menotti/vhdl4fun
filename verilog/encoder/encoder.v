module encoder(
binary_out , //  4 bit saída binaria
encoder_in , //  16-bit entrada
enable       //  Ligar o encoder
);

	output [3:0] binary_out ;
	input  enable ; 
	input [15:0] encoder_in ; 

	wire [3:0] binary_out ;
      
	assign  binary_out  = (!enable) ? 0 : (
		(encoder_in == 16'b0000_0000_0000_0001) ? 0 : 
		(encoder_in == 16'b0000_0000_0000_0010) ? 1 : 
		(encoder_in == 16'b0000_0000_0000_0100) ? 2 : 
		(encoder_in == 16'b0000_0000_0000_1000) ? 3 : 
		(encoder_in == 16'b0000_0000_0001_0000) ? 4 : 
		(encoder_in == 16'b0000_0000_0010_0000) ? 5 : 
		(encoder_in == 16'b0000_0000_0100_0000) ? 6 : 
		(encoder_in == 16'b0000_0000_1000_0000) ? 7 : 
		(encoder_in == 16'b0000_0001_0000_0000) ? 8 : 
		(encoder_in == 16'b0000_0010_0000_0000) ? 9 : 
		(encoder_in == 16'b0000_0100_0000_0000) ? 10 : 
		(encoder_in == 16'b0000_1000_0000_0000) ? 11 : 
		(encoder_in == 16'b0001_0000_0000_0000) ? 12 : 
		(encoder_in == 16'b0010_0000_0000_0000) ? 13 : 
		(encoder_in == 16'b0100_0000_0000_0000) ? 14 : 15); 
	
endmodule 