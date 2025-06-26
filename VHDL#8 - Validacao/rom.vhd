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
		--LOOP PARA ADICIONAR VALORES NA RAM--
		0  => "0000011000000010001", -- ADDI 2, reg1 -- HEX: 3011
		1  => "0001001000000000001", -- MOVOA reg1 -- HEX: 9001
		2  => "0001011000000000001", -- STORE reg1 -- HEX: B001
		3  => "0000011000000001001", -- ADDI 1, reg1 -- HEX: 3009
		4  => "0001001000000000001", -- MOVOA reg1 -- HEX: 9001
		5  => "0001011000000000001", -- STORE reg1 -- HEX: B001
		6  => "0000101000100000001", -- CMPI 32, reg1 -- HEX: 5101
		7  => "1111101000001111100", -- BLE -4 -- HEX: 7D07C
		8  => "0000000000000000000", -- NOP
		9  => "0000000000000000000", -- NOP
		10 => "0000000000000000000", -- NOP
		--LOOP PARA RETIRAR OS PARES DA RAM--
		11 => "0001001000000000010", -- MOVOA reg2 -- HEX: 9002 -- move o valor 33 no reg2 
		12 => "0000110000100010011", -- LDI 34, reg3 -- HEX: 6013
		13 => "0000100000000010011", -- SUBI 2, reg3 -- HEX: 4013
		14 => "0001001000000000011", -- MOVOA reg3 -- HEX: 9003
		-- Esse ponto o acumulador vai ter como resposta 4+n que sera utilizado para remover os pares da RAM
		15 => "0001011000000000000", -- STORE reg0 -- HEX: B000
		16 => "0000101000000100011", -- CMPI 4, reg3 -- HEX: 5013 
		17 => "1111011000001111100", -- DJNZ -4 -- HEX: 7B07C
		18 => "0000000000000000000", -- NOP
		19 => "0000000000000000000", -- NOP
		20 => "0000000000000000000", -- NOP
		-- LOOP PARA RETIRAR OS MULT DE 3
		21 => "0001000000000000010", -- MOVA reg2 -- HEX: 8002
		22 => "0001011000000000000", -- STORE reg0 -- HEX: B000
		23 => "0001001000000000011", -- MOVOA reg3 -- HEX: 9003
		24 => "0000100000000011011", -- SUBI 3, reg3 -- HEX: 401B
		25 => "0001001000000000011", -- MOVOA reg3 -- HEX: 9003
		26 => "0001011000000000000", -- STORE reg0 -- HEX: B000
		27 => "0000101000000110011", -- CMPI 6, reg3 -- HEX: 501B
		28 => "1111011000001111100", -- DJNZ -4 -- HEX: 7B07C
		29  => "0000000000000000000", -- NOP
		30  => "0000000000000000000", -- NOP
		31 => "0000000000000000000", -- NOP
		-- LOOP PARA RETIRAR OS MULT DE 5
		32 => "0000110000000101011", -- LDI 5 reg3 -- HEX: 602B
		33 => "0000011000000101011", -- ADDI 5, reg3 -- HEX: 302B
		34 => "0001001000000000011", -- MOVOA reg3 -- HEX: 9003
		35 => "0001011000000000000", -- STORE reg0 -- HEX: B000
		36 => "0000101000100001011", -- CMPI 33, reg3 -- HEX: 510B
		37 => "1111101000001111100", -- BLE -4 -- HEX: 7D07C
		38 => "0000000000000000000", -- NOP
		39  => "0000000000000000000", -- NOP
		40 => "0000000000000000000", -- NOP
		-- LOOP PARA RETIRAR OS MULT DE 7
		41 => "0000110000000111011", -- LDI 7 reg3 -- HEX: 603B
		42 => "0000011000000111011", -- ADDI 7, reg3 -- HEX: 303B
		43 => "0001001000000000011", -- MOVOA reg3 -- HEX: 9003
		44 => "0001011000000000000", -- STORE reg0 -- HEX: B000
		45 => "0000101000100001011", -- CMPI 33, reg3 -- HEX: 510B
		46 => "1111101000001111100", -- BLE -4 -- HEX: 7D07C
		47 => "1111110000000000000", -- HALT -- HEX: 7E000
		-- => "", -- -- HEX:0000100000000010011
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
