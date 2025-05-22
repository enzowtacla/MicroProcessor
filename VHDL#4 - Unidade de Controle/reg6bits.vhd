library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg6bits is
	port(
		clk : in std_logic;
		rst : in std_logic;
		wr_en : in std_logic;
		data_in : in std_logic;
		data_out : out std_logic
		);
end entity;

architecture a_reg6bits of reg6bits is
	signal registro: std_logic;
begin
	process (clk, rst, wr_en) -- acionado se houver mudança em clk, rst ou wr_en
	begin
		if rst = '1' then
			registro <= '0000000';
		elsif wr_en = '1' then
			if rising_edge(clk) then
				registro <= data_in;
			end if;
		end if;
	end process;
	data_out <= registro; -- Conexao direta, fora do processo
end architecture;