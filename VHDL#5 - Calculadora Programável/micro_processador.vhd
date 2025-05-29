library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro_processador is
	port(
		clk_global : in std_logic;
		rst : in std_logic;
        saidaROM: out unsigned (18 downto 0)
		);
end entity;

architecture a_micro_processador of micro_processador is
	
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
        pc_wr_en : out std_logic;
		rom_rd_en : out std_logic;
		jump_en : out std_logic
		);
	end component;

	component mux_2x1_7bits is
		port(
        	x0,x1 : in unsigned (6 downto 0);
        	s0: in std_logic;
        	y0 : out unsigned (6 downto 0)
    	);
	end component;
	
	component ULA is
		port(
			entra1, entra2 : in unsigned (15 downto 0);
			sel0 : in unsigned (1 downto 0);
			saida : out unsigned (15 downto 0);

			flagZero : out std_logic;
			flagResultNegativo : out std_logic
    );
	end component;

    signal clk, uc_rom_rd_out, uc_pc_wr_out, uc_jump_out : std_logic;
	signal opcode, addres_mux_out : unsigned (6 downto 0);
    signal pc_data_out, soma_pc_out : unsigned(6 downto 0);
    signal rom_instructions : unsigned (18 downto 0);
	signal test_address_jump : unsigned(6 downto 0);
begin
	clk <= clk_global;
	opcode <= rom_instructions (18 downto 12);
	saidaROM <= rom_instructions;
	test_address_jump <= rom_instructions (6 downto 0) - 1 when uc_jump_out = '1' else
						 "0000000";
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
		jump_en => uc_jump_out
	);

	address_mux: mux_2x1_7bits port map(
		x0 => soma_pc_out,
		x1 => test_address_jump,
        s0 => uc_jump_out,
        y0 => addres_mux_out 
	);
	
	ula : ULA port map(
		entra1 =>,
		entra2 =>,
		sel0 => ,
		saida => ,

		flagZero =>,
		flagResultNegativo =>

	);
end architecture;