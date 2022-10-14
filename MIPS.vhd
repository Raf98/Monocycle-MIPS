library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.MIPSPackage.all;


entity MIPS is
generic( num: integer := 32; numAddress:	integer := 5 );
--generic( numAddress:	integer := 5 );
port
(
	clk: 								in std_logic;
	reset:							in std_logic;
	instructionOut: 				out std_logic_vector(num-1 downto 0);
	mapControlOuput:				out std_LOGIC_VECTOR( 11 downto 0 );
	addressWriteRegisterOut:	out std_logic_vector( numAddress-1 downto 0 );
	dataRead1Out, dataRead2Out:out std_logic_vector(num-1 downto 0);
	dataWriteRegisterOut:		out std_logic_vector( num-1 downto 0 );
	
	--zeroSignalOut,DVCOut:	   out std_logic;
	
	addressRead1Out:				out std_logic_vector( numAddress-1 downto 0 );
	addressRead2Out:				out std_logic_vector( numAddress-1 downto 0 );
	--ULAOperationOut:				out std_logic_vector( 1 downto 0 );
	--selectULAOut:					out std_logic_vector( 2 downto 0 );
	ULAOut:							out std_logic_vector( num-1 downto 0 );
	dataMemoryOut:					out std_logic_vector( num-1 downto 0 );
	pcNextOut:						out std_logic_vector( numAddress-1 downto 0 );
	--jumpOut:							out std_logic_vector( num-1 downto 0 );
	--branchOut:						out std_logic_vector( numAddress-1 downto 0 );
	--memoryOutMuxOut:				out std_logic_vector( num-1 downto 0 );
	
	
	loadOut, loadMemoryOut:		out std_logic;
	wordInMemoryOut:				out std_LOGIC_VECTOR( num-1 downto 0 )
	--pcOutInMemoryOut:				out std_LOGIC_VECTOR(numAddress-1 downto 0)
);
end MIPS; 


architecture datapath of MIPS is

signal load:			std_logic; --:= '0';
signal loadMemory:	std_logic; --:= '1';
signal indexLoad:		std_logic_vector( 4 downto 0 ); 
signal pcOutInMemory:	std_logic_vector( 4 downto 0 );
signal currentIndex:		integer := -1;

signal wordInMemory:	std_logic_vector( num-1 downto 0 );
signal word:			std_logic_vector(num-1 downto 0);

signal pcIn:			std_logic_vector( numAddress-1 downto 0 ) := "00000";
signal pcOut:			std_logic_vector( numAddress-1 downto 0 );
signal pcNext:			std_logic_vector( numAddress-1 downto 0 );
signal pcOnJump: 		std_logic_vector( numAddress-1 downto 0 );
--signal memoryCurrentIndex:		std_logic_vector( numAddress-1 downto 0 ) := "00000";

signal shiftLeftPC:	std_logic_vector( 27 downto 0 );
signal shiftLeftBeq:	std_logic_vector( num-1 downto 0 );
signal outMuxBeq:		std_logic_vector( numAddress-1 downto 0 ); 

signal instruction:	std_logic_vector( num-1 downto 0 );
signal instructionMem: std_logic_vector( num-1 downto 0 );

signal controlOutput:std_logic_vector( 11 downto 0 ); 
signal immediateOperation, registerDestiny, ULASource, memoryToRegister, writeRegister,
		 readMemory, writeMemory, ConditionalBranch_DvC, UnconditionalBranch_DVI, isRType : std_logic;  
signal ULAOperation:		std_logic_vector( 1 downto 0 );
		 
signal registerWriteAdress:	std_logic_vector( 4 downto 0 );
signal dataRead1, dataRead2:	std_logic_vector( num-1 downto 0 );
signal dataWriteRegister:		std_logic_vector( num-1 downto 0 );


signal signalExtender, zeroExtender:	std_logic_vector( num-1 downto 0 );
signal outMuxExtenders:		std_logic_vector( num-1 downto 0 );


