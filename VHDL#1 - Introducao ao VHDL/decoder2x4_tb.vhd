library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4_tb is
end;

architecture a_decoder2x4_tb of decoder2x4_tb is
	component decoder2x4
		port(
				x0, x1 : in std_logic;
				y0, y1, y2, y3 : out std_logic
				);
		end component;
		signal x0, x1: std_logic;
		signal y0, y1, y2, y3: std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : decoder2x4 port map(
		x0 => x0,
		x1 => x1,
		y0 => y0,
		y1 => y1,
		y2 => y2,
		y3 => y3);

process
begin
-- ATIVAR Y0
	x0 <= '0';
	x1 <= '0';
	wait for 50 ns;
-- ATIVAR Y1
	x0 <= '1';
	x1 <= '0';
	wait for 50 ns;
-- ATIVAR Y2
	x0 <= '0';
	x1 <= '1';
	wait for 50 ns;
-- ATIVAR Y3
	x0 <= '1';
	x1 <= '1';
	wait for 50 ns;
	wait;
end process;
end architecture;