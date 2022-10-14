library ieee;
use ieee.std_logic_1164.all;

library work;
use work.MIPSPackage.all;

entity Register32Bits is 
generic(num:		integer := 32);

port
(
	--clear,
	clk,load:	in std_logic;
	d:		in std_logic_vector(num-1 downto 0);
	q:		out std_logic_vector(num-1 downto 0)
);
end Register32Bits;

architecture structure of Register32Bits is


begin

	R32:for i in 0 to num-1 generate
		
		regs:Register1Bit port map(clk, load, d(i), q(i));
		
	end generate;

end structure;