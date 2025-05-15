library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder3x8 is 
	port(
		wr_reg : in unsigned(2 downto 0);
		wr_en : in std_logic;
		saida : out unsigned(7 downto 0)
	);
end entity;

architecture a_decoder3x8 of decoder3x8 is
begin
	saida <= "00000001" when wr_reg = "000" and wr_en = '1' else
			 "00000010" when wr_reg = "001" and wr_en = '1' else
			 "00000100" when wr_reg = "010" and wr_en = '1' else
			 "00001000" when wr_reg = "011" and wr_en = '1' else
			 "00010000" when wr_reg = "100" and wr_en = '1' else
			 "00100000" when wr_reg = "101" and wr_en = '1' else
			 "01000000" when wr_reg = "110" and wr_en = '1' else
			 "10000000" when wr_reg = "111" and wr_en = '1' else
			 "00000000";
end architecture