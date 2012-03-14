----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:24:40 03/14/2012 
-- Design Name: 
-- Module Name:    led_column_display - Behavioral 
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

entity led_column_display is
    Port ( clk : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end led_column_display;

architecture Behavioral of led_column_display is

	COMPONENT block_ram
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		address : IN std_logic_vector(5 downto 0);
		we : IN std_logic;
		oe : IN std_logic;
		clk : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT clk_div
	PORT(
		clk_in : IN std_logic;          
		clk_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT counter
	PORT(
		clk : IN std_logic;          
		count : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;

	signal address: std_logic_vector(5 downto 0);
	signal clk_out: std_logic;

begin

	memoria: block_ram PORT MAP(
		data_in => "00000000",
		address => address,
		we => '0',
		oe => '1',
		clk => clk,
		data_out => led
	);

	divisor: clk_div PORT MAP(
		clk_in => clk,
		clk_out => clk_out
	);

	contador: counter PORT MAP(
		clk => clk_out,
		count => address
	);

end Behavioral;

