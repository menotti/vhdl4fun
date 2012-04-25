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
	wait for 10 ns;
	clk <= not clk;
end process;

stim_gen: process
begin
	wait for 15 ns;
	d <= '1';
	wait for 30 ns;
	d <= '0';
	wait for 30 ns;
	d <= '1';
	wait for 30 ns;
	rst <= '0';
	wait for 30 ns;
	rst <= '1';
	d <= '0';

	wait; -- will wait forever;
end process;

end behav;
