library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MSB b18               b0 LSB

-- ACESSO A RAM:
-- Para acessar o endereco da ram e necessario usar o MOVA para mover o valor do endereco para o acumulador para ser lido
-- Pois foi uma das solucoes encontradas para evitar o problema da RAM ler o endereco e ao mesmo tempo estar recebendo o mesmo valor do endereco para ser escrito ou lido com LOAD/STORE

-- LOAD:   0001010 xxxxxxxxx ddd -- LOAD reg Carrega o valor guardado no endereco da RAM no regD utilizando o valor do endereco no acumulador
-- STORE:  0001011 xxxxxxxxx sss -- Guarda o valor que esta no regS no endereco da RAM utilizando o valor do endereco no acumulador

-- MOVOA:  0001001 xxxxxxxxx  ddd -- Move do ACUMULADOR para um REG
-- MOVA:   0001000 xxxxxxxxx  sss -- Move o valor de um REG PARA O ACUMULADOR

-- NOP:    0000000 xxxxxxxxxxxx -- NAO FAZ NADA
-- JUMP:   1111111 xxxxx ddddddd -- Salto incondicional
-- HALT:   1111110 xxxxxxxxxxxx -- Trava o microprocessador e levanta a flag
-- BLE:    1111101 xxxxx ddddddd -- Branch se for menos QUE ou IGUAL 
-- BMI:    1111100 xxxxx ddddddd -- Branch se a flag de negativo = 1
-- DJNZ:   1111011 xxxxx ddddddd -- Branch se a flag de zero = 0

-- ADD:    0000001 xxxxxx xxx sss -- Soma com o valor que está no acumulador e salva NO ACUMULADOR
-- SUB:    0000010 xxxxxx xxx sss -- Subtrai com o valor que está no acumulador e salva NO ACUMULADOR
-- ADDI:   0000011 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- SUBI:   0000100 ccccccccc sss -- Soma com uma constante(entra2) com valor no reg(entra1)
-- CMPI:   0000101 ccccccccc sss -- Faz uma subtracao de reg(sss) - ccccccccc e envia o resultado das flags para a unidade de controle
-- LDI:    0000110 ccccccccc ddd -- Carrega diretamente um valor no registrador ddd

-- onde
-- ddd  = identifica o registrador destino
-- sss  = identifica o registrador fonte
-- cccc = constante
-- xxxx = é irrelevante


-- Instruções OBRIGATORIAS a serem usadas na sua validacao:
-- {'Acumulador ou nao': 'ULA com acumulador',
--  'Largura da ROM / instrução em bits': [19],
--  'Numero de registradores no banco': [8],
--  'ADD ops': 'ADD com dois operandos apenas',
--  'Carga de constantes': 'Carrega diretamente com LD sem somar',
--  'SUB ops': 'Subtracao com dois operandos apenas',
--  'ADD ctes': 'Há instrucao ADDI que soma com constante',
--  'SUB ctes': 'Há instrucao que subtrai uma constante',
--  'Subtração': 'Subtração com SUB sem borrow',
--  'Comparacoes': 'Comparacao apenas com CMPI',
--  'Saltos condicionais': ['BLE', 'BMI'],
--  'Saltos': 'Incondicional e absoluto e condicional e relativo',
--  'Validacao -- final do loop': 'Loop com DJNZ',
--  'Validacao -- complicacoes': 'Instrucao Halt ao final'}

entity micro_processador is
	port(
		clk_global : in std_logic;
		rst : in std_logic;
		halted: out std_logic;
		state: out unsigned (1 downto 0);
		saidaPC: out unsigned (6 downto 0);
        saidaROM: out unsigned (18 downto 0);
		saidaReg1, saidaAcumulador, saidaULA, saidaRAM: out unsigned (15 downto 0)
		);
end entity;

