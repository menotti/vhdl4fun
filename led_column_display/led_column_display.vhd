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
	Generic ( address_width : integer := 5);
    	Port ( clk : in  STD_LOGIC;
 	   cnt_high: in STD_LOGIC_VECTOR(7 downto 0);
               led : out  STD_LOGIC_VECTOR (7 downto 0));
end led_column_display;

architecture Behavioral of led_column_display is

	COMPONENT block_ram
	Generic ( address_width : integer := 5);
	PORT(
		data_in  : IN std_logic_vector(7 downto 0);
		address  : IN std_logic_vector(address_width-1 downto 0);
		we       : IN std_logic;
		oe       : IN std_logic;
		clk      : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT clk_div
	PORT(
		clk_in  : IN std_logic;          
	        cnt_high: in STD_LOGIC_VECTOR(7 downto 0);
		clk_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT counter
	Generic ( address_width : integer := 5);
	PORT(
		clk : IN std_logic;          
		count : OUT std_logic_vector(address_width-1 downto 0)
	);
	END COMPONENT;

	signal address: std_logic_vector(address_width-1 downto 0);
	signal clk_out: std_logic;

begin

	memoria: block_ram 
	GENERIC MAP (address_width => 5) 
	PORT MAP(
		data_in => (others => '0'),
		address => address,
		we => '0',
		oe => '1',
		clk => clk,
		data_out => led
	);

	divisor: clk_div PORT MAP(
		clk_in => clk,
		cnt_high => cnt_high,
		clk_out => clk_out
	);

	contador: counter 
	GENERIC MAP (address_width => 5) 
	PORT MAP(
		clk => clk_out,
		count => address
	);

end Behavioral;

