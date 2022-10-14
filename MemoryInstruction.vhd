library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

library work;
use work.MIPSPackage.all;


entity MemoryInstruction is
GENERIC (wordLength : integer := 32;
			words  : integer := 5);
port
(
	DataIn 	: IN   std_logic_vector(wordLength -1  DOWNTO 0);-- := "00000000000000000000000000000000";
	AdressIn  : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
	--AdressInFromULA:	in std_logic_vector( wordLength-1 downto 0 ); 
	AdressOut : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
	clock, WriteEnabled: IN   std_logic;
	memoryIndex:	in std_logic_vector( words-1 downto 0 );
	DataOut	: OUT  std_logic_vector(wordLength -1 DOWNTO 0):= "00000000000000000000000000000000";
	instructionOut:		out std_LOGIC_VECTOR(wordLength -1 DOWNTO 0) 

);
end MemoryInstruction;



ARCHITECTURE behavior OF MemoryInstruction IS

type   memoryType is array (0 to 2**words -1) of STD_LOGIC_VECTOR(wordLength -1 downto 0);
signal memory : memoryType;
signal storeWord : std_logic := '0';
signal Data : STD_LOGIC_VECTOR(wordLength -1 downto 0);

signal loadProgram : std_logic := '1';



begin
	storeWord <= '1';
	---regIn1 : Register32Bits PORT MAP (clock, storeWord, DataIn, Data);

	--AdressIn <= AdressInFromULA( 4 downto 0 );
	
	process (clock, AdressOut, loadProgram)
	
	begin
	
		--if loadProgram = '1' then
				--memory(0) <= "00110101001000000000000000010000";
				--memory(1) <= "00110101001000000000000000010000";
				--memory(2) <= "00110101001000000000000000010001";
				--memory(3) <= "00110101001000000000000000010011";
			
				--loadProgram <= '0';
  
		--elsif 
		if clock'event and clock = '1' then
		
			if WriteEnabled = '1' then
				memory(conv_integer(memoryIndex)) <= DataIn(wordLength -1 downto 0);
			end if;
			
			DataOut <= memory(conv_integer(AdressOut(words -1 DOWNTO 0))); --after 1 ns;
			
			--instructionOut <= memory(conv_integer( memoryIndex ));
			
		end if;
		
		--instructionOut <= memory(conv_integer( memoryIndex ));--memory(conv_integer(AdressIn(words -1 DOWNTO 0)));
		
	end process;

	instructionOut <= memory(conv_integer( memoryIndex ));

END behavior;







