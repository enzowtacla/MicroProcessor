library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro_processador_tb is
end;

architecture a_micro_processador_tb of micro_processador_tb is
	component micro_processador
		port(
			clk_global : in std_logic;
			rst : in std_logic;
			state: out unsigned (1 downto 0);
			saidaPC: out unsigned (6 downto 0);
        	saidaROM: out unsigned (18 downto 0);
			saidaReg1, saidaAcumulador, saidaULA, saidaRAM: out unsigned (15 downto 0)
			);
		end component;
		signal clk_global, rst,  pc_wr_en : std_logic;
		signal state : unsigned (1 downto 0);
		signal saidaROM : unsigned (18 downto 0);
		signal saidaReg1, saidaAcumulador, saidaULA , saidaRAM: unsigned(15 downto 0);
		signal saidaPC : unsigned (6 downto 0);

		constant period_time : time := 100 ns;
		signal finished : std_logic := '0';
		signal reset : std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : micro_processador port map(
		clk_global => clk_global,
		rst => rst,
		state => state,
		saidaPC => saidaPC,
        saidaROM=> saidaROM,
		saidaReg1=> saidaReg1,
		saidaAcumulador=> saidaAcumulador, 
		saidaULA=> saidaULA,
		saidaRAM => saidaRAM
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
		wait for 100 us; -- TEMPO TOTAL DA SIMULACAO
		finished <= '1';
		wait;
	end process sim_time_proc;
	
	clk_proc: process
	begin
		while finished /= '1' loop
			clk_global <= '0';
			wait for period_time/2;
			clk_global <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;

process
begin
	rst <= '1';
	wait for 100 ns;
    rst <= '0';    

	wait;
end process;
end architecture a_micro_processador_tb;