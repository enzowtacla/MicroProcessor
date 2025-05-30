library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits is
	port(		
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        readSel : IN unsigned(2 DOWNTO 0);
        writeSel : IN unsigned(2 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        read_data1 : OUT unsigned(15 DOWNTO 0);
        write_data : IN unsigned(15 DOWNTO 0)
		);
end entity;

architecture a_banco_reg16bits of banco_reg16bits is
	component reg16bits is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out : out unsigned(15 downto 0)
		);
	end component;
	
	component mux_8x1_16bits is
		port(
			entr0 : in unsigned(15 downto 0);
			entr1 : in unsigned(15 downto 0);
			entr2 : in unsigned(15 downto 0);
			entr3 : in unsigned(15 downto 0);
			entr4 : in unsigned(15 downto 0);
			entr5 : in unsigned(15 downto 0);
			entr6 : in unsigned(15 downto 0);
			entr7 : in unsigned(15 downto 0);
			sel : in unsigned(2 downto 0);
			saida : out unsigned(15 downto 0)
		);	
	end component;
	
	component decoder_3x8_3bits is 
		port(
			selDec : in unsigned(2 downto 0);
			wr_en : in std_logic;
			saida : out unsigned(7 downto 0)
		);
	end component;
	
	signal wr_en_0, wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7 : std_logic;
	signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7 : unsigned(15 downto 0);
	
begin
	reg_0 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_0, data_in => write_data, data_out => data_out_0);
    reg_1 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_1, data_in => write_data, data_out => data_out_1);
    reg_2 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_2, data_in => write_data, data_out => data_out_2);
    reg_3 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_3, data_in => write_data, data_out => data_out_3);
    reg_4 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_4, data_in => write_data, data_out => data_out_4);
    reg_5 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_5, data_in => write_data, data_out => data_out_5);
    reg_6 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_6, data_in => write_data, data_out => data_out_6);
    reg_7 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_7, data_in => write_data, data_out => data_out_7);
	
	mux : mux_8x1_16bits port map(
        entr0 => data_out_0,
        entr1 => data_out_1,
        entr2 => data_out_2,
        entr3 => data_out_3,
        entr4 => data_out_4,
        entr5 => data_out_5,
        entr6 => data_out_6,
        entr7 => data_out_7,
        sel => readSel,
        saida => read_data1);
		
	decoder : decoder_3x8_3bits port map(
        selDec => writeSel,
        wr_en => wr_en,
        saida(0) => wr_en_0,
        saida(1) => wr_en_1,
        saida(2) => wr_en_2,
        saida(3) => wr_en_3,
        saida(4) => wr_en_4,
        saida(5) => wr_en_5,
        saida(6) => wr_en_6,
        saida(7) => wr_en_7);
end architecture;
