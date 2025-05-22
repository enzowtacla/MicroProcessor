library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop_t is
	port(
		clk : in std_logic;
		rst : in std_logic;
		data_out : out std_logic
		);
end entity;

architecture a_flip_flop_t of flip_flop_t is
	signal estado: std_logic;
begin
	process (clk, rst) -- acionado se houver mudança em clk, rst ou wr_en
	begin
		if rst = '1' then
			estado <= '0';
		elsif rising_edge(clk) then
			estado <= not estado;
		end if;
	end process;
	data_out <= estado; -- Conexao direta, fora do processo
end architecture;