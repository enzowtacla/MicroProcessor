library ieee;
use ieee.std_logic_1164.all;

entity portas_tb is
end;

architecture a_portas_tb of portas_tb is
	component portas
		port(
				x0, x1, x2, x3 : in std_logic;
				y0, y1, y2, y3 : out std_logic
				);
		end component;
		signal x0, x1, x2, x3: std_logic;
		signal y0, y1, y2, y3: std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : portas port map(
		x0 => x0,
		x1 => x1,
		x2 => x2,
		x3 => x3,
		y0 => y0,
		y1 => y1,
		y2 => y2,
		y3 => y3);

process
begin
	x3 <= '0';
	wait for 50 ns;
	x3 <= '1';
	wait for 50 ns;
	x2 <= '1';
	wait for 50 ns;
	x1 <= '1';
	wait for 50 ns;
	x0 <= '1';
	wait for 50 ns;
	wait;
end process;
end architecture;