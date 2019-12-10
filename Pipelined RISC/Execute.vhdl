library IEEE;
use IEEE.std_logic_1164.all;

entity Execute is
port (
clk: in std_logic;
PC_in : in std_logic_vector(15 downto 0);
Op_in: in std_logic_vector(3 downto 0);
RegA_in: in std_logic_vector(15 downto 0);
Opr1: in std_logic_vector(15 downto 0);
Opr2: in std_logic_vector(15 downto 0);
Imm6_extended: in std_logic_vector(15 downto 0);
Imm9_in: in std_logic_vector(8 downto 0);
Imm9_extended: in std_logic_vector(15 downto 0);
RD_in: in std_logic_vector(2 downto 0);    --Address destination
C_in,Z_in: in std_logic;
Hazard1: in std_logic;
Hazard2: in std_logic;
Hazard_data1: in std_logic_vector(15 downto 0);
Hazard_data2: in std_logic_vector(15 downto 0);
Multiple_control: in std_logic;
multiple_addr: in std_logic_vector(15 downto 0);
C_flag_in,Z_Flag_in:in std_logic;
C_flag,Z_flag: out std_logic;
PC_out: out std_logic_vector(15 downto 0);
Op_out: out std_logic_vector(3 downto 0);
RegA_out: out std_logic_vector(15 downto 0);
ALU_out: out std_logic_vector(15 downto 0);
Imm6_out: out std_logic_vector(15 downto 0);
Imm9_out: out std_logic_vector(8 downto 0);
RD_out: out std_logic_vector(2 downto 0);
PC_updated: out std_logic_vector(15 downto 0);
C_out,Z_out: out std_logic;
CZ_write_out:out std_logic
);
end entity;


architecture myArch of Execute is

component ALU is
port(
	a: in std_logic_vector(15 downto 0);
   b: in std_logic_vector(15 downto 0);
   p: in std_logic_vector(1 downto 0);
	SOUT: out std_logic_vector(15 downto 0); C,Z : out std_logic);
end component;

signal t1, t2, t3, t4, t5, t6, t7: std_logic_vector(15 downto 0);
signal ALU_control,ALU_control2: std_logic_vector(1 downto 0);
signal C_dummy, Z_dummy, C_dummy1, Z_dummy1: std_logic;

begin

ALU1: ALU port map(t1, t2, ALU_control, t3, C_dummy, Z_dummy);
ALU2: ALU port map(t5,t6,ALU_control2,t7, C_dummy1, Z_dummy1);

process(all)

begin

ALU_control2<="00";
if(Multiple_control = '1') then
	t1<=multiple_addr;
elsif(Hazard1 = '0' or OP_in="0101") then
	t1<=Opr1;
else
	t1<=Hazard_data1;
end if;

if(Multiple_control = '1') then
	t2<="0000000000000001";
elsif(Hazard2 = '0') then
	t2<=Opr2;
else
	t2<=Hazard_data2;
end if;


if(Op_in="0000" or Op_in="0001" or Op_in="0011" or Op_in="0100" or Op_in="0101" or Op_in="0110" or Op_in="0111") then
	ALU_control<="00";
elsif(Op_in="0010") then
	ALU_control<="01";
else
	ALU_control<="10";
end if;


if(Op_in="0110" or Op_in="0111") then
	if(Multiple_control='0' and Hazard1='0') then
		RegA_out<=RegA_in;
	elsif(Multiple_Control='0' and Hazard1='1') then
		RegA_out<=Hazard_Data1;
	else
		RegA_out<=t3;
	end if;	
	
elsif(OP_in="0101") then
	if(Hazard1='0') then
		RegA_out<=RegA_in;
	else
		RegA_out<=Hazard_Data1;
	end if;
end if;


if(Op_in="0000") then
		ALU_out<=t3;
		if(C_in='1' and Z_in='0') then
			if(C_flag_in='1') then
				C_flag<=C_dummy;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
			else
				C_flag<=C_flag_in;
				Z_flag<=Z_flag_in;
				CZ_write_out<='0';
			end if;
		elsif(C_in='0' and Z_in='1') then
			if(Z_flag_in='1') then
				C_flag<=C_dummy;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
			else
				C_flag<=C_flag_in;
				Z_flag<=Z_flag_in;
				CZ_write_out<='0';
			end if;
		elsif(C_in='0' and Z_in='0') then
				C_flag<=C_dummy;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
		else
			C_flag<=C_flag_in;
			Z_flag<=Z_flag_in;
			CZ_Write_Out<='0';
		end if;


elsif(Op_in="0010") then
		ALU_out<=t3;
		if(C_in='1' and Z_in='0') then
			if(C_flag_in='1') then
				C_flag<=C_flag_in;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
			else
				C_flag<=C_flag_in;
				Z_flag<=Z_flag_in;
				CZ_write_out<='0';
			end if;
		elsif(C_in='0' and Z_in='1') then
			if(Z_flag_in='1') then
				C_flag<=C_flag_in;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
			else
				C_flag<=C_flag_in;
				Z_flag<=Z_flag_in;
				CZ_write_out<='0';
			end if;
		elsif(C_in='0' and Z_in='0') then
				C_flag<=C_flag_in;
				Z_flag<=Z_dummy;
				CZ_write_out<='1';
		else
			C_flag<=C_flag_in;
			Z_flag<=Z_flag_in;
			CZ_Write_Out<='0';
		end if;
elsif(OP_in="0001") then
		ALU_out<=t3;
		C_flag<=C_dummy;
		Z_flag<=Z_dummy;
		CZ_Write_Out<='1';
else
		C_flag<=C_flag_in;
		Z_flag<=Z_flag_in;
		CZ_write_out<='0';
		ALU_out<=t3;
end if;

PC_out<=PC_in;
Op_out<=Op_in;
Imm6_out<=Imm6_extended;
Imm9_out<=Imm9_in;
RD_out<=RD_in;
C_out<=C_in;
Z_out<=Z_in;

if(Op_in="1100") then
	t5<=PC_in;
	t6<=Imm6_extended;
elsif(Op_in="1000") then
	t5<=PC_in;
	t6<=Imm9_extended;
end if;


if(Op_in="1001") then
	PC_updated<=t2;
else
	PC_updated<=t7;
end if;

end process;

end myArch;
