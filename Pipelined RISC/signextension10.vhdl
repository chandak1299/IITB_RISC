library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signextension10 is
	port( Zin :in std_logic_vector(5 downto 0);
			Zout : out std_logic_vector(15 downto 0));
end entity;

architecture Behave of signextension10 is
	
	signal apositive : std_logic_vector(15 downto 0);
	begin
	
	apositive(5 downto 0) <= Zin;
	apositive(15 downto 6) <="0000000000" when Zin(5) ='0' else "1111111111" when Zin(5) ='1';
									 
									 
	Zout<=apositive;
	
	end Behave;
	
	
	