architecture a_micro_processador of micro_processador is
	
	component maq_estados is
		port( 
		clk,rst: in std_logic;
      	estado: out unsigned(1 downto 0)
  	);
	end component;

    component pc is
        port(
		clk : in std_logic;
		rst : in std_logic;
		wr_en : in std_logic;
		data_in : in unsigned (6 downto 0);
		data_out : out unsigned (6 downto 0)
		);
    end component;
	
    component soma_pc is
        port(		
		data_in : in unsigned (6 downto 0);
		data_out : out  unsigned (6 downto 0)
		);
    end component;

    component rom is
        port(
		    clk: in std_logic;
			mem_read: in std_logic;
			mem_write: in std_logic;
		    endereco_in: in unsigned (6 downto 0);
		    instruction_out: out unsigned (18 downto 0)
	    );
    end component;

	component ram is
		port( 
			clk      : in std_logic;
			endereco : in unsigned(6 downto 0);
			wr_en    : in std_logic;
			dado_in  : in unsigned(15 downto 0);
			dado_out : out unsigned(15 downto 0) 
		);
	end component;

	component unidade_controle is
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
	end component;

	component mux_2x1_7bits is
		port(
        	x0,x1 : in unsigned (6 downto 0);
        	s0: in std_logic;
        	y0 : out unsigned (6 downto 0)
    	);
	end component;
	
	component mux_2x1_16bits is
		port(
			x0, x1 : in unsigned(15 downto 0);
			sel: in std_logic;
			y0 : out unsigned (15 downto 0)        
		);
	end component;

	component mux_2x1_3bits is
		port(
        	x0,x1 : in unsigned (2 downto 0);
        	s0: in std_logic;
        	y0 : out unsigned (2 downto 0)
    );
	end component;

	component mux_2x1_1bits is
		port(
        	x0,x1 : in std_logic;
        	s0: in std_logic;
        	y0 : out std_logic
    );
	end component;

	component ULA is
		port(
			entra1, entra2 : in unsigned (15 downto 0);
			sel0 : in unsigned (2 downto 0);
			saida : out unsigned (15 downto 0);
			flagZero : out std_logic;
			flagNegativo : out std_logic;
			flagOverflow : out std_logic
    );
	end component;

	component banco_reg16bits is
		port(			
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			readSel : IN unsigned(2 DOWNTO 0);
			writeSel : IN unsigned(2 DOWNTO 0);
			wr_en : IN STD_LOGIC;
			read_data1 : OUT unsigned(15 DOWNTO 0);
			write_data : IN unsigned(15 DOWNTO 0)
		);
	end component;

	component reg16bits is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out : out unsigned(15 downto 0)
		);
	end component;

    signal clk, uc_rom_rd_out, uc_pc_wr_out,  uc_useImm_out, uc_bancoReg_wr_out, uc_acumulador_wr_out, uc_ram_wr_out, uc_ram_rd_out, uc_bancoRam_out : std_logic;
	signal uc_jump_out, flagNegativo_out, flagZero_out, flagOverflow_out, uc_flagHalt_out, clk_out: std_logic;
	
	signal opcode, addres_mux_out, pc_data_out, soma_pc_out  : unsigned (6 downto 0);
    signal rom_instructions : unsigned (18 downto 0);
	signal write_data_out, muxImm_out, immJump_in, muxImmJump_out, read_data1_out, read_data2_out, imm_in, entra1_mux_out, pc_data16bit_out, ram_data_out, banco_writedata_mux_out: unsigned (15 downto 0);
	signal opULA_out, selRegDestino_out, sel_wr_BancoReg_out, sel_rd_BancoReg_out, muxSel_wr_BancoReg_out,muxSel_rd_BancoReg_out: unsigned (2 downto 0);
	signal state_out: unsigned(1 downto 0);
	
