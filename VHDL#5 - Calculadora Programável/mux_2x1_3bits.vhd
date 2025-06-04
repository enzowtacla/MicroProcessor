library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1_3bits is
    port(
        x0,x1 : in unsigned (2 downto 0);
        s0: in std_logic;
        y0 : out unsigned (2 downto 0)
    );
end entity;

architecture a_mux_2x1_3bits of mux_2x1_3bits is
begin
    y0 <=   x0 when s0='0' else
            x1 when s0='1' else
            "000";
end architecture;