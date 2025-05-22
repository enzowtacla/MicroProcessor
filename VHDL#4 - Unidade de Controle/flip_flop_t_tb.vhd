library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop_t_tb is
end;

architecture a_flip_flop_t_tb of flip_flop_t_tb is
	component flip_flop_t
		port(
			clk : in std_logic;
			rst : in std_logic;
			data_out : out std_logic
			);
		end component;
		signal clk, rst : std_logic;
		signal data_out : std_logic;
		
		constant period_time : time := 100 ns;
		signal finished : std_logic := '0';
		signal reset : std_logic;
begin
	-- UUT = UNIT UNDER TEST
	uut : flip_flop_t port map(
		clk => clk,
		rst => rst,
		data_out => data_out
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
	rst <='1';
	wait for 100 ns;
	rst <='0';
	wait for 100 ns;
	wait for 100 ns;
	wait for 100 ns;
	

	wait;
end process;
end architecture a_flip_flop_t_tb;