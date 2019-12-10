library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signextension7 is
	port( Zin1 :in std_logic_vector(8 downto 0);
			Zout1 : out std_logic_vector(15 downto 0));
end entity;

architecture Behave of signextension7 is
	
	signal apositive : std_logic_vector(15 downto 0);
	begin
	
	apositive(8 downto 0) <= Zin1;
	apositive(15 downto 9) <="0000000" when Zin1(8) ='0' else "1111111" when Zin1(8) ='1';
									 
									 
	Zout1<=apositive;
	
	end Behave;
	
	
	
