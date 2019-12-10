library IEEE;
use IEEE.std_logic_1164.all;

entity InstructionDecode is
port(
PC_in : in std_logic_vector(15 downto 0);
IR : in std_logic_vector(15 downto 0);
clk: in std_logic;
PC_out: out std_logic_vector(15 downto 0);
OP: out std_logic_vector(3 downto 0);
RA,RB,RC : out std_logic_vector(2 downto 0);
Imm6 : out std_logic_vector(5 downto 0);
Imm9 : out std_logic_vector(8 downto 0);
C,Z : out std_logic
);
end entity InstructionDecode;

architecture myarch of InstructionDecode is

begin

  PC_out <= PC_in;
  OP <= IR(15 downto 12);
  RA <= IR(11 downto 9);
  RB <= IR(8 downto 6);
  RC <= IR(5 downto 3);
  Imm6 <= IR(5 downto 0);
  Imm9 <= IR(8 downto 0);
  C <= IR(1);
  Z <= IR(0);

end myarch;
