library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- MOVOA: 0001010 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG
-- MOVA:  0001000 xxxxxxxxx  sss -- Move PARA O ACUMULADOR
-- MOV:   0001001 xxxxxx ddd sss -- Move de um reg para outro

-- CMPI:  1000001 ccccccccc  sss -- Compara constante e registrador

-- NOP:   0000000 xxxxxxxxxxxx -- NAO FAZ NADA
-- JUMP:  1111111 xxxxx ddddddd -- Salto incondicional
-- BLE:  1111110 xxxxx ddddddd -- Branch se for menos QUE ou IGUAL
-- BMI:  1111101 xxxxx ddddddd -- Branch se a flag de negativo = 1

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
		0  => "0000011000000000011", -- ADDI 0, reg3 -- 3003 A
		1  => "0001010000000000011", -- MOVOA reg3 -- A003 A
 		2  => "0000011000000000100", -- ADDI 0, reg4 -- 3004 B
		3  => "0001010000000000100", -- MOVOA reg4 -- A004 -- nesse momento o valor de reg4 está também no acumulador B
		4  => "0000001000000000011", -- ADD reg3 -- 1003 C
		5  => "0001010000000000100", -- MOVOA reg4 -- A004 -- r3 + r4 guardado em r4 C
		6  => "0000011000000001011", -- ADDI 1, reg3 -- 300B D
		7  => "0001010000000000011", -- MOVOA reg3 -- A003 D
		8  => "1000001000011110011", -- CMPI 30,reg3 -- 410F3 E
		9  => "1111110000000000100", -- BLE reg3,30,instr4 -- 7E004 E
		10 => "0001001000000101100", -- MOV reg5,reg4 -- 902C F
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
