library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

library work;
use work.MIPSPackage.all;


entity RegisterBank is
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
end RegisterBank;


architecture behavior of RegisterBank is

signal load:		std_logic_vector(0 to num-1);
signal regsIn:		registerArray;
signal regsOut:	registerArray;

type registers is array( 0 to num-1 ) of std_logic_vector( num-1 downto 0 );
signal regBank:	registers;

begin
	
	process( clk, writeRegister )

	begin
	
		if ( clk = '1' and clk'event and writeRegister = '1' ) then 
			regBank( conv_integer( adressWrite )  ) <= dataWrite( num-1 downto 0 );  
		end if;
		
	end process;

--	with writeRegister select
--	load( conv_integer( adressWrite) ) <=	'1' when '1',
--														'0' when '0';
--
--	with writeRegister select 
--	regsIn( conv_integer( adressWrite) ) <= dataWrite when '1',
--														 regsIn( conv_integer( adressWrite) ) when '0';
	
--	process( adressWrite, clk, writeRegister )   
--	
--	begin
--	
--		if( clk = '1' and clk'event )then
--		
----			for i in 0 to num-1 loop
----			
----				load(i) <= '0';
----			
----			end loop;
--			
--			for i in 0 to num-1 loop
--			
--				load(i) <= '0';
--			
--				if(  conv_integer(adressWrite) = i  and writeRegister = '1' )then
--				
--					load(i) <= '1';
--					regsIn(i) <= dataWrite;					
--				
--				end if;
--			
--			end loop;
--		
--		end if;
--	
--	end process;
--	
--	
--	R32:for i in 0 to 31 generate
--			
--		regs:Register32Bits 
--		port map(clk, load(i), regsIn(i), regsOut(i));
--		
--	end generate;
	
	dataRead1 <= regBank(  conv_integer( AdressRead1 )  );
	--dataRead1 <= regsOut(  conv_integer( AdressRead1 )  );
	dataRead2 <= regBank(  conv_integer( AdressRead2 )  );
	--dataRead2 <= regsOut(  conv_integer( AdressRead2 )  );

end behavior;