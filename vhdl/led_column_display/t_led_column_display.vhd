
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:21:28 03/14/2012
-- Design Name:   led_column_display
-- Module Name:   /home/menotti/workspace/vhdl4fun/led_column_display/t_led_column_display.vhd
-- Project Name:  led_column_display
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: led_column_display
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY t_led_column_display IS
END t_led_column_display;

ARCHITECTURE behavior OF t_led_column_display IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT led_column_display
	generic (
		address_width : integer := 5);
	PORT(
		clk : IN std_logic;          
		cnt_high : IN std_logic_vector(7 downto 0);
		led : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL cnt_high : std_logic_vector(7 downto 0) := (others => '1');

	--Outputs
	SIGNAL led :  std_logic_vector(7 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: led_column_display 
	GENERIC MAP(
		address_width => 5
	)
	PORT MAP(
		clk => clk,
		cnt_high => cnt_high,
		led => led
	);

	tb : PROCESS
	BEGIN
		wait for 10 ns;
		clk <= not clk;
	END PROCESS;

END;
