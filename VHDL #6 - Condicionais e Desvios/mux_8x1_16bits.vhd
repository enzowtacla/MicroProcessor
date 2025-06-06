library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1_16bits is
	port(
		entr0 : in signed(15 downto 0);
		entr1 : in signed(15 downto 0);
		entr2 : in signed(15 downto 0);
		entr3 : in signed(15 downto 0);
		entr4 : in signed(15 downto 0);
		entr5 : in signed(15 downto 0);
		entr6 : in signed(15 downto 0);
		entr7 : in signed(15 downto 0);
		sel : in unsigned(2 downto 0);
		saida : out signed(15 downto 0)
	);
end entity;

architecture a_mux_8x1_16bits of mux_8x1_16bits is 
begin 
	saida <= entr0 when sel = "000" else
			 entr1 when sel = "001" else
			 entr2 when sel = "010" else
			 entr3 when sel = "011" else
			 entr4 when sel = "100" else
			 entr5 when sel = "101" else
			 entr6 when sel = "110" else
			 entr7 when sel = "111" else
			 "0000000000000000";
end architecture;
		