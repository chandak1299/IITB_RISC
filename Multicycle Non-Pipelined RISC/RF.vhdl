library ieee;
use ieee.std_logic_1164.all;

entity RF is
	port(CLK,RF_Wr: in std_logic;
		  RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
		  RF_D3: in std_logic_vector(15 downto 0);
		  RF_D1,RF_D2: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of RF is
	signal R0,R1,R2,R3,R4,R5,R6,R7:std_logic_vector(15 downto 0);
--	signal R0,R1,R2,R3:std_logic_vector(15 downto 0);
--	signal R0:std_logic_vector(15 downto 0) :="0000000000000011";
--	signal R1:std_logic_vector(15 downto 0) :="0000000000000011";
--	signal R2:std_logic_vector(15 downto 0) :="0000000000000000";
--	signal R3:std_logic_vector(15 downto 0) :="0000000000000001";
--	signal R4:std_logic_vector(15 downto 0) :="0000000000000000";
--	signal R5:std_logic_vector(15 downto 0) :="0000000000000001";
--	signal R6:std_logic_vector(15 downto 0) :="0000000000000010";
--	signal R7:std_logic_vector(15 downto 0) :="0000000000000011";
-- signal R7:std_logic_vector(15 downto 0) :="0000000000000000";
-- signal R4,R5,R6,R7:std_logic_vector(15 downto 0);
begin
	RF_D1<=R0 when (RF_A1="000") else
			  R1 when (RF_A1="001") else
			  R2 when (RF_A1="010") else
			  R3 when (RF_A1="011") else
			  R4 when (RF_A1="100") else
			  R5 when (RF_A1="101") else
			  R6 when (RF_A1="110") else
			  R7 when (RF_A1="111");
	RF_D2<=R0 when (RF_A2="000") else
			  R1 when (RF_A2="001") else
			  R2 when (RF_A2="010") else
		     R3 when (RF_A2="011") else
		     R4 when (RF_A2="100") else
		     R5 when (RF_A2="101") else
		     R6 when (RF_A2="110") else
		     R7 when (RF_A2="111");		  
			  
process (RF_wr,RF_D3,RF_A3,clk)
	begin
	if(RF_wr='1') then
		if(rising_edge(clk)) then
			if(RF_A3="000") then
				R0<=RF_D3;
			elsif(RF_A3="001") then
				R1<=RF_D3;
			elsif(RF_A3="010") then 
				R2<=RF_D3;
			elsif(RF_A3="011") then 
				R3<=RF_D3;
			elsif(RF_A3="100") then
				R4<=RF_D3;
			elsif(RF_A3="101") then
				R5<=RF_D3;
			elsif(RF_A3="110") then 
				R6<=RF_D3;	
			elsif(RF_A3="111") then
				R7<=RF_D3;	
			end if;	
		end if;
	end if;
end process;
end Behave;