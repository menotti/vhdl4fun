
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:07:36 03/14/2012
-- Design Name:   counter
-- Module Name:   C:/temp/led_column_display/t_counter.vhd
-- Project Name:  led_column_display
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter
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

ENTITY t_counter_vhd IS
END t_counter_vhd;

ARCHITECTURE behavior OF t_counter_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT counter
	PORT(
		clk : IN std_logic;          
		count : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';

	--Outputs
	SIGNAL count :  std_logic_vector(5 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: counter PORT MAP(
		clk => clk,
		count => count
	);

	tb : PROCESS
	BEGIN
		-- Wait 100 ns for global reset to finish
		wait for 150 ns;
		clk <= not clk;
	END PROCESS;

END;
