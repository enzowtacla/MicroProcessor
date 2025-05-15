library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits_tb is
end;

architecture a_banco_reg16bits_tb of banco_reg16bits_tb is
	component banco_reg16bits
		port(
        readSel : IN unsigned(2 DOWNTO 0);
        writeSel : IN unsigned(2 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        read_data1 : OUT unsigned(15 DOWNTO 0);
        write_data : IN unsigned(15 DOWNTO 0)
		);
	end component;
	signal readSel, writeSel : unsigned (2 downto 0);
	signal wr_en, clk, rst : std_logic;
	signal read_data1, write_data : unsigned (15 downto 0);
	
	constant period_time : time := 100 ns;
	signal finished : std_logic := '0';
	signal reset : std_logic;
begin
	-- UUT = UNIT UNDER TEST
	uut : banco_reg16bits port map(
		readSel => readSel,
		writeSel => writeSel,
		wr_en => wr_en,
		clk => clk,
		rst => rst,
		read_data1 => read_data1,
		write_data => write_data
		);
	reset_global: process
	begin
		reset <= '1';
		wait for period_time*2; -- espera 2 clocks, para garantir
		reset <= '0';
		wait;
	end process reset_global;

	sim_time_proc: process
	begin 
		wait for 10 us; -- TEMPO TOTAL DA SIMULACAO
		finished <= '1';
		wait;
	end process sim_time_proc;
	
	clk_proc: process
	begin
		while finished /= '1' loop
			clk <= '0';
			wait for period_time/2;
			clk <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
process
begin
	wait for 250 ns;
	-- Tentar escrever com wr_en DESATIVADO
	wr_en <= '0';
	writeSel <= "000";	
	readSel <= "000";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '1';
	writeSel <= "001";
	readSel <= "001";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '0';
	writeSel <= "010";
	readSel <= "010";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '1';
	writeSel <= "011";
	readSel <= "011";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '0';
	writeSel <= "100";
	readSel <= "100";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '1';
	writeSel <= "101";
	readSel <= "101";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '0';
	writeSel <= "110";
	readSel <= "110";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	wr_en <= '1';
	writeSel <= "111";
	readSel <= "111";	
	write_data <= "1111111111111111";
	wait for 250 ns;
	
	wait;

end process;
end architecture;