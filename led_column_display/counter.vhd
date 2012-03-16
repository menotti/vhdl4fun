----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:35 03/14/2012 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counter is
	generic(
		address_width : integer := 5
	);
    Port ( clk : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (address_width-1 downto 0));
end counter;

architecture Behavioral of counter is

	signal count_int: std_logic_vector(address_width-1 downto 0) := (others =>'0');

begin

	process(clk)
	begin
		if rising_edge(clk) then
			count_int <= count_int + 1;
		end if;
	end process;
	
	count <= count_int;

end Behavioral;

