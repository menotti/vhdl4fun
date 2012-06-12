---- Sobel ----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sobel is
port ( 
        clock: in std_logic;
        pin: in signed(9 downto 0);
        pout: out signed(9 downto 0);
		control: in std_logic
         );
end Sobel;

architecture behv of Sobel is

	signal r00, r01, r02, r10, r11, r12, r20, r21, r22: signed (7 downto 0);

	type arr_row0 is array (0 to 796) of signed(7 downto 0);
	type arr_row1 is array (0 to 796) of signed(7 downto 0);
	
	signal row0 : arr_row0;
	signal row1 : arr_row1;

	signal H, V: signed (11 downto 0);

	signal H1, V1: signed (11 downto 0);

	signal i: integer;

	---- logica -----
	begin

		process(clock)
		begin
			if ( rising_edge(clock) ) then
				if (control = '1') then
					r00 <= r01;
					r01 <= r02;
					r02 <= row0(0);
				
					for i in 0 to 795 loop
						row0(i) <= row0(i+1);
					end loop;
				
					row0(796) <= r10;
					r10 <= r11;
					r11 <= r12;
					r12 <= row1(0);
				
					for i in 0 to 795 loop
						row1(i) <= row1(i+1);
					end loop;
				
					row1(796) <= r20;
				
					r20 <= r21;
					r21 <= r22;
					r22 <= pin(9 downto 2); 				
				end if;
			end if;
		end process;
		
		process(clock)
		begin
			if ( rising_edge(clock) ) then
			
				H <= resize(-r00 + r02 - (r10 sll 2) + (r12 sll 2) - r20 + r22, 12);
				V <= resize(-r00 - (r01 sll 2) - r02 + r20 + (r21 sll 2) + r22, 12);

				if ( H(11) = '1' ) then
					H1 <= -H;
				else
					H1 <= H;
				end if;

				if ( V(11) = '1' ) then
					V1 <= -V;
				else
					V1 <= V;
				end if;		
			end if;
		end process;

		process(clock)
		begin
			if ( rising_edge(clock) ) then
				if (control = '1') then
					pout <= resize((H1 + V1), 10);	
				else
					pout <= "0000000000";
				end if;
					
			end if;
		end process;
     
	end behv;
