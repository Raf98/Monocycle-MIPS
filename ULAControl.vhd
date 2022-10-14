library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.MIPSPackage.all;


entity ULAControl is
port
( 
	funct 			: in std_logic_vector(5 downto 0);
	ulaOperation 	: in std_logic_vector(1 downto 0);
	sel 				: out std_logic_vector( 2 downto 0 )
);
end ULAControl;


architecture behavior of ULAControl is

signal input :	std_logic_vector( 7 downto 0 ); 

begin

	input <= ulaOperation & funct;

	with input select 
	
	
	
	sel <=	"010" when "10100000",		--add
				"110" when "10100010",	 	--sub
				"000" when "10100100",	 	--and
				"001" when "10100101",		--or
				"100" when "10101010",		--slt
				"101" when others;
	
	
	
	
--	
--	sel <=	"010" when "00XXXXXX",
--				"110" when "X1XXXXXX",
--				"010" when "1XXX0000",
--				"110" when "1XXX0010",
--				"000" when "1XXX0100",
--				"001" when "1XXX0101",
--				"111" when "1XXX1010";

--	sel <=	"010" when "00XXXXXX",
--				"110" when "01XXXXXX",
--				"111" when "11000000",--"11XXXXXX",
--				"010" when "10000000",
--				"110" when "10000010",
--				"000" when "10100100",
--				"001" when "10100101",
--				"101" when others;
end behavior;