signal selectULA1:	std_logic_vector( 2 downto 0 );
signal selectULA2:	std_logic_vector( 2 downto 0 );
signal selectULA:		std_logic_vector( 2 downto 0 );

signal inULAB:		std_logic_vector( num-1 downto 0 ); 
signal zeroSignal:std_logic;
signal outULA:		std_logic_vector( num-1 downto 0 );

signal dataReadMemory:	std_logic_vector( num-1 downto 0 );

signal outMUXPC:		std_logic_vector( num-1 downto 0 );


type   memoryType is array ( 0 to 2**numAddress -1 ) of STD_LOGIC_VECTOR(num -1 downto 0);
constant mem : memoryType :=
(
	"00110100000000000000000000000000",		--(0) ori zero, zero, 0	 
	"00110100000010010000000000010000",		--(1) ori t1,zero,16
	"00110100000010000000000000010001",		--(2) ori t0,zero,17
	"00000001001010000101000000100010",		--(3) sub t2, t1, t0 
	"00000001010000000101000000100101",  	--(4) or t2, t2, zero
	"00110100000010110000000000000011",		--(5) ori t3, zero, 3 
	"10101101001010110000000000000000",		--(6) sw t3, 0(t1)
	"00000001000010110110000000100100",		--(7) and t4, t0, t3
	"10001101001011010000000000000000",		--(8) lw t5, 0(t1)
	"00001000000000000000000000001100",		--(9) j  12 
	"11111100000000000000000000000000",    --(10) 
	"11111100000000000000000000000000",		--(11)
	"00000001000010100111000000100000",		--(12)add t6, t0, t2 
	"00010001110010010000000000010000",		--(13)beq t6, t1, 16
	"11111100000000000000000000000000",		--(14)
	"11111100000000000000000000000000",		--(15)
	"00000001011011100111100000101010",		--(16)slt t7, t3, t6 000000 01000 01001 01010 00000 101010
	"00000001111000000111100000100101",		--(17)or t7, t7, zero
	"00000001101000000110100000100101",		--(18)or t5, t5, zero
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000",
	"11111100000000000000000000000000"
);



