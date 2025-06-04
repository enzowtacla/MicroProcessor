library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- MOVA:  0001000 xxxxxxxxx  sss -- Move PARA O ACUMULADOR
-- MOV:   0001001 xxxxxx ddd sss -- Move de um reg para outro

-- NOP:   0000000 xxxxxxxxxxxx -- NÃO FAZ NADA
-- JUMP:  1111111 xxxxx  ddddddd -- Salto incondicional
-- BLEA:  1111110 xxxxxxxxx ddd -- Branch se for menos QUE ou IGUAL
-- BMIA:  1111101 xxxxxxxxx ddd -- Branch se a flag de negativo = 1

-- ADD:   0000001 xxxxxx ddd sss -- Soma com o valor que está no acumulador e salva em um reg no banco de regs
-- SUB:   0000010 xxxxxx ddd sss -- Subtrai com o valor que está no acumulador e salva em um reg no banco de regs
-- ADDI:  0000011 ccccccccc ddd -- Soma com uma constante(entra2) com valor no reg(entra1)
-- SUBI:  0000100 ccccccccc ddd -- Soma com uma constante(entra2) com valor no reg(entra1)

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
		0  => "0000000000000000000", -- Nao faz nada, por algum motivo esta sendo pulado no inicio da simulacao, talvez seja o reset?
		1  => "0000011000000101011", -- ADDI reg3, 5 -- 302B
		2  => "0000011000001000100", -- ADDI reg4, 8 -- 3044
		3  => "0001000000000000011", -- MOVA reg3 -- GUARDA O R3 no acumulador -- 8003
		4  => "0000001000000101100", -- ADD reg4 -- SOMA O VALOR que esta no acumulador com o reg4 e salva o resultado no reg5 -- 102C
		5  => "0000100000000001101", -- SUBI reg5, 1 -- 400D
		6  => "1111111000000010100", -- JUMP 0010100 -- Salta para o endereco 20 -- 7F014
		7  => "0000000000000000100", -- PULOU - 4
		8  => "0000000000000000101", -- PULOU - 5
		9  => "1111111000000000011", -- PULOU - 7F003
		10 => "0000000000000000110", -- PULOU - 6 
		20 => "0001001000000011101", -- MOV reg5, reg3 -- 901D
		21 => "1111111000000000011", -- JUMP 0000011 -- Salta para o endereco 3 -- 7F003
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
