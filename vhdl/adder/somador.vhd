entity somador is
	port (i0, i1 : in bit; ci : in bit; s : out bit; co : out bit);
end somador;
     
architecture rtl of somador is
begin
	-- Calculo da soma.  
	s <= i0 xor i1 xor ci;
	-- Calculo do carry out.
	co <= (i0 and i1) or (i0 and ci) or (i1 and ci);
end rtl;