begin

		ProgramCounter:	Register32Bits 
		generic map ( num => 5 )
		port map (  clk, load,  pcIn, pcOut );
		
		pcNext <= pcOut + '1';
		
		pcNextOut <= pcNext;
		
		with load select
			pcOutInMemory <= indexLoad when '0',			--se estiver carregando o programa,seleciona-o
								  pcOut when others;				--senao, pega o resultado do PC
								  
		with load select
			wordInMemory <= word when '0',
								 "11111100000000000000000000000000" when others;
								 
		wordInMemoryOut <= wordInMemory;
		--pcOutInMemoryOut <= pcOutInMemory;
		
		InstructionMemory:	MemoryInstruction
		port map( clock => clk , WriteEnabled => loadMemory, memoryIndex => pcOutInMemory,
					 DataIn => wordInMemory, instructionOut => instructionMem );
		
		instructionOut <= instruction;
		
		with load select 
				instruction <= instructionMem when '1',
									"11111100000000000000000000000000" when others;
		loadOut <= load;
		loadmemoryOut <= loadMemory;
		
		ControlUnity:	Control
		port map( instruction(31 downto 26 ), controlOutput);
		
		mapControlOuput <= controlOutput;
		
		--Assinalaçao de sinais de controle
		isRType 						<= controlOutput(11);
		immediateOperation 		<= controlOutput(10); 
		registerDestiny 			<= controlOutput(9);
		ULASource 					<= controlOutput(8);
		memoryToRegister 			<= controlOutput(7);
		writeRegister				<= controlOutput(6);
		readMemory	 				<= controlOutput(5);
		writeMemory	 				<= controlOutput(4);
		ConditionalBranch_DvC 	<= controlOutput(3);
		ULAOperation	 			<= controlOutput(2 downto 1);
		UnconditionalBranch_DVI <= controlOutput(0);
		
		
		muxWriteRegister:		MUX5
		port map( instruction( 20 downto 16 ), instruction ( 15 downto 11 ), 
					 registerDestiny, registerWriteAdress );
					 
		--registerWriteAddressOut <= registerWriteAdress; 
		
		regBank:			RegisterBank
		port map( instruction ( 25 downto 21 ), instruction ( 20 downto 16 ), dataRead1, dataRead2, 
					 registerWriteAdress, dataWriteRegister, clk, writeRegister);
					 
		
		addressRead1Out <= instruction( 25 downto 21 );
		addressRead2Out <= instruction( 20 downto 16 );
		
		dataRead1Out <= dataRead1;
		dataRead2Out <= dataRead2;
		
		dataWriteRegisterOut <= dataWriteRegister;
		addressWriteRegisterOut <= registerWriteAdress;
		
		--signalExtender <= "1111111111111111" & instruction( 15 downto 0 );
		zeroExtender 	<= "0000000000000000" & instruction( 15 downto 0 );
		
		
		--muxExtenders:		MUX2
		--port map ( signalExtender, zeroExtender, immediateOperation, outMuxExtenders  );
	
		muxInULA:	MUX2
		port map ( dataRead2 , zeroExtender, ULASource, inULAB );

		
		ULACtrl:		ULAControl
		port map ( instruction ( 5 downto 0 ), ULAOperation, selectULA1 );
		
		ULActrl2:	ULAControl2
		
		port map ( ULAOperation, selectULA2 );
		
		MUXSelectULA:	MUX2
		
		generic map ( num => 3 )
		port map( selectULA2, selectULA1, isRType, selectULA );
		
		
		--ULAOperationOut <= ULAOperation;
		
		--selectULAOut <= selectULA;
		
		ULAUnity:		ULA
		port map ( dataRead1, inULAB, selectULA, zeroSignal, outULA );
		
		ULAOut <= outULA;
		
		dataMemory:		Memory
		port map ( DataIn => dataRead2, AdressInFromULA => outULA, clock => clk, 
					  WriteEnabled => writeMemory, dataRead => dataReadMemory, readMemory => readMemory );
					  
		dataMemoryOut <= dataReadMemory;
		
		muxOutMemory:	MUX2
		port map ( outULA, dataReadMemory, memoryToRegister, dataWriteRegister );
		
		--memoryOutMuxOut <= dataWriteRegister;
	
		
		muxBeq:		MUX5
		port map ( pcNext, zeroExtender( 4 downto 0 ) , 
					  ConditionalBranch_DvC and zeroSignal, outMuxBeq );
					  
		--branchOut <= outMuxBeq;
		
		--zeroSignalOut <= zeroSignal;
		--DVCOut <= ConditionalBranch_DvC;
		
		muxPC:		MUX5
		port map ( outMuxBeq, instruction( 4 downto 0 ), UnconditionalBranch_DVI, pcIn );
	
		--pcIn <= outMUXPC( 4 downto 0 ); 
		
		--jump e beq devem possuir jumps de apenas 0 a 31 
		
		--j 0000000000000000000000000000011 pcIn <=instruction( 4 downto 0 ) 
		
		
		process(clk, load, loadMemory, reset)
		
		variable index : integer := 0;
		
		begin
		
			if(reset = '1')then
			
				load <= '0';
				loadMemory <= '1';
				indexLoad <= "00000";
				--currentIndex <= 0;
				--indexLoad <= conv_STD_LOGIC_VECTOR(currentIndex, indexLoad'length);
				--word <= mem(currentIndex);
		
			elsif( clk'event and clk = '1' and load = '0' and reset = '0') then
				
				if( currentIndex < 31 ) then
					currentIndex <= currentIndex + 1;		
					indexLoad <= conv_STD_LOGIC_VECTOR(currentIndex, indexLoad'length);
					word <= mem(currentIndex);
				else 
				
					load <= '1';
					loadMemory <= '0';
				
				end if;
				
			end if;
			
			--currentIndex <= index;
			
		end process;
		
		
		
		
		
		
end datapath;