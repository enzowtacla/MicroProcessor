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

entity micro_processador is
	port(
		clk_global : in std_logic;
		rst : in std_logic;
		state: out unsigned (1 downto 0);
		saidaPC: out unsigned (6 downto 0);
        saidaROM: out unsigned (18 downto 0);
		saidaReg1, saidaAcumulador, saidaULA: out signed (15 downto 0)
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

	component unidade_controle is
		port(
        clk : in std_logic;
        rst : in std_logic;
		opcode : in unsigned (6 downto 0);
        rom_rd_en : out std_logic; -- FETCH     
		pc_wr_en : out std_logic; -- DECODE
        jump_en : out std_logic; -- SALTO INCONDICIONAL
		acumulador_wr_en: out std_logic;
		opULA : out unsigned (2 downto 0);
		useImm : out std_logic;
		bancoReg_wr_en : out std_logic
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
			x0, x1 : in signed(15 downto 0);
			sel: in std_logic;
			y0 : out signed (15 downto 0)        
		);
	end component;

	component mux_2x1_3bits is
		port(
        	x0,x1 : in unsigned (2 downto 0);
        	s0: in std_logic;
        	y0 : out unsigned (2 downto 0)
    );
	end component;

	component ULA is
		port(
			entra1, entra2 : in signed (15 downto 0);
			sel0 : in unsigned (2 downto 0);
			saida : out signed (15 downto 0);
			flagZero : out std_logic;
			flagResultNegativo : out std_logic;
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
			read_data1 : OUT signed(15 DOWNTO 0);
			write_data : IN signed(15 DOWNTO 0)
		);
	end component;

	component reg16bits is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in signed(15 downto 0);
			data_out : out signed(15 downto 0)
		);
	end component;

    signal clk, uc_rom_rd_out, uc_pc_wr_out, uc_jump_out, uc_useImm_out, uc_bancoReg_wr_out, uc_acumulador_wr_out, uc_selRegDest_out : std_logic;
	signal opcode, addres_mux_out, pc_data_out, soma_pc_out  : unsigned (6 downto 0);
    signal rom_instructions : unsigned (18 downto 0);
	signal write_data_out, muxImm_out, read_data1_out, read_data2_out, imm_in: signed (15 downto 0);
	
	signal opULA_out, selRegDestino_out: unsigned (2 downto 0);
	signal  state_out: unsigned(1 downto 0);
	
	signal address_jump_out : unsigned(6 downto 0);

	signal flagZero_out, flagResultNegativo_out, flagOverflow_out: std_logic;

begin
	-- Pinos TOP LEVEL para VHDL#5
	clk <= clk_global;
	state <= state_out;
	saidaPC <= pc_data_out;
	saidaROM <= rom_instructions;
	saidaReg1 <= read_data1_out;
	saidaAcumulador <= read_data2_out;
	saidaULA <= write_data_out;

	opcode <= rom_instructions (18 downto 12);
	
	address_jump_out <= rom_instructions (6 downto 0) - 1 when uc_jump_out = '1' else
						 "0000000";
	imm_in <= signed("0000000" & rom_instructions(11 downto 3));
    	
	maq_estados0 : maq_estados port map(
		clk => clk_global,
		rst=> rst,
      	estado => state_out
    );
	
	pc0 : pc port map(
		clk => clk_global,
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
        clk => clk_global,
		mem_read => uc_rom_rd_out,
		mem_write => uc_rom_rd_out,
		endereco_in => soma_pc_out,
		instruction_out => rom_instructions
    );

	uc : unidade_controle port map(		
        clk => clk_global,
        rst => rst,
		opcode => opcode, 
		rom_rd_en => uc_rom_rd_out,
        pc_wr_en => uc_pc_wr_out,
		jump_en => uc_jump_out,
		acumulador_wr_en => uc_acumulador_wr_out ,
		opULA => opULA_out,
		useImm => uc_useImm_out,
		bancoReg_wr_en => uc_bancoReg_wr_out
	);

	banco_reg : banco_reg16bits port map(
        clk => clk_global,
        rst => rst,
		readSel => rom_instructions (2 downto 0),
        writeSel => rom_instructions (2 downto 0),
        wr_en => uc_bancoReg_wr_out,        
        read_data1 => read_data1_out,
        write_data => write_data_out
	);

	acumulador : reg16bits port map(
		clk  => clk_global,
		rst  => rst,
		wr_en  => uc_acumulador_wr_out,
		data_in  => write_data_out,
		data_out  => read_data2_out
	);

	ula0 : ULA port map(
		entra1 => read_data1_out,
		entra2 => muxImm_out,
		sel0 => opULA_out,
		saida => write_data_out,
		flagZero => flagZero_out, 
		flagResultNegativo => flagResultNegativo_out,
		flagOverflow => flagOverflow_out
	);

	address_mux: mux_2x1_7bits port map(
		x0 => soma_pc_out,
		x1 => address_jump_out,
        s0 => uc_jump_out,
        y0 => addres_mux_out 
	);

	imm_mux: mux_2x1_16bits port map(
        x0 => read_data2_out,
        x1 => imm_in,
        sel => uc_useImm_out,
        y0 => muxImm_out
    );

end architecture;