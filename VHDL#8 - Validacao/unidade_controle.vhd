library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port(
        clk : in std_logic;
        rst : in std_logic;
		opcode : in unsigned (6 downto 0);
		flagZero_in : in std_logic;
		flagNegativo_in : in std_logic;
		flagOverflow_in : in std_logic;
		estado_in : in unsigned (1 downto 0);
        rom_rd_en : out std_logic; -- FETCH     
		pc_wr_en : out std_logic; -- DECODE
        jump_en : out std_logic; -- SALTO INCONDICIONAL
		acumulador_wr_en: out std_logic;
		opULA : out unsigned (2 downto 0);
		useImm : out std_logic;
		bancoReg_wr_en : out std_logic;

		halted : out std_logic;
		ram_wr_en : out std_logic;
		ram_rd_en : out std_logic
		);
end entity;

architecture a_unidade_controle of unidade_controle is
	
	component reg1bits is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in std_logic;
			data_out : out std_logic
			);
	end component;

    signal flagNegativo_out, flagOverflow_out, flagZero_out, flag_wr_en: std_logic;

begin
	
	regFlagZero : reg1bits port map(		
		clk => clk,
		rst => rst,
		wr_en => flag_wr_en,
		data_in => flagZero_in,
		data_out => flagZero_out		
	);
	regFlagNegativo : reg1bits port map(		
		clk => clk,
		rst => rst,
		wr_en => flag_wr_en,
		data_in => flagNegativo_in,
		data_out => flagNegativo_out
	);
	regFlagOverflow : reg1bits port map(		
		clk => clk,
		rst => rst,
		wr_en => flag_wr_en,
		data_in => flagOverflow_in,
		data_out => flagOverflow_out
	);	  

	-- Operações ULA 

	opULA <= "000" when opcode="0000001" else -- ADD	
			 "000" when opcode="0000011" else -- ADDI
			 "001" when opcode="0000010" else -- SUB
			 "001" when opcode="0000100" else -- SUBI
			 "001" when opcode="0000101" else -- CMPI
			 "011" when opcode="0000110" else -- LDI
			 "010" when opcode="0001000" else -- MOVA			 
			 "011" when opcode="0001001" else -- MOVOA
			 "000" when opcode="1111101" else -- BLE
			 "000" when opcode="1111100" else -- BMI
			 "000" when opcode="1111011" else -- DJNZ
			 "011" when opcode="1111111" else -- JUMP
			 "011" when opcode="0001010" else -- LOAD
			 "011" when opcode="0001011" else -- STORE
			 "111" when opcode="1111110" else -- HALT
			 "111"; -- NOP

	-- Leitura da ROM - Fetch
    rom_rd_en <= '0' when estado_in="00" else
				 '1';

	-- Escrita do PC - Decode
    pc_wr_en <=  '1' when estado_in="01" else
				 '1' when opcode="1111111" and estado_in="10" else -- JUMP				 
				 '1' when opcode="1111101" and estado_in="10" and (flagZero_out='1' or ((flagNegativo_out xor flagOverflow_out)='1')) else --BLE
				 '1' when opcode="1111100" and estado_in="10" and (flagNegativo_out='1') else -- BMI
				 '1' when opcode="1111011" and estado_in="10" and flagZero_out='0' else -- DJNZ
				 '0';

	-- Execute 

	bancoReg_wr_en <= '1' when opcode="0001001" and estado_in="10"else -- MOVOA
					  '1' when opcode="0001010" and estado_in="10"else -- LOAD
					  '1' when opcode="0000110" and estado_in="10"else -- LDI
					  '0';
	
	useImm <= '1' when opcode="0000011" and estado_in="10" else -- ADDI
			  '1' when opcode="0000100" and estado_in="10" else -- SUBI
			  '1' when opcode="0000101" and estado_in="10" else -- CMPI
			  '1' when opcode="1111101" and estado_in="10" else -- BLE
			  '1' when opcode="1111100" and estado_in="10" else -- BMI
			  '1' when opcode="1111011" and estado_in="10" else -- DJNZ
			  '1' when opcode="1111111" and estado_in="10" else -- JUMP		
			  '1' when opcode="0000110" and estado_in="10" else -- LDI			  
			  '0';

	acumulador_wr_en <= '1' when opcode="0001000" and estado_in="10" else -- MOVA
						'1' when opcode="0000001" and estado_in="10" else -- ADD	
					    '1' when opcode="0000010" and estado_in="10"else -- SUB					   
					    '1' when opcode="0000011" and estado_in="10"else -- ADDI
					    '1' when opcode="0000100" and estado_in="10" else -- SUBI
						'1' when opcode="0001010" and estado_in="10" else -- LOAD
			  			'1' when opcode="0001011" and estado_in="10" else -- STORE
						'0';
	
	ram_wr_en <= '1' when opcode="0001011" and estado_in="10" else -- STORE
				 '0' ; 
	ram_rd_en <= '1' when opcode="0001010" and estado_in="10" else -- LOAD
				 '0';
	-- Salto Incondicional
	jump_en <=  '1' when opcode="1111111" and estado_in="10" else -- JUMP	
				'1' when opcode="1111101" and estado_in="10" and (flagZero_out='1' or ((flagNegativo_out xor flagOverflow_out)='1')) else --BLE
				'1' when opcode="1111100" and estado_in="10" and (flagNegativo_out='1') else -- BMI
				'1' when opcode="1111011" and estado_in="10" and flagZero_out='0' else -- DJNZ
                '0';
	
	flag_wr_en <= '1' when not(opcode="1111101" or opcode="1111100" or opcode="1111011") and estado_in="10" else '0';
	halted <= '1' when opcode="1111110" else
				'0';

end architecture;
