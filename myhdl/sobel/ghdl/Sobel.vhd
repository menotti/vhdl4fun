--------------------------------------------------------------------------------
--- Sobel
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity Sobel is
port ( 
        iCLK: in std_logic;
        iRST_N: in std_logic;
        iTHRESHOLD: in std_logic_vector(7 downto 0);
        iDVAL: in std_logic;
        iDATA: in std_logic_vector(9 downto 0);
        oDATA: out std_logic_vector(9 downto 0)
         );
end Sobel;

architecture behv of Sobel is

-- máscaras
-- x
constant X1 : std_logic_vector (7 downto 0) := X"FF";
constant X2 : std_logic_vector (7 downto 0) := X"00";
constant X3 : std_logic_vector (7 downto 0) := X"01";
constant X4 : std_logic_vector (7 downto 0) := X"FE";
constant X5 : std_logic_vector (7 downto 0) := X"00";
constant X6 : std_logic_vector (7 downto 0) := X"02";
constant X7 : std_logic_vector (7 downto 0) := X"FF";
constant X8 : std_logic_vector (7 downto 0) := X"00";
constant X9 : std_logic_vector (7 downto 0) := X"01";

-- y

constant Y1 : std_logic_vector (7 downto 0) := X"01";
constant Y2 : std_logic_vector (7 downto 0) := X"02";
constant Y3 : std_logic_vector (7 downto 0) := X"01";
constant Y4 : std_logic_vector (7 downto 0) := X"00"; 
constant Y5 : std_logic_vector (7 downto 0) := X"00";
constant Y6 : std_logic_vector (7 downto 0) := X"00";
constant Y7 : std_logic_vector (7 downto 0) := X"FF";
constant Y8 : std_logic_vector (7 downto 0) := X"FE";
constant Y9 : std_logic_vector (7 downto 0) := X"FF";

-- conexões internas
-- saídas do buffer
signal Line0: std_logic_vector (7 downto 0);
signal Line1: std_logic_vector (7 downto 0);
signal Line2: std_logic_vector (7 downto 0);

-- saídas dos multiplicadores
signal Mac_x0: std_logic_vector (17 downto 0);
signal Mac_x1: std_logic_vector (17 downto 0);
signal Mac_x2: std_logic_vector (17 downto 0);
signal Mac_y0: std_logic_vector (17 downto 0);
signal Mac_y1: std_logic_vector (17 downto 0);
signal Mac_y2: std_logic_vector (17 downto 0);

-- saídas dos somadores paralelos
signal Pa_x: std_logic_vector (19 downto 0);
signal Pa_y: std_logic_vector (19 downto 0);

-- saída do sobel (tons de cinza)
signal Abs_mag: std_logic_vector (15 downto 0);


-- componentes
component LineBuffer_3
    port(clken, clock: in std_logic;
			shiftin: in std_logic_vector(7 downto 0);
         taps0x, taps1x, taps2x : out std_logic_vector(7 downto 0));
end component;

component MAC_3
    port(aclr0, clock0: in std_logic;
			dataa_0, datab_0, datab_1, datab_2: in std_logic_vector(7 downto 0);
         result : out std_logic_vector(17 downto 0));
end component;

component PA_3
    port(clock: in std_logic;
			data0x, data1x, data2x: in std_logic_vector(17 downto 0);
         result : out std_logic_vector(19 downto 0));
end component;

component SQRT
    port(clk: in std_logic;
			radical: in std_logic_vector(31 downto 0);
         q : out std_logic_vector(15 downto 0));
end component;

--------------------------------------------------------------------
-- lógica
--------------------------------------------------------------------
begin
--instanciações

-- buffer
b0 : LineBuffer_3 port map(
  clken => iDVAL,
  clock => iCLK,
  shiftin => iDATA(9 downto 2),
  taps0x => Line0,
  taps1x => Line1,
  taps2x => Line2
);

-- X
x_0 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line0,
  datab_0 => X9,
  datab_1 => X8,
  datab_2 => X7,
  result => Mac_x0
);

x_1 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line1,
  datab_0 => X6,
  datab_1 => X5,
  datab_2 => X4,
  result => Mac_x1
);

x_2 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line2,
  datab_0 => X3,
  datab_1 => X2,
  datab_2 => X1,
  result => Mac_x2
);

-- Y
y_0 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line0,
  datab_0 => Y9,
  datab_1 => Y8,
  datab_2 => Y7,
  result => Mac_y0
);

y_1 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line1,
  datab_0 => Y6,
  datab_1 => Y5,
  datab_2 => Y4,
  result => Mac_y1
);

y_2 : MAC_3 port map(
  aclr0 => not iRST_N,
  clock0 => iCLK,
  dataa_0 => Line2,
  datab_0 => Y3,
  datab_1 => Y2,
  datab_2 => Y1,
  result => Mac_y2
);

pa0 : PA_3 port map(
  clock => iCLK,
  data0x => Mac_x0,
  data1x => Mac_x1,
  data2x => Mac_x2,
  result => Pa_x
);

pa1 : PA_3 port map(
  clock => iCLK,
  data0x => Mac_y0,
  data1x => Mac_y1,
  data2x => Mac_y2,
  result => Pa_y
);

sqrt0 : SQRT port map(
  clk => iCLK,
  radical => std_logic_vector(resize(unsigned((Pa_x * Pa_x) + (Pa_y * Pa_y)), 32)),
  q => Abs_mag
);

process(iCLK)
begin
	if ( rising_edge(iCLK) ) then
		if (iDVAL /= '0') then
			oData <= std_logic_vector(resize(unsigned(Abs_mag), 10));
		else
			oData <= B"0000000000";
		end if;
	end if;
end process;
     
end behv;

