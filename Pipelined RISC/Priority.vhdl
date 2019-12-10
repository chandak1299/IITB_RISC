library IEEE;
use IEEE.std_logic_1164.all;

entity Priority is
port(Reg_in: in std_logic_vector(8 downto 0);
Reg_out: out std_logic_vector(8 downto 0);
Reg_address: out std_logic_vector(2 downto 0);
Control_out:out std_logic);	

end entity Priority;

architecture abc of Priority is

begin 

process(all)

begin
if(Reg_in(7)='1') then
	Reg_out<=Reg_in and "001111111";
	Reg_address<="000";
	Control_out<='1';
elsif (Reg_in(6)='1') then
	Reg_out<=Reg_in and "010111111";
	Reg_address<="001";
	Control_out<='1';
elsif (Reg_in(5)='1') then
	Reg_out<=Reg_in and "011011111";
	Reg_address<="010";
	Control_out<='1';
elsif (Reg_in(4)='1') then
	Reg_out<=Reg_in and "011101111";
	Reg_address<="011";
	Control_out<='1';
elsif (Reg_in(3)='1') then
	Reg_out<=Reg_in and "011110111";
	Reg_address<="100";
	Control_out<='1';
elsif (Reg_in(2)='1') then
	Reg_out<=Reg_in and "011111011";
	Reg_address<="101";
	Control_out<='1';
elsif (Reg_in(1)='1') then
	Reg_out<=Reg_in and "011111101";
	Reg_address<="110";
	Control_out<='1';
elsif (Reg_in(0)='1') then
	Reg_out<=Reg_in and "011111110";
	Reg_address<="111";
	Control_out<='1';
else
	Control_out<='0';
	Reg_out<=Reg_in;
	Reg_address<="111";
end if;
end process;
	
end abc;
