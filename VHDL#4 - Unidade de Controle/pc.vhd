library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		clk : in std_logic;
		rst : in std_logic;
		wr_en : in std_logic;
		pc_in : in unsigned (6 downto 0);
		pc_out : out  unsigned (6 downto 0)
		);
end entity;

architecture a_pc of pc is
	signal saida_reg6bits: unsigned (6 downto 0);
	component reg6bits is
        port( 
            clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in std_logic;
			data_out : out std_logic
		);
	end component;
	component soma_pc is
		port(		
		soma_pc_in : in unsigned (6 downto 0);
		soma_pc_out : out  unsigned (6 downto 0)
		);
    end component;
	
begin
	process (clk, rst, wr_en) -- acionado se houver mudança em clk, rst ou wr_en
	begin
		if rst = '1' then
			saida_reg6bits <= '0';
		elsif wr_en = '1' then
			if rising_edge(clk) then
				saida_reg6bits <= pc_in;
			end if;
		end if;
	end process;
	soma_pc_in <= saida_reg6bits;
	pc_out <= soma_pc_out;
	pc_in <= soma_pc_out;
end architecture;