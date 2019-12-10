library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Mem is 
	port (CLK,Reset,Mem_wr: in std_logic;
			Mem_A,Mem_Din: in std_logic_vector(15 downto 0);
			Mem_Dout: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of Mem is 
type regarray is array(65535 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
0 => "0011000000000001",1 => "0110000000000000",2 => "0000000001010000",3 => "0000010001011010",4=>"0000010001100010",
5 => "0000000001101001",6 => "0000000001101000",7 => "0000101011110001",8=>"0010000111011000",9=>"0010011100001001",
10=>"0010000001100001",11=>"0010000001100010",12=>"0000000001010000",13=>"0010000001111010",14=>"0001111100001010",
15=>"0100000111000001",16=>"0110111000000000",17=>"1100000111101010",18=>"1100011100000010",19=>"0000000111010000",
20=>"1000001000000010",21=>"0000000111010000",22=>"1001010101000000",23=>"0000000111010000",24=>"0101011110001000",25=>"0111110000000000",
128 => "1111111111111111",129 => "0000000000000001",130 => "1111111111111111",131 => "1010101010101010",132 => "0101010101010101",
133 => "1111111111111111",134 => "0000000000000000",135 => "1111111111111111",
21855=>"0000000000000000",21856=>"0000000000000000",21857=>"0000000000000000",21858=>"0101010101010101",21859=>"0101010101010101",
21860=>"0000000000011000",21861=>"0000000010000000",21862=>"0000000000001111",others => "0000000000000000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
Mem_Dout <= Memory(conv_integer(Mem_A));
Mem_write:
process (Mem_wr,Mem_Din,Mem_A,clk)
	begin
	if(Mem_wr = '1') then
		if(rising_edge(clk) and Reset='0') then
			Memory(conv_integer(Mem_A)) <= Mem_Din;
		end if;
	end if;
	end process;
end Behave;