library IEEE;
use IEEE.std_logic_1164.all;

entity Nand_16 is

	port(X: in std_logic_vector(15 downto 0);Y: in std_logic_vector(15 downto 0);
		S: out std_logic_vector(15 downto 0));

end entity;

architecture myarch of Nand_16 is
begin
S(0) <= X(0) nand Y(0);
S(1) <= X(1) nand Y(1);
S(2) <= X(2) nand Y(2);
S(3) <= X(3) nand Y(3);
S(4) <= X(4) nand Y(4);
S(5) <= X(5) nand Y(5);
S(6) <= X(6) nand Y(6);
S(7) <= X(7) nand Y(7);
S(8) <= X(8) nand Y(8);
S(9) <= X(9) nand Y(9);
S(10) <= X(10) nand Y(10);
S(11) <= X(11) nand Y(11);
S(12) <= X(12) nand Y(12);
S(13) <= X(13) nand Y(13);
S(14) <= X(14) nand Y(14);
S(15) <= X(15) nand Y(15);
end myarch;
