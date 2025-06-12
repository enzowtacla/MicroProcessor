library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- MOVOA: 0001010 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG
-- MOVA:  0001000 xxxxxxxxx  sss -- Move o valor de um REG PARA O ACUMULADOR
-- MOV:   0001001 xxxxxx ddd sss -- Move de um reg para outro

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
		0  => "0000011000000000011", -- ADDI 0, reg3 -- 03003 A -- Soma 0 com 0 do reg3 (previamente resetado no tb com o rst)
		1  => "0001010000000000011", -- MOVOA reg3 -- 0A003 A -- Move o resultado guardado no acumulador para o reg3
 		2  => "0000011000000000100", -- ADDI 0, reg4 -- 03004 B -- Soma 0 com 0 do reg4
		3  => "0001010000000000100", -- MOVOA reg4 -- 0A004 -- Move o resultado guardado no acumulador para o reg4
		4  => "0001000000000000100", -- MOVA reg4 -- 08004 Move o valor de reg4 para o acumulador
		5  => "0000001000000000011", -- ADD reg3 -- 01003 C -- soma o valor de reg3 com o reg4 que esta no acumulador
		6  => "0001010000000000100", -- MOVOA reg4 -- 0A004 -- Move o resultado da soma anterior guardado no acumulador para reg4
		7  => "0000011000000001011", -- ADDI 1, reg3 -- 0300B D -- Soma 1 com o reg3 e guarda no acumulador
		8  => "0001010000000000011", -- MOVOA reg3 -- 0A003 D -- Move o resultado da soma anterior guardado no acumulador para reg3
		9  => "0000101000011110011", -- CMPI 30,reg3 -- 050F3 E -- Compara o valor 30 com o valor do reg3 para ativar flags de branch
		10 => "1111110000000000100", -- BLE 4 (instr4) -- 7E004 Pula para a instrucao 4 da ROM caso as flag do CMPI permitirem
		11 => "0001001000000101100", -- MOV reg5,reg4 -- 0902C F -- Move o valor de reg4 para reg 5
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
