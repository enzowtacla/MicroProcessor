library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port(
        clk : in std_logic;
        rst : in std_logic;
		opcode : in unsigned (6 downto 0);
        rom_rd_en : out std_logic;
        pc_wr_en : out std_logic;
        jump_en : out std_logic
		);
end entity;

architecture a_unidade_controle of unidade_controle is
	
    component flip_flop_t is
        port(
		clk : in std_logic;
		rst : in std_logic;
		data_out : out std_logic
		);
    end component;

    signal fft_out : std_logic;
begin
	
    fft : flip_flop_t port map(
        clk => clk ,
		rst => rst,
		data_out => fft_out
    );
    
    rom_rd_en <= fft_out;
    pc_wr_en <= fft_out;
	jump_en <=  '1' when opcode="1111111" else
                '0';
end architecture;