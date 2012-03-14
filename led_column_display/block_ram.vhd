----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:44:18 03/14/2012 
-- Design Name: 
-- Module Name:    block_ram - Behavioral 
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

entity block_ram is
generic(
	data_width : integer := 8;
	address_width : integer := 6
);
port(
	data_in : in std_logic_vector(data_width-1 downto 0) := (others => '0');
	address : in std_logic_vector(address_width-1 downto 0);
	we: in std_logic := '0';
	oe: in std_logic := '1';
	clk : in std_logic;
	data_out : out std_logic_vector(data_width-1 downto 0));
end block_ram;

architecture rtl of block_ram is

constant mem_depth : integer := 2**address_width;
type ram_type is array (mem_depth-1 downto 0)
of std_logic_vector (data_width-1 downto 0);

signal read_a : std_logic_vector(address_width-1 downto 0);
signal RAM : ram_type := ram_type'(
	 ("00000000"),
	 ("01111110"),
	 ("01111110"),
	 ("11000011"),
	 ("11111111"),
	 ("10000001"),
	 ("01111110"),
	 ("01111110"),
	 ("10111101"),
	 ("11111111"),
	 ("00111111"),
	 ("11001111"),
	 ("11110011"),
	 ("11111100"),
	 ("11111111"),
	 ("10000000"),
	 ("01111111"),
	 ("01111111"),
	 ("10000000"),
	 ("11111111"),
	 ("00000000"),
	 ("11101110"),
	 ("11101110"),
	 ("11111110"),
	 ("11111111"),
	 ("10111001"),
	 ("01110110"),
	 ("01101110"),
	 ("10011101"),
	 ("11111111"),
	 ("10000001"),
	 ("01111110"),
	 ("01111110"),
	 ("10111101"),
	 ("11111111"),
	 ("00000001"),
	 ("11101110"),
	 ("11101110"),
	 ("00000001"),
	 ("11111111"),
	 ("00000000"),
	 ("11001110"),
	 ("10101110"),
	 ("01110001"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"),
	 ("11111111"));

begin
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (we = '1') then
        RAM(conv_integer(address)) <= data_in;
        data_out <= RAM(conv_integer(read_a));
      elsif (oe = '1') then
        data_out <= RAM(conv_integer(read_a));
      end if;
      read_a <= address;
    end if;
  end process;
end rtl;
