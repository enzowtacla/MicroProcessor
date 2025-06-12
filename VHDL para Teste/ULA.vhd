library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        entra1, entra2 : in unsigned (15 downto 0);
        sel0 : in unsigned (2 downto 0);        
        saida : out unsigned (15 downto 0);

		flagZero : out std_logic;
		flagNegativo : out std_logic;
		flagOverflow : out std_logic
    );
end entity;

architecture a_ULA of ULA is
    component mux_5x1_16bits is
        port( 
            x0, x1, x2, x3, x4 : in unsigned(15 downto 0);
            sel: in unsigned (2 downto 0);
            y0 : out unsigned (15 downto 0)  
        );
    end component;
    
    signal out_soma, out_subt, out_mux, out_zerado : unsigned(15 downto 0);
    signal out_somaSigned : signed(15 downto 0);
	
begin
    -- 000 = soma
	out_soma <= entra1+entra2;
    -- 001 = subt
	out_subt <= entra1-entra2;
	
	-- 100 = calcula o valor do salto condicional
	out_somaSigned <= signed(entra1) + signed(entra2); 
	
	-- COMPARACAO EH SIGNED
	-- SOMA NORMAL COM SALTO CONDICIONAL
	
    -- 010 = repassa valor em entra 1
	-- 011 = repassa valor em entra 2 que eh do acumulador
	
    -- 111 = NOP OU ZERADO
    mux1 : mux_5x1_16bits port map(x0 => out_soma, x1 => out_subt, x2=> entra1, x3 => entra2, x4=>unsigned(out_somaSigned),sel=> sel0, y0 => out_mux);
	
    -- MUX: 000 = SOMA | 001 = SUBT | 010 = Repassa o valor que esta na entra1 | 011 = Repassa o valor que esta no entra2 | 111 = NOP
	
    saida <= out_mux;
	
	-- 'VERIFICA' SE RESULTADO EH 0	
	flagZero <= '1' when out_mux="0000000000000000" else
				'0';
	-- 'VERIFICA' SE O RESULTADO EH NEGATIVO
	flagNegativo <= out_mux(15);
	
	--VERIFICA SE HOUVE OVERFLOW
	-- Soma: Overflow se entra1 positivo E entra2 positivo E resultado negativo
    -- OU entra1 negativo E entra2 negativo E resultado positivo
    -- Subtração: Overflow se entra1 positivo E entra2 negativo E resultado negativo
    -- OU entra1 negativo E entra2 positivo E resultado positivo
	flagOverflow <= '1' when (sel0 = "000" and entra1(15) = '0' and entra2(15) = '0' and out_mux(15) = '1') else -- Positivo + Positivo = Negativo
					'1'	when (sel0 = "000" and entra1(15) = '1' and entra2(15) = '1' and out_mux(15) = '0') else -- Negativo + Negativo = Positivo
					'1'	when (sel0 = "001" and entra1(15) = '0' and entra2(15) = '1' and out_mux(15) = '1') else -- Positivo - Negativo = Negativo
					'1'	when (sel0 = "001" and entra1(15) = '1' and entra2(15) = '0' and out_mux(15) = '0') else -- Negativo - Positivo = Positivo
					'0';


	
end architecture;