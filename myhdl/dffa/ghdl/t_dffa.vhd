-- flip-flop d com reset assincrono
library ieee;
use ieee.std_logic_1164.all;
use work.all;

---------------------------------------------
-- declarações

entity t_dffa is
end t_dffa;

architecture behav of t_dffa is

component dffa 
port(	d: in std_logic;
	clk: in std_logic;
	rst: in std_logic;	
	q: out std_logic
	
);
end component;

----------------------------------------------

signal	d: std_logic := '0';
signal	clk: std_logic := '0';
signal	rst: std_logic := '1';
signal	q: std_logic;

----------------------------------------------
begin

uut: dffa
port map (
	d => d,
	clk => clk,
	rst => rst,
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

rst_gen: process
begin
	wait for 800 ns;
	rst <= '0';
end process;

end behav;
