library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
port(
	a: in std_logic_vector(15 downto 0);
   b: in std_logic_vector(15 downto 0);
   p: in std_logic_vector(1 downto 0);
	SOUT: out std_logic_vector(15 downto 0); C,Z : out std_logic);
end entity ALU;

architecture dut_Wrap of ALU is

component Adder_16 is
port(a: in std_logic_vector(15 downto 0);b: in std_logic_vector(15 downto 0);sum: out std_logic_vector(15 downto 0); cout : out std_logic);
end component;

component Equal_16 is
port(X: in std_logic_vector(15 downto 0);Y: in std_logic_vector(15 downto 0);A: out std_logic_vector(15 downto 0));
end component;

component Nand_16 is
port(X: in std_logic_vector(15 downto 0);Y: in std_logic_vector(15 downto 0);S: out std_logic_vector(15 downto 0));
end component;

signal tA, tL, tR, tM: std_logic_vector(7 downto 0);
signal o1,o2,o3,s1,s2,s: std_logic_vector(15 downto 0);
signal cou: std_logic;
signal w1,w2 : std_logic;

begin
a1: Adder_16 port map(a,b,o1,cou);
ml1: Nand_16 port map(a,b,o2);
ml2: Equal_16 port map(a,b,o3);
w1<=p(1);
w2<=p(0);


gen_0 : for i in 0 to 15 generate
S(i)<= ((not w2) and (not w1) and o1(i) ) or ((not w1) and w2 and o2(i)) or ((not w2) and w1 and o3(i));
end generate gen_0;

z <= not(S(0) or S(1) or S(2) or S(3) or S(4) or S(5) or S(6) or S(7) or S(8) or S(9) or S(10) or S(11) or S(12) or S(13) or S(14) or S(15));
Sout<=s;
C<=(not w1) and (not w2) and cou;
end dut_Wrap;
