LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY t_fibonacci IS
END t_fibonacci;
 
ARCHITECTURE behavior OF t_fibonacci IS 
 
    COMPONENT fibonacci
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         s : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

   signal s : std_logic_vector(15 downto 0);

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: fibonacci PORT MAP (
          clk => clk,
          rst => rst,
          s => s
        );

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin		
	rst <= '1';
	wait for 20 ns;	
	rst <= '0';
	wait;
   end process;

END;
