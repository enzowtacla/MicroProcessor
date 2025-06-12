library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_3x8_3bits is 
	port(
		selDec : in unsigned(2 downto 0);
		wr_en : in std_logic;
		saida : out unsigned(7 downto 0)
	);
end entity;

architecture a_decoder_3x8_3bits of decoder_3x8_3bits is
begin
	saida <= "00000001" when selDec = "000" and wr_en = '1' else
			 "00000010" when selDec = "001" and wr_en = '1' else
			 "00000100" when selDec = "010" and wr_en = '1' else
			 "00001000" when selDec = "011" and wr_en = '1' else
			 "00010000" when selDec = "100" and wr_en = '1' else
			 "00100000" when selDec = "101" and wr_en = '1' else
			 "01000000" when selDec = "110" and wr_en = '1' else
			 "10000000" when selDec = "111" and wr_en = '1' else
			 "00000000";
end architecture;