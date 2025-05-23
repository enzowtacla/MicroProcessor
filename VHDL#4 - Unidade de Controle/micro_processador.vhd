library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro_processador is
	port(
		clk_global : in std_logic;
		rst : in std_logic;
        pc_wr_en : in std_logic;
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
		    endereco_in: in unsigned (6 downto 0);
		    instruction_out: out unsigned (18 downto 0)
	    );
    end component;

    signal clk : std_logic;
    signal pc_data_out, soma_pc_out : unsigned(6 downto 0);
    signal rom_instructions : unsigned (18 downto 0);
begin
	clk <= clk_global;
    pc0 : pc port map(
		clk => clk_global,
		rst => rst,
		wr_en =>  pc_wr_en,
		data_in => soma_pc_out,
		data_out => pc_data_out		
    );
	
    somapc : soma_pc port map(
        data_in => pc_data_out,
		data_out => soma_pc_out
    );

    rom0 : rom port map(
        clk => clk_global,
		endereco_in => soma_pc_out,
		instruction_out => saidaROM
    );



end architecture;