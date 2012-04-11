
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:57:54 03/14/2012
-- Design Name:   block_ram
-- Module Name:   C:/temp/led_column_display/t_block_ram.vhd
-- Project Name:  led_column_display
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: block_ram
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

ENTITY t_block_ram_vhd IS
END t_block_ram_vhd;

ARCHITECTURE behavior OF t_block_ram_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
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

	--Inputs
	SIGNAL we :  std_logic := '0';
	SIGNAL oe :  std_logic := '1';
	SIGNAL clk :  std_logic := '0';
	SIGNAL data_in :  std_logic_vector(7 downto 0) := (others=>'0');
	SIGNAL address :  std_logic_vector(5 downto 0) := (others=>'0');

	--Outputs
	SIGNAL data_out :  std_logic_vector(7 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: block_ram PORT MAP(
		data_in => data_in,
		address => address,
		we => we,
		oe => oe,
		clk => clk,
		data_out => data_out
	);

	tb : PROCESS
	BEGIN
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		clk <= not clk;
		address <= address + 1;
	END PROCESS;

END;
