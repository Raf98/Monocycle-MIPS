library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.MIPSPackage.all;


entity Control is
port
( 
	--clk 		: in std_logic;
	--reset 	:in std_logic;
	opcode 	: in std_logic_vector( 5 downto 0 );
	output	:	out std_logic_vector(11 downto 0)
);
end Control;

--isRType(11),immediateOperation(10), registerDestiny(9), ULASource(8), memoryToRegister(7), writeRegister(6) 
--readMemory(5), writeMemory(4), ConditionalBranch_DvC(3), ULAOperation1(2), ULAOperation0(1) 
--UnconditionalBranch_DVI(0)   




architecture behavior of Control is

begin
	with opcode select
	output <= 	"101001000100" when "000000",		--Formato R
					"000111100000" when "100011",		--LW
					"000100010000" when "101011",		--SW   "00X1X0010000"
					"000000001010" when "000100",     --BEQ
					"010101000110" when "001101",		--Formato I
					"000000000001" when "000010",     --JUMP
					"000000000000" when others;
	
end behavior;