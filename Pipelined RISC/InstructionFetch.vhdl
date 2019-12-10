library IEEE;
use IEEE.std_logic_1164.all;


entity InstructionFetch is
port(
PC_in : in std_logic_vector(15 downto 0);
clk: in std_logic;
PC_out: out std_logic_vector(15 downto 0);
IR: out std_logic_vector(15 downto 0);
PC_old: out std_logic_vector(15 downto 0)
);
end entity InstructionFetch;


architecture myarch of InstructionFetch is

component ALU is
port(
	a: in std_logic_vector(15 downto 0);
	b: in std_logic_vector(15 downto 0);
	p: in std_logic_vector(1 downto 0);
	SOUT: out std_logic_vector(15 downto 0); C,Z : out std_logic);
end component ALU;

component Memory_code is
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end component;

signal t1,t2 :std_logic;

begin

	memory_pc : Memory_code port map(PC_in,"0000000000000000",clk,'1',IR);
	alu_pc: ALU port map(PC_in,"0000000000000001","00",PC_out,t1,t2);
	PC_old<=PC_in;

end myarch;
