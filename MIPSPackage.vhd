library ieee;
use ieee.std_logic_1164.all;


package MIPSPackage is

	
	-------------------------Registrador de 1 bit------------------------
	
	component Register1Bit is 	
	port
	(
		clk,load,d:		in std_logic;
		q:		out std_logic
	);
	end component;
	
	--------------------------Registrador de 32 bits-----------------------
	
	
	component Register32Bits is 
	generic(num:		integer := 32);

	port
	(
		clk,load:	in std_logic;
		d:		in std_logic_vector(num-1 downto 0);
		q:		out std_logic_vector(num-1 downto 0)
	);
	end component;
	
	
	------------------------Array de regitradores de 32 bits-----------------
	
	type registerArray is array (0 to 32) of STD_LOGIC_VECTOR(31 downto 0);
	
	
	-----------------------Memoria de instrucoes---------------------------
	
	
	component MemoryInstruction is
	GENERIC (wordLength : integer := 32;
			words  : integer := 5);
	port
	(
		DataIn 	: IN   std_logic_vector(wordLength -1  DOWNTO 0):= "00000000000000000000000000000000";
		AdressIn  : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
		AdressOut : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
		clock, WriteEnabled: IN   std_logic;
		memoryIndex:	in std_logic_vector( words-1 downto 0 );
		DataOut	: OUT  std_logic_vector(wordLength -1 DOWNTO 0):= "00000000000000000000000000000000";
		instructionOut:		out std_LOGIC_VECTOR(wordLength -1 DOWNTO 0) 

	);
	end component;

	
	
	-----------------------Memoria de dados--------------------------------
	
	
	component Memory is
	GENERIC (wordLength : integer := 32;
				words  : integer := 5);
	port
	(
		DataIn 	: IN   std_logic_vector(wordLength -1  DOWNTO 0);
		--AdressIn  : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
		AdressInFromULA:	in std_logic_vector( wordLength-1 downto 0 ); 
		AdressOut : IN   std_logic_vector(words -1 DOWNTO 0) := "00000";
		clock, WriteEnabled: IN   std_logic;
		DataOut	: OUT  std_logic_vector(wordLength -1 DOWNTO 0) := "00000000000000000000000000000000";
	
		dataRead:	out std_logic_vector( wordLength-1 downto 0 );
		readMemory:	in std_logic

	);
	end component;

	
	
	-----------------------Mux de 32 bits----------------------------------
	
	
	component MUX2 is
	generic( num: integer := 32 );
	port 
	(
		a,b:		in std_logic_vector(num-1 downto 0);
		sel:		in std_logic;
		s:			out std_logic_vector(num-1 downto 0)
	);
	end component;


	
	
	-----------------------Mux de 5 bits-----------------------------------
	
	component MUX5 is
	generic( num: integer := 5 );
	port 
	(
		a,b:		in std_logic_vector(num-1 downto 0);
		sel:		in std_logic;
		s:			out std_logic_vector(num-1 downto 0)
	);
	end component;
	
	-----------------------Banco de regitradores---------------------------
	
	component RegisterBank is
	generic(num:integer := 32);
	port
	(
		adressRead1:	in std_logic_vector(4 downto 0);
		adressRead2:	in std_logic_vector(4 downto 0);
	
		dataRead1:		out std_logic_vector(num-1 downto 0);
		dataRead2:		out std_logic_vector(num-1 downto 0);
	
		adressWrite:	in std_logic_vector(4 downto 0);
		dataWrite:		in std_logic_vector(num-1 downto 0);
	
		clk:				in std_logic;
	
		writeRegister:	in std_logic
	
	
	);
	end component;

	
	-----------------------ULA---------------------------------------------
	
	component ULA is
	generic ( num : integer := 32 );
	port
	(
		a,b:		in std_logic_vector( num-1 downto 0 );
		sel:		in std_logic_vector( 2 downto 0 );
		zero:		out std_logic;
		s:			out std_logic_vector( num-1 downto 0 )
	);
	end component;

	
	-----------------------Controle da ULA---------------------------------
	
	component ULAControl is
	port
	(	 
		funct 			: in std_logic_vector(5 downto 0);
		ulaOperation 	: in std_logic_vector(1 downto 0);
		sel 				: out std_logic_vector( 2 downto 0 )
	);
	end component;
	
	-----------------------Controle da ULA 2-------------------------------
	
	component ULAControl2 is
	port
	(	 
		ulaOperation 	: in std_logic_vector(1 downto 0);
		sel 				: out std_logic_vector( 2 downto 0 )
	);
	end component;
	

	
	-----------------------Controle----------------------------------------

	component Control is
	port
	( 
		opcode 	: in std_logic_vector( 5 downto 0 );
		output	:	out std_logic_vector(11 downto 0)
	);
	end component;

	
	------------------------Instrução slt----------------------------------
	
	component SetLessThan is
	generic(num : integer := 32);
	port
	(
		a,b:		in std_logic_vector(num-1 downto 0);
		s:			out std_logic_vector( num-1 downto 0 )
	);
	end component;

end MIPSPackage;