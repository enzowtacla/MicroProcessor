library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_16bits is
    port(
        x,y : in unsigned(15 downto 0);
        soma, subt : out unsigned(15 downto 0);
		zero, resultNegativo, igual, par : out std_logic
    );
end entity;

architecture a_somador_16bits of somador_16bits is
	signal out_soma, out_subt : unsigned(15 downto 0);
	signal out_zero : std_logic;
begin
	-- SOMA
    out_soma <= x+y;
	-- SUBT
    out_subt <= x-y;
	
	soma <= out_soma;
	subt <= out_subt;

	-- 'VERIFICA' SE RESULTADO EH 0
	out_zero <= '1' when out_soma="0000000000000000" else -- quando o resultado da soma = 0
				'1' when out_subt="0000000000000000" else -- quando o resultado da subt = 0
				'0';
	
	-- 'VERIICA' SE X E Y SAO IGUAIS
	igual <= '1' when out_subt="0000000000000000" else -- quando a subtração entre x-y = 0
			 '0';

	-- 'VERIFICA' SE O RESULTADO DA SOMA OU SUBT EH PAR
	par <= not(out_soma(0) and out_subt(0));
		   
	zero <= out_zero;	

	-- 'VERIFICA' SE O RESULTADO EH NEGATIVO
	resultNegativo <= out_subt(15);
end architecture;