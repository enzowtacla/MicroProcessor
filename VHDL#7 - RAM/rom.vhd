library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- ACESSO A RAM:
-- Para acessar o endereco da ram e necessario usar o MOVA para mover o valor do endereco para o acumulador para ser lido
-- Pois foi uma das solucoes encontradas para evitar o problema da RAM ler o endereco e ao mesmo tempo estar recebendo o mesmo valor do endereco para ser escrito ou lido com LOAD/STORE

-- LOAD  regD :  0001010 xxxxxxxxx ddd -- Carrega o valor guardado no endereco da RAM no regD utilizando o valor do endereco no acumulador
-- STORE regS :  0001011 xxxxxxxxx sss -- Guarda o valor que esta no regS no endereco da RAM utilizando o valor do endereco no acumulador

-- MOVOA: 0001001 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG
-- MOVA:  0001000 xxxxxxxxx  sss -- Move o valor de um REG PARA O ACUMULADOR

-- NOP:   0000000 xxxxxxxxxxxx -- NAO FAZ NADA
-- JUMP:  1111111 xxxxx ddddddd -- Salto incondicional
-- BLE:   1111110 xxxxx ddddddd -- Branch se for menos QUE ou IGUAL
-- BMI:   1111101 xxxxx ddddddd -- Branch se a flag de negativo = 1

-- ADD:   0000001 xxxxxx xxx sss -- Soma com o valor que está no acumulador e salva NO ACUMULADOR
-- SUB:   0000010 xxxxxx xxx sss -- Subtrai com o valor que está no acumulador e salva NO ACUMULADOR
-- ADDI:  0000011 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- SUBI:  0000100 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- CMPI:  0000101 ccccccccc sss -- Faz uma subtracao de ccccccccc - reg(sss) e envia o resultado das flags para a unidade de controle

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
		0  => "0000011000000010000", -- ADDI 2, reg0 -- HEX: 3010 -- Soma 2 com 0 do reg0
		1  => "0001001000000000001", -- MOVOA reg1 -- HEX: 3001 -- Move o resultado no acum. para o reg1, REG1: vai ser usada para dar valores aleatorios
		2  => "0000011000001101000", -- ADDI 13, reg0 -- 3068
		3  => "0001001000000000010", -- MOVOA reg2 -- 9002
		4  => "0000011000010001000", -- ADDI 17, reg0 -- 3088
		5  => "0001001000000000011", -- MOVOA reg3 -- 9003
		6  => "0000011000010110000", -- ADDI 22, reg0 -- 30B0
		7  => "0001001000000000100", -- MOVOA reg4 -- 9004
		8  => "0000011000011001000", -- ADDI 25, reg0 -- 30C8
		9  => "0001001000000000101", -- MOVOA reg5 -- 9005
		10 => "0000011000100001000", -- ADDI 33, reg0 -- 3108
		11 => "0001001000000000110", -- MOVOA reg6 -- 9006
		12 => "0000011000110110000", -- ADDI 54, reg0 -- 31B0
		13 => "0001001000000000111", -- MOVOA reg7 -- 9007
		14 => "0001000000000000010", -- MOVA  reg2 -- 8002 -- Move o valor em reg2 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		15 => "0001011000000000011", -- STORE reg3 -- B003 -- Guarda o valor 17 no endereco 13 da RAM
		16 => "0001000000000000011", -- MOVA  reg3 -- 8003 -- Move o valor em reg3 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		17 => "0001011000000000100", -- STORE reg4 -- B004 -- Guarda o valor 22 no endereco 17 da RAM
		18 => "0001000000000000101", -- MOVA  reg5 -- 8005 -- Move o valor em reg5 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		19 => "0001011000000000100", -- STORE reg4 -- B004 -- Guarda o valor 22 no endereco 25 da RAM
		20 => "0001000000000000110", -- MOVA  reg6 -- 8006 -- Move o valor em reg6 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		21 => "0001011000000000111", -- STORE reg7 -- B007 -- Guarda o valor 54 no endereco 33 da RAM
		22 => "0001000000000000110", -- MOVA  reg6 -- 8006 -- Move o valor em reg6 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		23 => "0001011000000000101", -- STORE reg5 -- B005 -- Guarda o valor 25 no endereco 33 da RAM
		24 => "0001000000000000010", -- MOVA  reg2 -- 8002 -- Move o valor em reg2 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		25 => "0001010000000000001", -- LOAD  reg1 -- A001 -- Carrega o valor 17 no endereco 13 no reg1 
		26 => "0001000000000000110", -- MOVA  reg6 -- 8006 -- Move o valor em reg6 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		27 => "0001010000000000011", -- LOAD  reg3 -- A003 -- Carrega o valor 54 no endereco 33 no reg3
		28 => "0001000000000000111", -- MOVA  reg7 -- 8007 -- NAO TEM NADA GUARDADO EM 54
		29 => "0001010000000000010", -- LOAD  reg2 -- A002 -- Carrega o valor 25 no endereco 54 no reg2
		30 => "0001000000000000011", -- MOVA  reg3 -- 8003 -- Move o valor em reg3 para o acumulador para ser o valor do endereco ser lido no endereco da RAM
		31 => "0001010000000000101", -- LOAD  reg5 -- A005 -- Carrega o valor 54 no endereco 17 no reg5
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
