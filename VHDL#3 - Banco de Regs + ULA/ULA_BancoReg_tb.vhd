library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_BancoReg_tb is
end;

architecture a_ULA_BancoReg_tb of ULA_BancoReg_tb is
	component ULA_BancoReg
		port(
        readSel : in unsigned(2 downto 0);
        writeSel : in unsigned(2 downto 0);
        opSel : in unsigned (1 downto 0);
        wr_en_Banco : in std_logic;
        wr_en_Acumulador : in std_logic;
        clk : in std_logic;
        rst : in std_logic;        

		saida_ULA : out unsigned(15 downto 0);        
		entra_Banco : in unsigned(15 downto 0)
        );
	end component;

	signal readSel, writeSel : unsigned (2 downto 0);
	signal opSel : unsigned (1 downto 0);
	signal clk, rst, wr_en_Banco, wr_en_Acumulador : std_logic;
	signal entra_Banco, entra_Acumulador, saida_ULA : unsigned (15 downto 0);
	
	constant period_time : time := 100 ns;
	signal finished : std_logic := '0';
	signal reset : std_logic;

begin
	-- UUT = UNIT UNDER TEST
	uut : ULA_BancoReg port map(
		readSel => readSel,
		writeSel => writeSel,
        opSel => opSel,
		wr_en_Banco => wr_en_Banco,
        wr_en_Acumulador => wr_en_Acumulador,
		clk => clk,
		rst => rst,

		saida_ULA => saida_ULA,
		entra_Banco => entra_Banco
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

	wait for 200 ns;
	rst <= '1';
	wait for 200 ns; -- A <- A + R0, R0 = 1, A = 0, RESULTADO: 0
	rst <= '0';
	wr_en_Acumulador <= '1'; -- habilitar escrita no acumulador
	opSel <= "00"; -- seleciona operação de soma
	writeSel <= "000"; -- seleciona o reg que vai ser escrito
	readSel <= "000"; -- seleciona o reg que vai ser lido
	wr_en_Banco <= '1'; -- habilita escrita
	entra_Banco <= "0000000000000001"; -- valor a ser escrito no reg0 do banco	
	wait for 200 ns; -- A <- A + R1, R1 = 2, A = 1, RESULTADO: 3
	wr_en_Acumulador <= '0';
	writeSel <= "001"; 
	readSel <= "001";
	entra_Banco <= "0000000000000010"; 
	wait for 200 ns; -- A <- A - R0, R0 = 1, A = 1, RESULTADO: 2
	opSel <= "01";
	writeSel <= "000"; -- seleciona o reg que vai ser escrito
	readSel <= "000"; -- seleciona o reg que vai ser lido
	wait for 200 ns;
	wait for 200 ns;

	wait;

end process;
end architecture;