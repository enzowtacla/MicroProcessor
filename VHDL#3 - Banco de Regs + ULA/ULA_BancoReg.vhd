library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--instruções OBRIGATORIAS a serem usadas na sua validacao:
--{'Acumulador ou nao': 'ULA com acumulador',
-- 'Largura da ROM / instrucao em bits': [19],
-- 'Numero de registradores no banco': [8],
-- 'ADD ops': 'ADD com dois operandos apenas',
-- 'Carga de constantes': 'Carrega diretamente com LD sem somar',
-- 'SUB ops': 'Subtracao com dois operandos apenas',
-- 'ADD ctes': 'Ha instrucao ADDI que soma com constante',
-- 'SUB ctes': 'Ha instrucao que subtrai uma constante',
-- 'Subtração': 'Subtracao com SUB sem borrow',
-- 'Comparações': 'Comparacao apenas com CMPI',
-- 'Saltos condicionais': ['BLE (BRANCH IF LESS THAN)', 'BMI (BRANCH IF MinUS OR NEGATIVE RESULT, N=1)'],
-- 'Saltos': 'incondicional eh absoluto e condicional é relativo',
-- 'Validação -- final do loop': 'Loop com DJNZ',
-- 'Validação -- complicacoes': 'instrucao Halt ao final'}

entity ULA_BancoReg is
    port(
        readSel : in unsigned(2 downto 0);
        writeSel : in unsigned(2 downto 0);
        opSel : in unsigned (1 downto 0);
        wr_en_Banco : in std_logic;
        wr_en_Acumulador : in std_logic;
        useImm : in std_logic;
        clk : in std_logic;
        rst : in std_logic;

        saida_ULA: out unsigned(15 downto 0);
        entra_Banco: in unsigned(15 downto 0);
        entra_Imm : in unsigned(15 downto 0)
    );
end entity;

architecture a_ULA_BancoReg of ULA_BancoReg is
    component ULA is
        port( 
            entra1, entra2 : in unsigned (15 downto 0);
            sel0 : in unsigned (1 downto 0);
            saida : out unsigned (15 downto 0);

		    flagZero : out std_logic;
		    flagResultNegativo : out std_logic
            );
    end component;

    component banco_reg16bits is
        port(
            readSel : in unsigned(2 downto 0);
            writeSel : in unsigned(2 downto 0);
            wr_en : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            read_data1 : out unsigned(15 downto 0);
            write_data : in unsigned(15 downto 0)
            );
    end component;

    component reg16bits is -- Acumulador
        port(
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
            );
    end component;

    component mux_2x1_16bits is
        port(
        x0, x1 : in unsigned(15 downto 0);
        sel: in std_logic;
        y0 : out unsigned (15 downto 0)        
    );
    end component;

    signal read_data1_out, read_data2_out, write_data_out, imm_in, mux2x1_out : unsigned(15 downto 0);    
    signal flagResultNegativo_out, flagZero_out : std_logic;
begin   

    banco : banco_reg16bits port map(
            readSel => readSel,
            writeSel => writeSel,
            wr_en => wr_en_Banco,
            clk => clk,
            rst => rst,
            read_data1 => read_data1_out,
            write_data => entra_Banco
    );

    ula0 : ULA port map(
        entra1 => read_data1_out,
        entra2 => mux2x1_out,
        sel0 => opSel,
        saida => write_data_out,

		flagZero => flagZero_out,
		flagResultNegativo => flagResultNegativo_out
    );

    acumulador : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_Acumulador,
        data_in => write_data_out,
        data_out => read_data2_out
    );

    mux_Imm: mux_2x1_16bits port map(
        x0 => read_data2_out,
        x1 => entra_Imm,
        sel => useImm,
        y0 => mux2x1_out
    );

    saida_ULA <= write_data_out;
end architecture;
