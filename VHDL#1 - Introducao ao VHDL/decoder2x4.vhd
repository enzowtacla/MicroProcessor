library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is 
	port( 
		x0, x1: in std_logic;
		y0, y1, y2, y3 : out std_logic
		);
end entity;

architecture a_decoder2x4 of decoder2x4 is
begin
	y0 <= not x0  and not x1;
	y1 <= not x0 and x1;
	y2 <= x0 and not x1;
	y3 <= x1 and x0;
end architecture;