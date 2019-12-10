library IEEE;
use IEEE.std_logic_1164.all;

entity Mem is
	port(
	clk: in std_logic;
	PC_in : in std_logic_vector(15 downto 0);
	Op_in: in std_logic_vector(3 downto 0);
	RegA_in: in std_logic_vector(15 downto 0);
	Imm9_in: in std_logic_vector(8 downto 0);
	RD_in: in std_logic_vector(2 downto 0);
	C_in,Z_in: in std_logic;
	Data_multiple: in std_logic_vector(15 downto 0);
	ALU_out: in std_logic_vector(15 downto 0);
	CZ_write_in: in std_logic;
	PC_out: out std_logic_vector(15 downto 0);
	Op_out: out std_logic_vector(3 downto 0);
	Imm9_out: out std_logic_vector(8 downto 0);
	RD_out: out std_logic_vector(2 downto 0);
	Rdata_Out:out std_logic_vector(15 downto 0);
	RegA_out: out std_logic_vector(15 downto 0);
	Addr_read: out std_logic_vector(15 downto 0);
	Addr_write: out std_logic_vector(15 downto 0);
	Data_write: out std_logic_vector(15 downto 0);
	C_out,Z_out: out std_logic;
	CZ_write_out:out std_logic
	);
end entity Mem;

architecture myArch of Mem is
signal t1, t2, t3: std_logic_vector(15 downto 0);

begin

process(all)

begin

if(Op_in="0100") then
	t1<=ALU_out;
elsif(Op_in="0110") then
	t1<=RegA_in;
end if;

if(Op_in="0101") then
	t2<=ALU_out;
	t3<=RegA_in;
elsif(Op_in="0111") then
	t2<=RegA_in;
	t3<=Data_multiple;
end if;

Rdata_out<=ALU_Out;
Addr_read<=t1;
Addr_write<=t2;
Data_write<=t3;

PC_out<=PC_in;
Op_out<=Op_in;
Imm9_out<=Imm9_in;
RD_out<=RD_in;
C_out<=C_in;
Z_out<=Z_in;
CZ_write_out<=CZ_write_in;
RegA_out<=RegA_in;

end process;

end myArch;
