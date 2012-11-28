LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;

entity fibonacci is
	port (
		clk, rst: in std_logic;
		s: out std_logic_vector(15 downto 0)
	);
end fibonacci;
     
architecture structural of fibonacci is

	signal s0, s1, s2: std_logic_vector(15 downto 0);

    COMPONENT reg16
    generic (rst_value : std_logic_vector(15 downto 0) := (others => '0'));
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         d : IN  std_logic_vector(15 downto 0);
         q : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;

begin
	 
	 reg0: reg16 PORT MAP (
          clk => clk,
          rst => rst,
          d => s1,
          q => s0
	);

	 reg1: reg16 generic map (rst_value => conv_std_logic_vector(1, 16))
	 PORT MAP (
          clk => clk,
          rst => rst,
          d => s2,
          q => s1
	);
	
	s2 <= s0 + s1;
	
	s <= s0;

end structural;

