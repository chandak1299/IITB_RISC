--Group Members - 
--Siddharth Chandak - 17D070019
--Abhishek Tanpure - 17D070018
--Sammed Mangale - 17D070025
--Naman Narang - 17D070012
--Laxman Kumar - 160070030
library ieee;
use ieee.std_logic_1164.all;

entity IITB_Proc is
   port (CLK,reset: in std_logic
		);
end entity;

architecture Behave of IITB_Proc is

 type FSM_State is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26,S27,S28);
  signal state : FSM_State;
 
    
  signal IR, T1, T2, T3,Mem_A1,Mem_D1,Mem_D2,A1,A2,A3,B1,B2,B3,Rf_D1,Rf_D2,RF_D3,Rf_Dout,Mem_Dout: std_logic_vector(15 downto 0);
  signal PC:std_logic_vector(15 downto 0):="0000000000000000";
  signal A0,B0 : std_logic_vector(1 downto 0);
  signal RF_A1,RF_A2,Rf_A3 : std_logic_vector(2 downto 0);
  signal A4,B4,RF_Write,Mem_Write : std_logic;
  signal C,Z:std_logic:='0';
  
  component ALU is
	port(Op: in std_logic_vector(1 downto 0);
		  A,B: in std_logic_vector(15 downto 0);
		  O: out std_logic_vector(15 downto 0);
		  Z: out std_logic);
  end component;
  
	component RF is
		port(CLK,RF_Wr: in std_logic;
		  RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
		  RF_D3: in std_logic_vector(15 downto 0);
		  RF_D1,RF_D2: out std_logic_vector(15 downto 0));
	end component; 
  
  component Mem is 
	 port (CLK,Reset,Mem_wr: in std_logic;
			Mem_A,Mem_Din: in std_logic_vector(15 downto 0);
			Mem_Dout: out std_logic_vector(15 downto 0));
  end component;
  
