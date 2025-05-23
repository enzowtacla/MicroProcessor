library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port(
        clk : in std_logic;
        rst : in std_logic;
		opSel : in unsigned (6 downto 0);
        pc_wr_en : out std_logic
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
    pc_wr_en <= fft_out;
	
end architecture;