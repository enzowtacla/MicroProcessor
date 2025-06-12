library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_pc is
	port(		
		data_in : in unsigned (6 downto 0);
		data_out : out  unsigned (6 downto 0)
		);
end entity;

architecture a_soma_pc of soma_pc is
	signal somado: unsigned (6 downto 0);
begin
	somado <= data_in + 1;
	data_out <= somado;
end architecture;