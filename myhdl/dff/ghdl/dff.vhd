-- flip-flop d
library ieee;
use ieee.std_logic_1164.all;
use work.all;

---------------------------------------------
-- declarações

entity dff is
port(	d: in std_logic;
	clk: in std_logic;
	q: out std_logic := '0' ---- valor padrão se não for atribuído (X)
);
end dff;

----------------------------------------------

architecture behv of dff is

begin

    process(d, clk)
    begin

        -- clock de subida

	if (clk='1' and clk'event) then
	    q <= d;
	end if;

    end process;	

end behv;

----------------------------------------------
