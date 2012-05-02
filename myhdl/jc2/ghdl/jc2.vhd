--------------------------------------------------------------------------------
--- contador johnson bidirecional de 4 bits 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity jc2 is
port ( 
        goLeft: in std_logic;
        goRight: in std_logic;
        stop: in std_logic;
        clk: in std_logic;
        q: out unsigned(3 downto 0)
         );
end jc2;

architecture behv of jc2 is

signal temp: unsigned(3 downto 0):=(others => '0');
signal x1: std_logic := '0';
signal x2: std_logic := '0';

begin

process(clk)
begin
     if( rising_edge(clk) ) then
	     if (x1 = '1') then
		temp(3 downto 1) <= temp(2 downto 0);
                temp(0) <= not temp(3);
	     elsif (x2 = '1') then
                temp(2 downto 0) <= temp(3 downto 1);
                temp(3) <= not temp(0);
             end if;
     end if;
end process;

process(clk)
begin
	if (rising_edge(clk)) then
		if (stop='0') then
			x1 <= '0';
			x2 <= '0';
		elsif (goLeft='0') then
			x1 <= '1';
			x2 <= '0';
		elsif (goRight='0') then
			x1 <= '0';
			x2 <= '1';
		end if;
	end if;
end process;

q <= temp;
     
end behv;

