
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:31:39 03/14/2012
-- Design Name:   clk_div
-- Module Name:   C:/temp/led_column_display/t_clk_div.vhd
-- Project Name:  led_column_display
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clk_div
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

ENTITY t_clk_div_vhd IS
END t_clk_div_vhd;

ARCHITECTURE behavior OF t_clk_div_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT clk_div
	PORT(
		clk_in : IN std_logic;          
		clk_out : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk_in :  std_logic := '0';

	--Outputs
	SIGNAL clk_out :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: clk_div PORT MAP(
		clk_in => clk_in,
		clk_out => clk_out
	);

	tb : PROCESS
	BEGIN
		wait for 10 ns;
		clk_in <= not clk_in;
	END PROCESS;

END;
