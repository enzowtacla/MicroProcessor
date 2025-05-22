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
        useImm : in std_logic;
        clk : in std_logic;
        rst : in std_logic;        

		saida_ULA : out unsigned(15 downto 0);        
		entra_Banco : in unsigned(15 downto 0);		
        entra_Imm : in unsigned(15 downto 0)

        );
	end component;

	signal readSel, writeSel: unsigned (2 downto 0);
	signal opSel : unsigned (1 downto 0);
	signal clk, rst, wr_en_Banco, wr_en_Acumulador , useImm : std_logic;
	signal entra_Banco, saida_ULA, entra_Imm : unsigned (15 downto 0);
	
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
		useImm => useImm,
		clk => clk,
		rst => rst,

		saida_ULA => saida_ULA,
		entra_Banco => entra_Banco,
		entra_Imm => entra_Imm
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

	wait for 100 ns;
	rst <= '1';
	wait for 100 ns; -- A <- A + R0, R0 = 1, A = 0, RESULTADO: 0
	rst <= '0';
	useImm <= '0'; -- Usar o valor do acumulador
	wr_en_Acumulador <= '0'; -- habilitar escrita no acumulador
	wr_en_Banco <= '1'; -- habilita escrita
	opSel <= "00"; -- seleciona operação de soma
	writeSel <= "000"; -- seleciona o reg que vai ser escrito
	readSel <= "000"; -- seleciona o reg que vai ser lido	
	entra_Banco <= "0000000000000001"; -- valor a ser escrito no reg0 do banco	
	wait for 100 ns; -- Acumulador recebe o resultado da ULA = 1
	wr_en_Acumulador <= '1';
	wait for 100 ns; -- Desabilita para que ele não continue somando e escrevendo o valor no acumulador
	wr_en_Acumulador <= '0'; 
	wait for 100 ns; -- Soma 8 (Reg1) + 1 (Acumulador)
	writeSel <= "001"; -- seleciona o reg que vai ser escrito
	readSel <= "001"; -- seleciona o reg que vai ser lido	
	entra_Banco <= "0000000000001000"; -- valor a ser escrito no reg1 do banco	
	wait for 100 ns; -- Subtrai 8 - 1 = 7
	opSel <= "01"; -- Seleciona subtracao
	wait for 100 ns; -- 8 + 1 = 9
	opSel <= "00";
	entra_Banco <= "0000000000001000"; -- = 8
	wr_en_Acumulador <= '1'; -- registra o resultado no acumulador
	wait for 100 ns; -- Testa numero negativo 8-9 = FFFF
	opSel <= "01"; 
	wr_en_Acumulador <= '0';
	wait for 100 ns; -- Pega o valor anterior registrado no reg0 = 1 para a subtracao que resulta em 1 - 9 = FFF8
	readSel <= "000"; 
	wait for 100 ns; -- Teste de subst com constante, 1 - 80 = FF81
	entra_Imm <= "0000000010000000";
	useImm <= '1'; -- Usa uma constante imediato 1+81 = 0081
	wait for 100 ns; -- Teste com soma
	opSel <= "00";
	wait for 100 ns; -- Usa o valor do acumulador de volta que era 9
	useImm <= '0';

	wait;

end process;
end architecture;
