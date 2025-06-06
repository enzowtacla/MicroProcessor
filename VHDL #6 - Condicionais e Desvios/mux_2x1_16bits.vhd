library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1_16bits is
    port(
        x0, x1 : in signed(15 downto 0);
        sel: in std_logic;
        y0 : out signed (15 downto 0)        
    );
end entity;

architecture a_mux_2x1_16bits of mux_2x1_16bits is
begin
    y0 <=   x0 when sel='0' else
            x1 when sel='1' else
            "0000000000000000";
end architecture;