begin
  
  ALU1 : ALU port map(A0,A1,A2,A3,A4);
  ALU2 : ALU port map(B0,B1,B2,B3,B4);
  
  RF1: RF port map(CLK,RF_Write,RF_A1,RF_A2,RF_A3,RF_D3,RF_D1,RF_D2);
  
  Mem1 : Mem port map(clk,Reset,Mem_Write,Mem_A1,Mem_D2,Mem_D1);
  
  process(reset,CLK,State,T1,T2,T3,PC,IR,C,Z)
  
     variable n_PC, n_T1, n_T2, n_T3 : std_logic_vector(15 downto 0);
	  variable n_state : FSM_State;
	  
  begin
	  n_T1:=T1;
	  n_T2:=T2;
	  n_T3:=T3;
     case State is
	  
       when S0 =>

    		 Mem_Write<='0';
			 Mem_A1 <= PC;
			 Mem_D2<="0000000000000000";
		  	 IR <= Mem_D1;
			 A0 <= "00";
			 A1 <= PC;
			 A2 <= "0000000000000001";
			 n_PC := A3;
			 
			 if(IR(15 downto 12) = "0011") then
			 n_State := S8;
			 
			 elsif(IR(15 downto 12) = "1000") then
			 n_State := S24;
			 
			 else 
			 n_State := S1;
			 
			 end if;
			 
       when S1 =>
			 
		 	 RF_Write<='0';
			 RF_A1 <= IR(11 downto 9);
			 RF_A2 <= IR(8 downto 6);
			 RF_A3 <= "000";
			 RF_D3 <= "0000000000000000";
			 n_T1 := RF_D1;
			 n_T2 := RF_D2;
			
 
          --AD	
   		 if(IR(15 downto 12) = "0000") then
				 if (IR(1 downto 0) = "00") then 
							n_state := S2;
				 elsif (IR(1 downto 0) = "10") then
						if(C = '1') then
							n_state := S2;
						else 
							n_state := S0;
						end if;
				 elsif (IR(1 downto 0) = "01") then		
						if(Z = '1') then
							n_state := S2;
						else 
							n_state := S0;
						end if;		
				 end if;			  
			 end if;
			 
			 
			 
			 -- NAN
			 if(IR(15 downto 12) = "0010") then
				 if (IR(1 downto 0) = "00") then 
							n_state := S5;
				 elsif (IR(1 downto 0) = "10") then
						if(C = '1') then
							n_state := S5;
						else 
							n_state := S0;
						end if;
				 elsif (IR(1 downto 0) = "01") then		
						if(Z = '1') then
							n_state := S5;
						else 
							n_state := S0;
						end if;		
				 end if;			  
			 end if;
			 
			 
			 
			 --ADI
			 if(IR(15 downto 12) = "0001") then
				n_State := S6;
			 end if;			
			
			 --BEQ
			 if(IR(15 downto 12) = "1100") then
				n_State := S23;
			 end if;
			 
			 --JLR
			 if(IR(15 downto 12) = "1001") then
				n_State := S24;
			 end if;
			 
			 --LA
			 if(IR(15 downto 12) = "0110") then
				n_State := S13;
			 end if;
			 
			 --SA
			 if(IR(15 downto 12) = "0111") then
				n_State := S19;
			 end if;
			 
			 --LW
			 if(IR(15 downto 12) = "0100") then
				n_State := S10;
			 end if;

			 --SW
			 if(IR(15 downto 12) = "0101") then
				n_State := S10;				
			 end if;
			
       when S2 =>
			 
			 A0 <= "00";
			 A1 <= T1;
			 A2 <= T2;
			 n_T1 := A3;
			 c <= A4;
			 n_State := S3;
			 
			 
		 when	S3 => 
			 
			 B0 <= "10";
			 B1 <= T1;
			 B2 <= "0000000000000000"; 
			 Z <= not(B4);
			 
			 if(IR(15 downto 12) = "0001") then 
				n_State := S7;
				
			 elsif(IR(15 downto 12) = "0100") then
				n_State := S0;
				
			 else 	
				n_State := S4;
				
			 end if;
		
		
		 when S4 =>
			
			 RF_Write <='1';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_A3 <= IR(5 downto 3);
			 RF_D3 <= T1;
			 n_State := S0;

       when S5 =>
			 
			 A0 <= "01";
			 A1 <= T1;
			 A2 <= T2;
			 n_T1 := A3;
			 c <= A4;
			 n_State := S3;

       when S6 =>
			 
			 A0 <= "00";
			 if(IR(5)='0') then 
				A1(15 downto 6) <= "0000000000";
				A1(5 downto 0) <= IR(5 downto 0);
			 else 
				A1(15 downto 6) <= "1111111111";
				A1(5 downto 0) <= IR(5 downto 0);
			 end if;
			 A2 <= T2;
			 n_T2 := A3;
			 C <= A4;
			 n_State := S3;
			 
		 when S7 => 
		 
			 RF_Write <='1';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_A3 <= IR(11 downto 9);
			 RF_D3 <= T2;
			 n_State := S0;
			 
		--S9 are remaining	
		 when S8 =>

			 n_T1(15 downto 7) := IR(8 downto 0);
			 n_T1(6 downto 0) := "0000000";
		 		 
		    n_State := S9;
		 
		 when S9 =>		 

			 RF_Write <='1';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_A3 <= IR(11 downto 9);
			 RF_D3 <= T1;
		 
		    n_State := S0;
		 
		 when S10 =>

			 A0 <= "00";
			 A1 <= T2;
			 if(IR(5)='0') then 
				A2(15 downto 6) <= "0000000000";
				A2(5 downto 0) <= IR(5 downto 0);
			 else 
				A2(15 downto 6) <= "1111111111";
				A2(5 downto 0) <= IR(5 downto 0);
			 end if;
			 n_T2 := A3;		 
		 
			 if(IR(15 downto 12) = "0100") then 
				n_State := S11;
				
			 else 
				n_State := S22;
				
			 end if;	
				
		 when S11 =>

			Mem_Write <= '0';  
		   Mem_A1 <= T2;
			Mem_D2<="0000000000000000";
			n_T1 := Mem_D1;
		 		 
		   n_State := S12;			
				
		 when S12 =>

		   RF_Write <='1';
			RF_A1 <= "000";
			RF_A2 <= "000";
		   RF_A3 <= IR(11 downto 9);
			RF_D3 <= T1;
	 
   	    n_State := S3;
	
		 when S13 =>

			 Mem_Write <= '0';
			 Mem_A1 <= T1;
			 Mem_D2 <= "0000000000000000";
			 n_T3 := Mem_D1;
			 n_T2 := "0000000000000000";
		 
		    n_State := S14;
	
		 when S14 =>

			 RF_Write <= '1';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_A3 <= T2(2 downto 0);
			 RF_D3 <= T3; 		 
		 
		    n_State := S15;			
	
		 when S15 =>

			 B0 <= "10";
			 B1 <= T2;
			 B2 <= "0000000000000111";

		    if(B4 = '0') then
				n_State := S0;
			
		  	 else 
            n_State := S16;
       
          end if;		 
	
		 when S16 =>

			 A0 <= "00";
			 A1 <= T1;
			 A2 <= "0000000000000001";
			 n_T1 := A3;
		 		 
		    n_State := S17;		
			
		 when S17 =>			

			 A0 <= "00";
			 A1 <= T2;
			 A2 <= "0000000000000001";
			 n_T2 := A3;
		 		 
			 if(IR(15 downto 12) = "0110") then 
				n_State := S18;
				
			 else 
				n_State := S21;
					
			 end if;
			 
		 when S18 =>	

		 		    Mem_Write <= '0';
			 Mem_A1 <= T1;
			 Mem_D2 <= "0000000000000000";
			 n_T3 := Mem_D1;
		 
		    n_State := S14;


		 when S19 =>	

			 n_T2 := "0000000000000000";
			 RF_Write <= '0';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 n_T3 := RF_D1;
			 RF_A3 <= "000";
			 RF_D3 <= "0000000000000000"; 
		 
		    n_State := S20;

			 
		 when S20 =>	

			 Mem_write <= '1';
			 Mem_A1 <= T1;
			 Mem_D2 <= T3;
		 
		    n_State := S15;

			 
		 when S21 =>	

		    RF_Write <= '0';
			 RF_A1 <= T2(2 downto 0);
			 RF_A2 <= "000";
			 RF_A3 <= "000";
			 RF_D3 <= "0000000000000000";
			 n_T3 := RF_D1;
		 
		    n_State := S20;
			 

		 when S22 =>	

			Mem_Write <= '1';  
		   Mem_A1 <= T2;
			Mem_D2 <= T1;
		 
		    n_State := S0;


       when S23 =>
			 
			 B0 <= "10";
			 B1 <= T1;
			 B2 <= T2;
			 n_T1 := B3;
			 if(B4 = '0') then 
				n_State := S24;	
			 else 
				n_State := S0;
				
			 end if;

			 
		 when	S24 => 
			 
			 B0 <= "00";
			 B1 <= PC;
			 B2 <= "1111111111111111"; 
			 n_PC := B3;
			 if(IR(15 downto 12) = "1001") then 
				n_State := S27;
				
			 elsif(IR(15 downto 12) = "1000") then 
				n_State := S26;
				
			 else 
				n_State := S25;
				
			 end if;	 
			 
		 when S25 =>
			
			 A0 <= "00";
			 A1 <= PC;
			 --A2
			 if(IR(5)='0') then 
				A2(15 downto 6) <= "0000000000";
				A2(5 downto 0) <= IR(5 downto 0);
			 else 
				A2(15 downto 6) <= "1111111111";
				A2(5 downto 0) <= IR(5 downto 0);
			 end if;
			 n_PC := A3;
			 n_State := S0;
			 
			 
       when S26 =>
			 
			 RF_Write<='1';
			 RF_A3 <= IR (11 downto 9);
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_D3 <= PC;
			 n_State := S28;


		 when S27 =>
			
			 RF_Write <='1';
			 RF_A1 <= "000";
			 RF_A2 <= "000";
			 RF_A3 <= IR(11 downto 9);
			 RF_D3 <= PC;
			 n_PC := T2;
			 n_State := S0;
			 
			 
		 when S28 =>
			
			 A0 <= "00";
			 A1 <= PC;
			 --A2
			 if(IR(5)='0') then 
				A2(15 downto 9) <= "0000000";
				A2(8 downto 0) <= IR(8 downto 0);
			 else 
				A2(15 downto 9) <= "1111111";
				A2(8 downto 0) <= IR(8 downto 0);
			 end if;
			 n_PC := A3;
			 n_State := S0;
	
	
       when others => null;

			end case;
		if(clk'event and clk = '1') then
          if(reset = '1') then
             State <= S0;
          else
             State <= n_State;
				 T1 <= n_T1;
				 T2 <= n_T2;
				 T3 <= n_T3;
				 PC <= n_PC; 
          end if;
     end if;		
		 
  end process;

end Behave;



