library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
	port(CLK,RF_Wr,RF_wr_R7: in std_logic;
		  RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
		  RF_D3,RF_D4: in std_logic_vector(15 downto 0);
		  RF_D1,RF_D2: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of RF is
--	signal R0:std_logic_vector(15 downto 0) :="0000000000000000";
--	signal R1:std_logic_vector(15 downto 0) :="0000000000000001";
--	signal R2:std_logic_vector(15 downto 0) :="0000000000000010";
--	signal R3:std_logic_vector(15 downto 0) :="0000000000000011";
--	signal R4:std_logic_vector(15 downto 0) :="0000000000000000";
--	signal R5:std_logic_vector(15 downto 0) :="0000000000000001";
--	signal R6:std_logic_vector(15 downto 0) :="0000000000000010";
--	signal R7:std_logic_vector(15 downto 0) :="0000000000000011";
	type reg_file is array(0 to 7) of std_logic_vector(15 downto 0);
	signal register_file:reg_file:=(0=>x"000A",1=>x"0001",2=>x"000C",3=>x"0100",4=>x"FFEB",5=>x"FFFB",6=>x"0018",7=>x"0010");
begin
--	RF_D1<=R0 when (RF_A1="000") else
--			  R1 when (RF_A1="001") else
--			  R2 when (RF_A1="010") else
--			  R3 when (RF_A1="011") else
--			  R4 when (RF_A1="100") else
--			  R5 when (RF_A1="101") else
--			  R6 when (RF_A1="110") else
--			  R7 when (RF_A1="111");
	RF_D1<=register_file(to_integer(unsigned(RF_A1)));
	RF_D2<=register_file(to_integer(unsigned(RF_A2)));
--	RF_D2<=R0 when (RF_A2="000") else
--			  R1 when (RF_A2="001") else
--			  R2 when (RF_A2="010") else
--		     R3 when (RF_A2="011") else
--		     R4 when (RF_A2="100") else
--		     R5 when (RF_A2="101") else
--		     R6 when (RF_A2="110") else
--		     R7 when (RF_A2="111");		  
			  
process (RF_wr,RF_D3,RF_A3,clk)
	begin
	if(RF_wr='1') then
		if(rising_edge(clk)) then
			Register_file(to_integer(unsigned(RF_A3)))<=RF_D3;
		end if;
	end if;
	if(rising_edge(clk) and RF_wr_R7='1') then
		Register_file(7)<=RF_D4;
	end if;
end process;
end Behave;