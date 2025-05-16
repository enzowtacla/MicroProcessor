library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1_16bits is
    port(
        x0, x1, x2, x3 : in unsigned(15 downto 0);
        sel: in unsigned (1 downto 0);
        y0 : out unsigned (15 downto 0)        
    );
end entity;

architecture a_mux_4x1_16bits of mux_4x1_16bits is
begin
    y0 <=   x0 when sel="00" else
            x1 when sel="01" else
            x2 when sel="10" else
            x3 when sel="11" else
            "0000000000000000";
end architecture;