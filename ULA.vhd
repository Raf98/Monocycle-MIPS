library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.MIPSPackage.all;


entity ULA is
generic ( num : integer := 32 );
port
(
	a,b:		in std_logic_vector( num-1 downto 0 );
	sel:		in std_logic_vector( 2 downto 0 );
	zero:		out std_logic;
	s:			out std_logic_vector( num-1 downto 0 )
);
end ULA;


architecture behavior of ULA is

signal slt	:	std_logic_vector( num-1 downto 0 );
signal subZero:std_logic_vector( num-1 downto 0 );

begin
--fazer ori,andi, nor, xor, sll, slr
	
	sltInstruction: SetLessThan
	port map ( a, b, slt);
	
	with sel select
	
		s <= 	a and b when "000",
				a or b when "001",
				a + b when "010",
				a - b when "110",
				a or b when "111",
				slt when "100",
				"00000000000000000000000000000000" when others;
--				a 	xor b when "011",
--				a nor b when "100",
--				srl when "101",
--				a - b when "110",
--				sll when others;

	subZero <= a - b;

	with subZero select
	
	zero<=	'1' when "00000000000000000000000000000000",
				'0' when others;

end behavior;