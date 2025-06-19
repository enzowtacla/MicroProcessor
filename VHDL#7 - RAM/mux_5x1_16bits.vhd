library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_5x1_16bits is
    port(
        x0, x1, x2, x3, x4 : in unsigned(15 downto 0);
        sel: in unsigned (2 downto 0);
        y0 : out unsigned (15 downto 0)        
    );
end entity;

architecture a_mux_5x1_16bits of mux_5x1_16bits is
begin
    y0 <=   x0 when sel="000" else
            x1 when sel="001" else
            x2 when sel="010" else
            x3 when sel="011" else
			x4 when sel="100" else
            "0000000000000000";
end architecture;