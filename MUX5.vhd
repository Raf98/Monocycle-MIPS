library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

library work;
use work.MIPSPackage.all;


entity MUX5 is
generic( num: integer := 5 );
port 
(
	a,b:		in std_logic_vector(num-1 downto 0);
	sel:		in std_logic;
	s:			out std_logic_vector(num-1 downto 0)
);
end MUX5;


architecture behavior of MUX5 is

begin

	with sel select
		s <= 	a when '0',
				b when others;

end behavior;
 