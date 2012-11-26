LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity reg16 is
	generic (rst_value : std_logic_vector(15 downto 0) := (others => '0'));
	port (
		clk, rst : in std_logic; 
		       d : in std_logic_vector(15 downto 0); 
		       q : out std_logic_vector(15 downto 0));
end reg16;
     
architecture behav of reg16 is
	signal s: std_logic_vector(15 downto 0);
begin
	process(rst, clk)
	begin
		if (rst='1') then
			s <= rst_value;
		elsif (clk'event and clk='1') then
			s <= d;
		end if;
	end process;

	q <= s;
	
end behav;

