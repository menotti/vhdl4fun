----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:25:23 03/14/2012 
-- Design Name: 
-- Module Name:    clk_div - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_div is
    Port ( clk_in : in  STD_LOGIC;
	        cnt_high: in STD_LOGIC_VECTOR(7 downto 0);
           clk_out : OUT  STD_LOGIC);
end clk_div;

architecture Behavioral of clk_div is

	signal clk_int : std_logic := '0';
	signal cnt_max: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin

	process(clk_in)
		variable cnt: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	begin
		if rising_edge(clk_in) then
			if (cnt=cnt_max)then
				cnt := (others => '0');
				clk_int <= not clk_int;
			else
				cnt := cnt + 1;
			end if;
		end if;
	end process;
	
	cnt_max(15 downto 8) <= cnt_high;
	clk_out <= clk_int;
	
end Behavioral;

