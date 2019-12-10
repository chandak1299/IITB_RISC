library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.
	entity Memory_data is
	 port (CLK,Reset,Mem_wr: in std_logic;
			Mem_A,Mem_Din: in std_logic_vector(15 downto 0);
			Mem_Dout: out std_logic_vector(15 downto 0));
  end entity;

architecture Form of Memory_data is
type regarray is array(65535 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
1 => x"3001",2 => x"6000",3 => x"7E00",4 => x"6E00",5 => x"CF84",6 => x"8003",7 => x"0008",8 => x"F234",9 => x"9200",10 => x"0003",11 => x"6e60",12 => x"0003",13 => x"127f",14 => x"c241",16 => x"9401",17 => x"8652",18 => x"5428",19=>x"ABCD",20=>x"BCDE",21=> x"0006",22 => x"83f5",26 => x"001A",others => "0000000000000000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
Mem_Dout <= Memory(conv_integer(Mem_A));
Mem_write:
process (Mem_wr,Mem_Din,Mem_A,clk)
	begin
	if(Mem_wr = '0') then
		if(rising_edge(clk)) then
			Memory(conv_integer(Mem_A)) <= Mem_Din;
		end if;
	end if;
	end process;
end Form;
