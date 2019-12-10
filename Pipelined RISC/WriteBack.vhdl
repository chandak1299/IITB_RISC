library IEEE;
use IEEE.std_logic_1164.all;

entity WriteBack is
port(
clk:in std_logic;
OP_in:in std_logic_vector(3 downto 0);
PC_in:in std_logic_vector(15 downto 0);
Raddress_in:in std_logic_vector(2 downto 0);
Rdata_in:in std_logic_vector(15 downto 0);
Imm9_in:in std_logic_vector(8 downto 0);
CZ_write_in : in std_logic;
Raddress_out:out std_logic_vector(2 downto 0);
Write_control: out std_logic;
Imm9_updated: out std_logic_vector(8 downto 0);
LM_Control_out:out std_logic;
Rdata_out:out std_logic_vector(15 downto 0)
);
end entity;

architecture pqr of WriteBack is

component Priority is
port(Reg_in: in std_logic_vector(8 downto 0);
Reg_out: out std_logic_vector(8 downto 0);
Reg_address: out std_logic_vector(2 downto 0);
Control_out:out std_logic);
end component;

signal buff:std_logic_vector(15 downto 0);
signal temp:std_logic_vector(2 downto 0);
signal temp_cont:std_logic;

begin
pri1: Priority port map(Imm9_in,Imm9_updated,temp,temp_cont);
process(all)
begin

buff(6 downto 0) <= "0000000";
buff(15 downto 7) <= Imm9_in;


if(Raddress_in="111") then
	Write_Control<='0';
	if(OP_in="0011") then
		Rdata_out<=buff;
	else
		Rdata_Out<=Rdata_in;
	end if;
	Raddress_out<="111";
else
	if(OP_in="0000" or OP_in="0010") then
		Rdata_out<=Rdata_in;
		Raddress_out<=Raddress_in;
		if(CZ_write_in = '1') then
			Write_Control<='1';
		else
			Write_Control<='0';
		end if;

	elsif(OP_in="0001" or OP_in="0100" ) then
		Write_Control<='1';
		Rdata_out<=Rdata_in;
		Raddress_out<=Raddress_in;
	elsif(OP_in="1000" or OP_in="1001") then
		Write_Control<='1';
		Rdata_Out<=PC_in;
		Raddress_Out<=Raddress_in;
	elsif(OP_in<="0011") then
		Write_COntrol<='1';
		Rdata_Out<=buff;
		Raddress_Out<=Raddress_in;
	else
		Write_Control<='0';
		Raddress_Out<=Raddress_in;
		Rdata_Out<=Rdata_In;
	end if;
end if;


if(OP_in="0110") then
	Write_Control<=temp_cont;
	Raddress_out<=temp;
	Rdata_out<=Rdata_in;
end if;
LM_control_out<=temp_cont;		-- Always assign tmep_cont to LM_conrol_out. Will be used only in LM.
end process;

end pqr;
