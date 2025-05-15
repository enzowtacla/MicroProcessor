library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai_tb is
end;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
	component soma_e_subtrai
		port(
				x,y : in unsigned(7 downto 0);
                soma, subt : out unsigned(7 downto 0);
                maior, x_negativo: out std_logic
				);
		end component;
		signal x,y : unsigned(7 downto 0);
		signal soma, subt : unsigned(7 downto 0);
        signal maior, x_negativo: std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : soma_e_subtrai port map(
		x => x,
		y => y,
		soma => soma,
		subt => subt,
	    maior => maior,
		x_negativo => x_negativo);

process
begin
-- ATIVAR Y0
	x <= "00000011";
	y <= "00000101";
	wait for 50 ns;
    x <= "01100100";
	y <= "01100100";
	wait for 50 ns;
    x <= "00010010";
	y <= "11111101";
	wait for 50 ns;

	wait;
end process;
end architecture;