library ieee;
use ieee.std_logic_1164.all;

entity portas is 
	port( 
		x0, x1, x2, x3 : in std_logic;
		y0, y1, y2, y3 : out std_logic
		);
end entity;

architecture a_portas of portas is
begin
	y0 <= x0 and not x1 and not x2 and not x3;
	y1 <= x1 and not x2 and not x3;
	y2 <= x2 and not x3;
	y3 <= x3;
end architecture;