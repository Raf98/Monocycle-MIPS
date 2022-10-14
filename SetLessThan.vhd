library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.MIPSPackage.all;

entity SetLessThan is
generic(num : integer := 32);
port
(
	a,b:		in std_logic_vector(num-1 downto 0);
	s:			out std_logic_vector(num-1 downto 0)
);
end SetLessThan;

architecture behavior of SetLessThan is

signal result	:	std_logic_vector( num-1 downto 0 ); 
signal res31	:	std_logic;	

begin

	result <= a - b;
	
	res31 <= result(31);
	
	with res31 select 
	s <= "00000000000000000000000000000001" when '1',		--resultado negativo em complemento de dois,
		  "00000000000000000000000000000000" when others;	--ou seja, a menor que b (a < b)

end behavior;