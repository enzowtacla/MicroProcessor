library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is
	component ULA
		port(
			entra1, entra2 : in unsigned (15 downto 0);
        	sel0 : in unsigned (1 downto 0);
        	saida : out unsigned (15 downto 0);
        	flag0 : out std_logic
				);
		end component;
		signal entra1, entra2: unsigned(15 downto 0);
		signal saida : unsigned(15 downto 0);
		signal sel0 : unsigned(1 downto 0);
		signal flag0 : std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : ULA port map(
		entra1 => entra1,
		entra2 => entra2,
		saida => saida,
		flag0 => flag0,
		sel0 => sel0
		);

process
begin
-- ATIVAR Y0
	sel0 <= "00";
	entra1 <= "0000000000001010";
	entra2 <= "0000000000001010";
	wait for 50 ns;
	sel0 <= "01";	
	entra1 <= "0000000000011010";
	entra2 <= "0000000000001010";
	wait for 50 ns;
	wait;
end process;
end architecture;