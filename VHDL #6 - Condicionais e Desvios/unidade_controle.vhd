library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port(
        clk : in std_logic;
        rst : in std_logic;
		opcode : in unsigned (6 downto 0);
		flagZero : in std_logic;
        flagResultNegativo : in std_logic;
        flagOverflow : in std_logic;
        rom_rd_en : out std_logic; -- FETCH     
		pc_wr_en : out std_logic; -- DECODE
        jump_en : out std_logic; -- SALTO INCONDICIONAL
		acumulador_wr_en: out std_logic;
		opULA : out unsigned (2 downto 0);
		useImm : out std_logic;
		bancoReg_wr_en : out std_logic
		);
end entity;

architecture a_unidade_controle of unidade_controle is
	
	component maq_estados is
		port(
		clk,rst: in std_logic;
		estado: out unsigned(1 downto 0)
		);
	end component;
	
    signal maq_estados_out : unsigned(1 downto 0);
begin
	
    maq_estds : maq_estados port map(
        clk => clk ,
		rst => rst,
		estado => maq_estados_out
    );

-- MSB b18               b0 LSB

-- MOVOA: 0001010 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG -- MOVE OUT ACUMULADOR
-- MOVA:  0001000 xxxxxxxxx  sss -- Move PARA O ACUMULADOR
-- MOV:   0001001 xxxxxx ddd sss -- Move de um reg para outro -- REMOVER DEPOIS

-- NOP:   0000000 xxxxxxxxxxxx -- NAO FAZ NADA
-- JUMP:  1111111 xxxxx  ddddddd -- Salto incondicional
-- BLE:   1111110 xxxxxxxxx ddd -- Branch se for menos QUE ou IGUAL
-- BMI:   1111101 xxxxxxxxx ddd -- Branch se a flag de negativo = 1

-- ADD:   0000001 xxxxxx xxx sss -- Soma com o valor que está no acumulador e salva NO ACUMULADOR
-- SUB:   0000010 xxxxxx xxx sss -- Subtrai com o valor que está no acumulador e salva NO ACUMULADOR
-- ADDI:  0000011 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- SUBI:  0000100 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)

-- onde
-- ddd  = identifica o registrador destino
-- sss  = identifica o registrador fonte
-- cccc = constante
-- xxxx = é irrelevante

	-- Operações ULA 

	opULA <= "000" when opcode="0000001" else -- ADD	
			 "000" when opcode="0000011" else -- ADDI
			 "001" when opcode="0000010" else -- SUB
			 "001" when opcode="0000100" else -- SUBI
			 "010" when opcode="0001000" else -- MOVA
			 "010" when opcode="0001001" else -- MOV
			 "011" when opcode="0001010" else -- MOVOA
			 "111"; -- NOP

	-- Leitura da ROM - Fetch
    rom_rd_en <= '0' when maq_estados_out="00" else
				 '1';

	-- Escrita do PC - Decode
    pc_wr_en <=  '1' when maq_estados_out="01" else
				 '0';

	-- Execute 

	bancoReg_wr_en <= '1' when opcode="0001001" and maq_estados_out="10"else -- MOV
					  '1' when opcode="0001010" and maq_estados_out="10"else -- MOVOA
					  '0';
	
	useImm <= '1' when opcode="0000011" and maq_estados_out="10" else -- ADDI
			  '1' when opcode="0000100" and maq_estados_out="10" else -- SUBI
			  '0';

	acumulador_wr_en <= '1' when opcode="0001000" and maq_estados_out="10" else -- MOVA
						'1' when opcode="0000001" and maq_estados_out="10" else -- ADD	
					    '1' when opcode="0000010" and maq_estados_out="10"else -- SUB					   
					    '1' when opcode="0000011" and maq_estados_out="10"else -- ADDI
					    '1' when opcode="0000100" and maq_estados_out="10" else -- SUBI
						'0';
	-- Salto Incondicional
	jump_en <=  '1' when opcode="1111111" and maq_estados_out="10" else -- JUMP
				'1' when opcode="1111101" and maq_estados_out="10" and flagResultNegativo='1' else -- BMI
				'1' when opcode="1111110" and maq_estados_out="10" and (flagZero='1' or (flagResultNegativo xor flagOverflow)='1') else --BLE
                '0';


end architecture;