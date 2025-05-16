library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        entra1, entra2 : in unsigned (15 downto 0);
        sel0 : in unsigned (1 downto 0);
        saida : out unsigned (15 downto 0);

		flagZero : out std_logic;
		flagResultNegativo : out std_logic;
		flagIgual : out std_logic;
        flagPar : out std_logic
    );
end entity;

architecture a_ULA of ULA is
    component mux_4x1_16bits is
        port( 
            x0, x1, x2, x3 : in unsigned(15 downto 0);
            sel: in unsigned (1 downto 0);
            y0 : out unsigned (15 downto 0)  
        );
    end component;
    component somador_16bits is
        port( 
            x,y : in unsigned(15 downto 0);
            soma, subt : out unsigned(15 downto 0);
			zero, resultNegativo, igual, par : out std_logic
        );
    end component;
    signal out_soma, out_subt, out_mux, out_zerado : unsigned(15 downto 0);
	
begin
    -- 00 = soma
    -- 01 = subt
    -- 10 = zerado
    -- 11 = zerado
    somador : somador_16bits port map(x => entra1, y => entra2, soma => out_soma, subt => out_subt, zero => flagZero, resultNegativo => flagResultNegativo, igual => flagIgual, par => flagPar);
    mux1 : mux_4x1_16bits port map(x0 => out_soma, x1 => out_subt, x2=> out_zerado, x3 => out_zerado, sel=> sel0, y0 => out_mux);
    -- MUX: 00 = SOMA | 01 = SUBT
    
    saida <= out_mux;
	
end architecture;