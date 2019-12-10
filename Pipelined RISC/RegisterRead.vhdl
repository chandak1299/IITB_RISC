library IEEE;
use IEEE.std_logic_1164.all;

entity RegisterRead is
port(
clk: in std_logic;
PC_in : in std_logic_vector(15 downto 0);
OP_in: in std_logic_vector(3 downto 0);
RA_in,RB_in,RC_in: in std_logic_vector(2 downto 0);
Imm6_in : in std_logic_vector(5 downto 0);
Imm9_in : in std_logic_vector(8 downto 0);
C_in,Z_in : in std_logic;
RegA_in:in std_logic_vector(15 downto 0);
RegB_in:in std_logic_vector(15 downto 0);
PC_out : out std_logic_vector(15 downto 0);
OP_out: out std_logic_vector(3 downto 0);
Raddress_out:out std_logic_vector(2 downto 0);
Imm6se_out : out std_logic_vector(15 downto 0);
Imm9_out : out std_logic_vector(8 downto 0);
Imm9_SE_out:out std_logic_vector(15 downto 0);
C_out,Z_out:out std_logic;
Opr1_out,Opr2_out:out std_logic_vector(15 downto 0);
RegA_out:out std_logic_vector(15 downto 0)
);
end entity RegisterRead;


architecture xyz of RegisterRead is

component signextension7 is
	port( Zin1 :in std_logic_vector(8 downto 0);
			Zout1 : out std_logic_vector(15 downto 0));
end component;

component signextension10 is
	port( Zin :in std_logic_vector(5 downto 0);
			Zout : out std_logic_vector(15 downto 0));
end component;


signal signext6:std_logic_vector(15 downto 0);
signal signext9:std_logic_vector(15 downto 0);

begin
	sgn10: signextension10 port map (Imm6_in,signext6);
	sgn7: signextension7 port map (Imm9_in,signext9);

	process(all)

	begin

		PC_out<=PC_in;
		OP_out<=OP_in;

		if(OP_in="0000" or OP_in="0010") then
			Raddress_out<=RC_in;
		elsif(OP_in="0001") then
			Raddress_out<=RB_in;
		else
			Raddress_out<=RA_in;
		end if;

		if(RA_in="111") then
			Rega_out<=PC_in;
		else
			RegA_out<=RegA_in;
		end if;
		C_out<=C_in;
		Z_out<=Z_in;
		Imm9_Out<=Imm9_In;
		Imm6se_Out<=signext6;
		Imm9_SE_out<=signext9;

		if(OP_in="0000" or OP_in="0010" or OP_in="0001" or OP_in="1100") then
			if(RA_in="111") then
				Opr1_out<=PC_in;
			else
				Opr1_out<=RegA_in;
			end if;
		elsif(OP_in="0100" or OP_in="0101") then
			Opr1_out<=signext6;
		end if;

		if(OP_in="0000" or OP_in="0010" or OP_in="1100" or OP_in="1001") then
			if(RB_in="111") then
				Opr2_out<=PC_in;
			else
				Opr2_out<=RegB_in;
			end if;
		elsif(OP_in="0001") then
			Opr2_out<=signext6;
		elsif(OP_in="0100" or OP_in="0101") then
			if(RB_in="111") then
				Opr2_out<=PC_in;
			else
				Opr2_out<=RegB_in;
			end if;
		elsif(OP_in="0111") then
			Opr2_out<=RegB_in;
		else
			Opr2_out<=signext9;
		end if;


	end process;

end xyz;
