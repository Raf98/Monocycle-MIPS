library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.MIPSPackage.all;


entity ULAControl2 is
port
( 
	ulaOperation 	: in std_logic_vector(1 downto 0);
	sel 				: out std_logic_vector( 2 downto 0 )
);
end ULAControl2;


architecture behavior of ULAControl2 is

begin

	with ULAOperation select 


	sel <=	"010" when "00",			--lw e sw
				"010" when "01",			--beq
				"111" when "11",			--ori
				"101" when others;
end behavior;