-- flip-flop d
library ieee;
use ieee.std_logic_1164.all;
use work.all;

---------------------------------------------
-- declarações

entity dff is
port(	d: in std_logic;
	clk: in std_logic;
	rst: in std_logic;
	q: out std_logic
);
end dff;

----------------------------------------------

architecture behv of dff is
begin

    process(d, rst, clk)
    begin

	if (rst = '0') then
		q <= '0';
	elsif (clk='1' and clk'event) then
       	-- clock de subida
		q <= d;
	end if;

    end process;	

end behv;

----------------------------------------------
