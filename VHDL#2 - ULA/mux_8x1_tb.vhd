library ieee;
use ieee.std_logic_1164.all;

entity mux_8x1_tb is
end;

architecture a_mux_8x1_tb of mux_8x1_tb is
	component mux_8x1
		port(
			x0,x1,x2,x3,x4,x5,x6,x7 : in std_logic;
       		s0,s1,s2: in std_logic;
        	y0 : out std_logic
				);
		end component;
		signal x0,x1,x2,x3,x4,x5,x6,x7 : std_logic;
		signal s0,s1,s2 : std_logic;
		signal y0: std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : mux_8x1 port map(
		x0 => x0,
		x1 => x1,
		x2 => x2,
		x3 => x3,
		x4 => x4,
		x5 => x5,
		x6 => x6,
		x7 => x7,
		y0 => y0,
		s0 => s0,
		s1 => s1,
		s2 => s2
);

process
begin
-- ATIVAR Y0
	x0 <= '0';
	x1 <= '0';
    x5 <= '0';
    x3 <= '1';
    x7 <= '1';
    s0 <= '0';
    s1 <= '0';
    s2 <= '0';
	wait for 50 ns;
    s0 <= '0';
    s1 <= '0';
    s2 <= '1';
	wait for 50 ns;
    s0 <= '0';
    s1 <= '1';
    s2 <= '0';
	wait for 50 ns;
    s0 <= '0';
    s1 <= '1';
    s2 <= '1';
	wait for 50 ns;
    s0 <= '1';
    s1 <= '0';
    s2 <= '0';
	wait for 50 ns;
    s0 <= '1';
    s1 <= '0';
    s2 <= '1';
	wait for 50 ns;
    s0 <= '1';
    s1 <= '1';
    s2 <= '0';
	wait for 50 ns;
    s0 <= '1';
    s1 <= '1';
    s2 <= '1';
	wait for 50 ns;
	wait;
end process;
end architecture;