begin
	-- Pinos TOP LEVEL para VHDL#5
	
	clk <= clk_out;
	state <= state_out;
	saidaPC <= pc_data_out;
	saidaROM <= rom_instructions;
	saidaReg1 <= read_data1_out;
	saidaAcumulador <= read_data2_out;
	saidaULA <= write_data_out;
	saidaRAM <= ram_data_out;	
	halted <= uc_flagHalt_out;

	opcode <= rom_instructions (18 downto 12);
	
	-- Pega o endereco para onde deve pular APENAS quando o jump='1'
	
	imm_in <= unsigned("0000000" & rom_instructions(11 downto 3));	
	immJump_in <= unsigned("000000000" & rom_instructions(6 downto 0));
	
    sel_rd_BancoReg_out <= rom_instructions (2 downto 0);
	sel_wr_BancoReg_out <= rom_instructions (2 downto 0);

	maq_estados0 : maq_estados port map(
		clk => clk_global,
		rst=> rst,
      	estado => state_out
    );
	
	clk_mux: mux_2x1_1bits port map(
		x0 => clk_global,
		x1 => '0', 
        s0 => uc_flagHalt_out, 
        y0 => clk_out
	);

	pc0 : pc port map(
		clk => clk_out,
		rst => rst,
		wr_en =>  uc_pc_wr_out,
		data_in => addres_mux_out,
		data_out => pc_data_out		
    );
	
    somapc : soma_pc port map(
        data_in => pc_data_out,
		data_out => soma_pc_out
    );

    rom0 : rom port map(
        clk => clk_out,
		mem_read => uc_rom_rd_out,
		mem_write => uc_rom_rd_out,
		endereco_in => soma_pc_out,
		instruction_out => rom_instructions
    );

	ram0: ram port map( 
		clk => clk_out,
		endereco => write_data_out (6 downto 0), -- Valor recebido da ULA em 010 que e a operacao de repassar o que esta no entra1, nesse caso eh o read_data1_out
		wr_en => uc_ram_wr_out,
		dado_in => read_data1_out,
		dado_out => ram_data_out
	);

	uc : unidade_controle port map(		
        clk => clk_out,
        rst => rst,
		opcode => opcode, 
		estado_in => state_out,
		rom_rd_en => uc_rom_rd_out,
        pc_wr_en => uc_pc_wr_out,		
		acumulador_wr_en => uc_acumulador_wr_out ,
		opULA => opULA_out,
		useImm => uc_useImm_out,
		bancoReg_wr_en => uc_bancoReg_wr_out,

		jump_en => uc_jump_out,
		flagZero_in => flagZero_out ,
		flagNegativo_in => flagNegativo_out,
		flagOverflow_in => flagOverflow_out,
		halted => uc_flagHalt_out,

		ram_wr_en => uc_ram_wr_out,		
		ram_rd_en => uc_ram_rd_out
	);

	banco_reg : banco_reg16bits port map(
        clk => clk_out,
        rst => rst,		
        writeSel => muxSel_wr_BancoReg_out, -- Seleciona o registrador para escrever o valor contido em write_data_out
		readSel => muxSel_rd_BancoReg_out,  -- Seleciona o registrador para fornecer o valor para read_data1_out
        wr_en => uc_bancoReg_wr_out,        
        read_data1 => read_data1_out,
        write_data => banco_writedata_mux_out
	);

	banco_wr_mux : mux_2x1_16bits port map(
		x0 => write_data_out,
		x1 => ram_data_out, -- valor sem a soma +1
        sel => uc_ram_rd_out,
        y0 => banco_writedata_mux_out
	);

	uc_bancoRam_out <= uc_bancoReg_wr_out and uc_ram_rd_out;

	bancoReg_wr_mux: mux_2x1_3bits port map(
		x0 => sel_wr_BancoReg_out,
		x1 => rom_instructions(2 downto 0), -- Endereco para fazer LOAD
        s0 => uc_bancoRam_out, 
        y0 => muxSel_wr_BancoReg_out
	);

	bancoReg_rd_mux: mux_2x1_3bits port map(
		x0 => sel_rd_BancoReg_out,
		x1 => rom_instructions(2 downto 0),  -- Endereco para fazer STORE
        s0 => uc_ram_wr_out, 
        y0 => muxSel_rd_BancoReg_out
	);

-- LOAD regD, const(regRam) :  0001010 xxxxxx ddd ppp -- Carrega o valor guardado no endereco da RAM no regD utilizando o valor do entra2 como constante
-- STORE regS, const(regRam):  0001011 xxxxxx sss ppp -- Guarda o valor que esta no regS no endereco da RAM utilizando o valor do entra2 como constante

	acumulador : reg16bits port map(
		clk  => clk_out,
		rst  => rst,
		wr_en  => uc_acumulador_wr_out,
		data_in  => write_data_out,
		data_out  => read_data2_out
	);


	ula0 : ULA port map(
		entra1 => entra1_mux_out,
		entra2 => muxImm_out,
		sel0 => opULA_out,
		saida => write_data_out,
		flagZero => flagZero_out, 
		flagNegativo => flagNegativo_out,
		flagOverflow => flagOverflow_out
	);
	
	-- Mux para escolher se envia o proximo valor do endereco ou o endereco de salto para o PC
	address_mux: mux_2x1_7bits port map(
		x0 => soma_pc_out,
		x1 => write_data_out(6 downto 0),
        s0 => uc_jump_out,
        y0 => addres_mux_out 
	);
	
	-- O -1 serve para corrigir o valor do PC pois no execute onde eh feita o calculo do salto condicional
	-- O PC ja vai ter avançado para o proximo valor que eh diferente daquele em que estava a instrucao do salto
	-- Pois o calculado a principio procura fazer a soma ou subt em relacao ao endereco de onde foi chamado o salto condicional com a constante
	pc_data16bit_out <= "000000000" & pc_data_out -1;

	-- Mux para escolher se envia para o entra1 da ULA ou se envia o endereco atual do PC
	entra1_mux : mux_2x1_16bits port map(
		x0 => read_data1_out,
		x1 => pc_data16bit_out, -- valor sem a soma +1
        sel => uc_jump_out,
        y0 => entra1_mux_out
	);
	
	-- Mux para escolher entre o imediato para operacao de somas ou salto
	immJump_mux : mux_2x1_16bits port map(
        x0 => imm_in,
        x1 => immJump_in,
        sel => uc_jump_out,
        y0 => muxImmJump_out
    );
	
	-- Mux para escolher entre enviar o valor do acumulador ou do valor imediato para o entra2
	imm_mux: mux_2x1_16bits port map(
        x0 => read_data2_out,
        x1 => muxImmJump_out,
        sel => uc_useImm_out,
        y0 => muxImm_out
    );
	

end architecture;