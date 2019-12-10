library IEEE;
use IEEE.std_logic_1164.all;

entity Adder_16 is

port(
	a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
	sum: out std_logic_vector(15 downto 0);        cout : out std_logic);

end entity Adder_16;

architecture myarch of Adder_16 is

 component Full_Adder is

    port (
    A, B, Cin: in std_logic;
    S, Cout: out std_logic);

    end component;

  signal tA, tB, tC, tD, tE, tF, tG, tH,ti,tj,tk,tl,tm,tn,tp,tq : std_logic;

begin

tA <= '0';

I1: Full_Adder port map(a(0), b(0), tA, sum(0), tB);
I2: Full_Adder port map(a(1), b(1), tB, sum(1), tC);
I3: Full_Adder port map(a(2), b(2), tC, sum(2), tD);
I4: Full_Adder port map(a(3), b(3), tD, sum(3), tE);
I5: Full_Adder port map(a(4), b(4), tE, sum(4), tF);
I6: Full_Adder port map(a(5), b(5), tF, sum(5), tG);
I7: Full_Adder port map(a(6), b(6), tG, sum(6), tH);
I8: Full_Adder port map(a(7), b(7), tH, sum(7), ti);
I12: Full_Adder port map(a(8), b(8), ti, sum(8), tj);
I13: Full_Adder port map(a(9), b(9), tj, sum(9), tk);
I14: Full_Adder port map(a(10), b(10), tk, sum(10), tl);
I15: Full_Adder port map(a(11), b(11), tl, sum(11), tm);
I16: Full_Adder port map(a(12), b(12), tm, sum(12), tn);
I17: Full_Adder port map(a(13), b(13), tn, sum(13), tp);
I18: Full_Adder port map(a(14), b(14), tp, sum(14), tq);
I11: Full_Adder port map(a(15), b(15), tq, sum(15), Cout);

end myarch;
