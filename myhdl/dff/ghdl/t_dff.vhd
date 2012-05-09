-- flip-flop d
library ieee;
use ieee.std_logic_1164.all;
use work.all;

---------------------------------------------
-- declarações

entity t_dff is
end t_dff;

architecture behav of t_dff is

component dff 
port(	d: in std_logic;
	clk: in std_logic;
	q: out std_logic
);
end component;

----------------------------------------------

signal	d: std_logic := '0';
signal	clk: std_logic := '0';
signal	q: std_logic;

----------------------------------------------
begin

uut: dff
port map (
	d => d,
	clk => clk,
	q => q
);

clock_gen: process 
begin
	for i in 1 to 1000 loop
	    wait for 10 ns;
	    clk <= not clk;
	end loop;
end process;

stim_gen: process 
begin
	wait until clk = '0';
	d <= not d;
end process;

end behav;
