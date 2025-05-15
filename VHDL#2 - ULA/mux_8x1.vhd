library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1 is
    port(
        x0,x1,x2,x3,x4,x5,x6,x7 : in std_logic;
        s0,s1,s2: in std_logic;
        y0 : out std_logic
        -- 
    );
end entity;

architecture a_mux_8x1 of mux_8x1 is
begin
    y0 <=   x0 when s0='0' and s1='0' and s2='0' else
            x1 when s0='0' and s1='0' and s2='1' else
            x2 when s0='0' and s1='1' and s2='0' else
            x3 when s0='0' and s1='1' and s2='1' else
            x4 when s0='1' and s1='0' and s2='0' else
            x5 when s0='1' and s1='0' and s2='1' else
            x6 when s0='1' and s1='1' and s2='0' else
            x7 when s0='1' and s1='1' and s2='1' else
            '0';
end architecture;