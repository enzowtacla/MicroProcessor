library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        entra1, entra2 : in unsigned (15 downto 0);
        sel0 : in unsigned (1 downto 0);
        saida : out unsigned (15 downto 0);

		flagZero : out std_logic;
		flagResultNegativo : out std_logic
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
    signal out_soma, out_subt, out_mux, out_zero, out_zerado : unsigned(15 downto 0);
	
begin
    -- 00 = soma
	out_soma <= entra1+entra2;
    -- 01 = subt
	out_subt <= entra1-entra2;
    -- 10 = zerado
    -- 11 = zerado
    mux1 : mux_4x1_16bits port map(x0 => out_soma, x1 => out_subt, x2=> out_zerado, x3 => out_zerado, sel=> sel0, y0 => out_mux);
    -- MUX: 00 = SOMA | 01 = SUBT
	
    saida <= out_mux;
	
	-- 'VERIFICA' SE RESULTADO EH 0	
	flagZero <= '1' when out_mux="0000000000000000" else
				'0';
	-- 'VERIFICA' SE O RESULTADO EH NEGATIVO
	flagResultNegativo <= out_mux(15) when sel0 = "01" else
						  '0';
	
end architecture;