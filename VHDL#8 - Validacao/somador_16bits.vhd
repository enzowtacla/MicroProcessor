library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_16bits is
    port(
        x,y : in unsigned(15 downto 0);
        soma, subt : out unsigned(15 downto 0)
    );
end entity;

architecture a_somador_16bits of somador_16bits is
begin
    soma <= x+y;
    subt <= x-y;
end architecture;