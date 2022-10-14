library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

library work;
use work.MIPSPackage.all;


entity Memory is
GENERIC (wordLength : integer := 32;
			words  : integer := 5);
port
(
	DataIn 	: IN   std_logic_vector(wordLength -1  DOWNTO 0);
	--AdressIn  : IN   std_logic_vector(words -1 DOWNTO 0);
	AdressInFromULA:	in std_logic_vector( wordLength-1 downto 0 );
	AdressOut : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
	clock, WriteEnabled: IN   std_logic;
	DataOut	: OUT  std_logic_vector(wordLength -1 DOWNTO 0) := "00000000000000000000000000000000";
	
	dataRead:	out std_logic_vector( wordLength-1 downto 0 );
	readMemory:	in std_logic

);
end Memory;



ARCHITECTURE behavior OF Memory IS

type   memoryType is array (2**words -1 downto 0) of STD_LOGIC_VECTOR(wordLength -1 downto 0);
signal memory : memoryType;
signal storeWord : std_logic := '0';
signal Data : STD_LOGIC_VECTOR(wordLength -1 downto 0);
signal AdressIn: std_logic_vector( words-1 downto 0 );

begin
	storeWord <= '1';
	--reg_In1 : Register32Bits PORT MAP (clock, storeWord, DataIn, Data);

	AdressIn <= AdressInFromULA( words-1 downto 0 ); 
	
	process (clock, AdressOut, WriteEnabled)
	
	begin
  
		if clock'event and clock = '1' then
			if WriteEnabled = '1' then
				memory(conv_integer(AdressIn(words -1 DOWNTO 0))) <= DataIn(wordLength -1 downto 0);
			end if;
			DataOut <= memory(conv_integer(AdressOut(words -1 DOWNTO 0))) after 1 ns;
			
			--if readMemory = '1' then
			
				--dataRead <= memory(conv_integer(AdressIn(words -1 DOWNTO 0)));
			
			--end if;
			
		end if;
		
		
	end process;

	dataRead <= memory(conv_integer(AdressIn(words -1 DOWNTO 0)));

END behavior;







