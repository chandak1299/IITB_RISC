library IEEE;
use IEEE.std_logic_1164.all;


entity Equal_16 is

	port(X: in std_logic_vector(15 downto 0);Y: in std_logic_vector(15 downto 0);
		A: out std_logic_vector(15 downto 0));

end entity;

architecture myarch of Equal_16 is
signal S: std_logic_vector(15 downto 0);
signal q,c :std_logic;
begin
S(0) <= X(0) xor Y(0);
S(1) <= X(1) xor Y(1);
S(2) <= X(2) xor Y(2);
S(3) <= X(3) xor Y(3);
S(4) <= X(4) xor Y(4);
S(5) <= X(5) xor Y(5);
S(6) <= X(6) xor Y(6);
S(7) <= X(7) xor Y(7);
S(8) <= X(8) xor Y(8);
S(9) <= X(9) xor Y(9);
S(10) <= X(10) xor Y(10);
S(11) <= X(11) xor Y(11);
S(12) <= X(12) xor Y(12);
S(13) <= X(13) xor Y(13);
S(14) <= X(14) xor Y(14);
S(15) <= X(15) xor Y(15);

q <= S(0) or S(1) or S(2) or S(3) or S(4) or S(5) or S(6) or S(7) or S(8) or S(9) or S(10) or S(11) or S(12) or S(13) or S(14) or S(15);
c<=not q;

A(0) <=c;
A(1) <=c;
A(2) <=c;
A(3) <=c;
A(4) <=c;
A(5) <=c;
A(6) <=c;
A(7) <=c;
A(8) <=c;
A(9) <=c;
A(10) <=c;
A(11) <=c;
A(12) <=c;
A(13) <=c;
A(14) <=c;
A(15) <=c;
end myarch;
