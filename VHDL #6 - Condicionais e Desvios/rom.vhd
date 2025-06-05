library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- MOVOA: 0001010 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG
-- MOVA:  0001000 xxxxxxxxx  sss -- Move PARA O ACUMULADOR
-- MOV:   0001001 xxxxxx ddd sss -- Move de um reg para outro

-- NOP:   0000000 xxxxxxxxxxxx -- NAO FAZ NADA
-- JUMP:  1111111 xxxxx  ddddddd -- Salto incondicional
-- BLEA:  1111110 xxxxxxxxx ddd -- Branch se for menos QUE ou IGUAL
-- BMIA:  1111101 xxxxxxxxx ddd -- Branch se a flag de negativo = 1

-- ADD:   0000001 xxxxxx xxx sss -- Soma com o valor que está no acumulador e salva NO ACUMULADOR
-- SUB:   0000010 xxxxxx xxx sss -- Subtrai com o valor que está no acumulador e salva NO ACUMULADOR
-- ADDI:  0000011 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- SUBI:  0000100 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)

-- onde
-- ddd  = identifica o registrador destino
-- sss  = identifica o registrador fonte
-- cccc = constante
-- xxxx = é irrelevante

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
		0  => "0000011000000101011", -- ADDI reg3, 5 -- 302B
		1  => "0001010000000000011", -- MOVOA reg3 -- 
 		2  => "0000011000001000100", -- ADDI reg4, 8 -- 3044
		3  => "0001010000000000100", -- MOVOA reg4 --
		4  => "0001000000000000011", -- MOVA reg3 -- GUARDA O R3 no acumulador -- 8003
		5  => "0000001000000101100", -- ADD reg4 -- SOMA O VALOR que esta no acumulador com o reg4 E SALVA NO ACUMULADOR -- 102C
		6  => "0001010000000000101", -- MOVOA reg5 -- Move o valor do acumulador para R5 -- A005
		7  => "0000100000000001101", -- SUBI 1, reg5 -- 400D
		8  => "1111111000000010100", -- JUMP 0010100 -- Salta para o endereco 20 -- 7F014
		9  => "0000000000000000100", -- PULOU - 4
		10  => "0000000000000000101", -- PULOU - 5
		11  => "1111111000000000011", -- PULOU - 7F003
		12 => "0000011000000000101", -- ADDI reg5, 0 Nunca sera executada, supostamente deveria zerar mas acredito que vai apenas adicionar +0 no reg5 -- 3005
		13 => "0000000000000000000", -- NOP - Nao faz nada
		20 => "0001010000000000011", -- MOVOA reg3 -- A003
		21 => "1111111000000000100", -- JUMP 0000110 -- Salta para o endereco 2 -- 7F004
		22 => "0000011000000000011", -- ADDI reg3, 0 Nunca sera executada, supostamente deveria zerar mas acredito que vai apenas adicionar +0 no reg3 -- 3003
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
