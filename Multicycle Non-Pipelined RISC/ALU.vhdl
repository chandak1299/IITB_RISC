library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(Op: in std_logic_vector(1 downto 0);
		  A,B: in std_logic_vector(15 downto 0);
		  O: out std_logic_vector(15 downto 0);
		  Z: out std_logic);
end entity;
		  
architecture Behave of ALU is
	signal C,D:std_logic_vector(16 downto 0);		
	signal Add,Nan,Sub,minusB:std_logic_vector(15 downto 0);
	signal equ:std_logic;
begin
	C(0)<='0';
	gen_for1:
		for i in 0 to 15 generate
			C(i+1) <= ((A(i) or B(i)) and C(i)) or (A(i) and B(i));
			Add(i) <= A(i) xor B(i) xor C(i);
	end generate gen_for1;
	Nan<=A nand B;
	D(0)<='1';
	minusB<=not(B);
	gen_for2:
		for i in 0 to 15 generate
			D(i+1) <= ((A(i) or B(i)) and D(i)) or (A(i) and B(i));
			Sub(i) <= A(i) xor B(i) xor D(i);
	end generate gen_for2;
	equ<= '0' when (A=B) else   -- 0 when equality
			'1';					
	O<= Add when (Op="00") else
		 Nan when (Op="01") else
		 Add when (Op="10") else  -- Dont care
		 Sub when (Op="11");
	Z<= C(16) when (Op="00") else
		 '0' when (Op="01") else
		 equ when (Op="10") else
		 D(16) when (Op="11"); 
end Behave;	 
		 
	
	
		