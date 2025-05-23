library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		clk: in std_logic;
		endereco_in: in unsigned (6 downto 0);
		instruction_out: out unsigned (18 downto 0)
	);
end entity;	

architecture a_rom of rom is
	type mem is array (0 to 127) of unsigned(18 downto 0);
	constant conteudo_rom: mem := (
		0  => "0000000000000000100",
		1  => "0000001000000000000",
		2  => "0001000000000000000",
		3  => "0000000000000000000",
		4  => "0000001000010000000",
		5  => "0000100000000000010",
		6  => "0000001111000000011",
		7  => "0000000000010000010",
		8  => "0000000000000000010",
		9  => "0100000000000000000",
		10 => "0000001010000000000",
		others => (others => '0')
	);
	begin
		process(clk)
		begin
			if(rising_edge(clk)) then
				instruction_out <= conteudo_rom(to_integer(endereco_in));
			end if;
		end process;
end architecture;