library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
	port(
        clk : in std_logic;
        rst : in std_logic;
		opcode : in unsigned (6 downto 0);
        rom_rd_en : out std_logic; -- FETCH     
		pc_wr_en : out std_logic; -- DECODE
        jump_en : out std_logic; -- SALTO INCONDICIONAL
		acumulador__wr_en: out std_logic;
		opULA : out (1 downto 0);
		useImm : out std_logic;
		bancoReg_wr_en : out std_logic
		);
end entity;

architecture a_unidade_controle of unidade_controle is
	
	component maq_estados is
		port(
		clk,rst: in std_logic;
		estado: out unsigned(1 downto 0)
		);
	end component;
	
    signal maq_estados_out : unsigned(1 downto 0);
begin
	
    maq_estds : maq_estados port map(
        clk => clk ,
		rst => rst,
		estado => maq_estados_out
    );
    
	

    rom_rd_en <= '0' when maq_estados_out="00" else
				 '1';
    pc_wr_en <=  '1' when maq_estados_out="01" else
				 '0';
	jump_en <=  '1' when opcode="1111111" else
                '0';


end architecture;
