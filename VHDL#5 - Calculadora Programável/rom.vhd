library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		clk: in std_logic;
		mem_read: in std_logic;
		mem_write: in std_logic;
		endereco_in: in unsigned (6 downto 0);
		instruction_out: out unsigned (18 downto 0)
	);
end entity;	

-- POR CAUSA DISSO O ENDERECO INICIAL COMECA NO 1 DA MEMORIA
architecture a_rom of rom is
	type mem is array (0 to 127) of unsigned(18 downto 0);
	constant conteudo_rom: mem := (
		0  => "1111111000000001001", -- Salta para o endereco 8
		1  => "0000001000000000000",
		2  => "1111111000000000000", -- Salta para o endereco 0
		3  => "0000000000000000001", 
		4  => "0000000000000000010", 
		5  => "0000000000000000011",
		6  => "1111111000000000111", -- Salta para o endereco 7
		7  => "0000000000000000100",
		8  => "0000000000000000101",
		9  => "1111111000000000011", -- Salta para o endereco 3, Loop quando chega no 7 e nao para mais
		10 => "0000000000000000110",
		others => (others => '0')
	);
	begin
		process(clk, mem_read)
		begin
			if(rising_edge(clk)) then
				if(mem_read = '0') then
					instruction_out <= conteudo_rom(to_integer(endereco_in));				
				end if;
			end if;
		end process;
	
end architecture;