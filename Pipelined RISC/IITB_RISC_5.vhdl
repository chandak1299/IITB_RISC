library ieee;
use ieee.std_logic_1164.all;


entity IITB_Risc_5 is
   port (CLK,reset: in std_logic
		);
end entity;

architecture Behave of IITB_Risc_5 is

	signal PC,IF_ID_PC, ID_RR_PC ,RR_EX_PC, EX_MEM_PC, MEM_WB_PC : std_logic_vector(15 downto 0);
	signal IF_ID_IR : std_logic_vector(15 downto 0);
	signal ID_RR_OP ,RR_EX_OP, EX_MEM_OP, MEM_WB_OP : std_logic_vector(3 downto 0);
	signal ID_RR_RA, ID_RR_RB , ID_RR_RC, RR_EX_Radd, EX_MEM_Radd, MEM_WB_Radd : std_logic_vector(2 downto 0);
	signal RR_EX_RegA, Ex_MEM_RegA, MEM_WB_RegA : std_logic_vector(15 downto 0);
	signal RR_EX_OPR1, RR_EX_Opr2,Ex_MEM_ALUO : std_logic_vector(15 downto 0);
	signal RR_EX_IMM9SE : std_logic_vector(15 downto 0);
	signal ID_RR_IMM9, RR_EX_IMM9, EX_MEM_IMM9, MEM_WB_IMM9 :std_logic_vector(8 downto 0);
	signal ID_RR_IMM6:std_logic_vector(5 downto 0);
	signal RR_EX_IMM6SE:std_logic_vector(15 downto 0);
	signal Carry,Zero: std_logic;
	signal ID_RR_C ,RR_EX_C, EX_MEM_C: std_logic;
	signal ID_RR_Z ,RR_EX_Z, EX_MEM_Z: std_logic;
  signal Haz_cont1_EX_Mem,Haz_cont1_Mem_WB,Haz_Cont1_after_WB,Haz_cont2_EX_Mem,Haz_cont2_Mem_WB,Haz_cont2_after_WB:std_logic;
  signal Haz_cont1_EX_Mem_PC,Haz_cont1_Mem_WB_PC,Haz_Cont1_after_WB_PC,Haz_cont2_EX_Mem_PC,Haz_cont2_Mem_WB_PC,Haz_cont2_after_WB_PC:std_logic;
  signal Haz_cont1_EX_Mem_LHI,Haz_cont1_Mem_WB_LHI,Haz_cont2_EX_Mem_LHI,Haz_cont2_Mem_WB_LHI: std_logic;
  signal Data_after_WB,PC_after_WB:std_logic_vector(15 downto 0);
  signal Mem_WB_Rdata: std_logic_vector(15 downto 0);
  signal Ex_Mem_CZ_Write,Mem_WB_CZ_Write:std_logic;

	signal IF_ID_Flush : std_logic;
	signal Mul_Cont:std_logic;
	
	signal SM_begin_stall:std_logic_vector(1 downto 0); 

	component Adder_16 is
		port(
		a: in std_logic_vector(15 downto 0);
		b: in std_logic_vector(15 downto 0);
		sum: out std_logic_vector(15 downto 0);
		cout : out std_logic);
	end component Adder_16;
	
	component Priority is
		port(Reg_in: in std_logic_vector(8 downto 0);
		Reg_out: out std_logic_vector(8 downto 0);
		Reg_address: out std_logic_vector(2 downto 0);
		Control_out:out std_logic);	
	end component Priority;

  component RF is
		port(CLK,RF_Wr,RF_wr_R7: in std_logic;
		  RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
		  RF_D3,RF_D4: in std_logic_vector(15 downto 0);
		  RF_D1,RF_D2: out std_logic_vector(15 downto 0));
	end component;

  component Memory_data is
	 port (CLK,Reset,Mem_wr: in std_logic;
			Mem_A,Mem_Din: in std_logic_vector(15 downto 0);
			Mem_Dout: out std_logic_vector(15 downto 0));
  end component;

  component InstructionFetch is
		port(
		PC_in : in std_logic_vector(15 downto 0);
		clk: in std_logic;
		PC_out: out std_logic_vector(15 downto 0);
		IR: out std_logic_vector(15 downto 0);
		PC_old:out std_logic_vector(15 downto 0));
  end component InstructionFetch;

  component InstructionDecode is
		port(
		PC_in : in std_logic_vector(15 downto 0);
		IR : in std_logic_vector(15 downto 0);
		clk: in std_logic;
		PC_out: out std_logic_vector(15 downto 0);
		OP: out std_logic_vector(3 downto 0);
		RA,RB,RC : out std_logic_vector(2 downto 0);
		Imm6 : out std_logic_vector(5 downto 0);
		Imm9 : out std_logic_vector(8 downto 0);
		C,Z : out std_logic);
	end component InstructionDecode;

  component RegisterRead is
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
  end component RegisterRead;

  component Execute is
    port (
    clk: in std_logic;
    PC_in : in std_logic_vector(15 downto 0);
    Op_in: in std_logic_vector(3 downto 0);
    RegA_in: in std_logic_vector(15 downto 0);
    Opr1: in std_logic_vector(15 downto 0);
    Opr2: in std_logic_vector(15 downto 0);
    Imm6_extended: in std_logic_vector(15 downto 0);
    Imm9_in: in std_logic_vector(8 downto 0);
    Imm9_extended: in std_logic_vector(15 downto 0);
    RD_in: in std_logic_vector(2 downto 0);    --Address destination
    C_in,Z_in: in std_logic;
    Hazard1: in std_logic;
    Hazard2: in std_logic;
    Hazard_data1: in std_logic_vector(15 downto 0);
    Hazard_data2: in std_logic_vector(15 downto 0);
    Multiple_control: in std_logic;
    multiple_addr: in std_logic_vector(15 downto 0);
    C_flag_in,Z_Flag_in:in std_logic;
    C_flag,Z_flag: out std_logic;
    PC_out: out std_logic_vector(15 downto 0);
    Op_out: out std_logic_vector(3 downto 0);
    RegA_out: out std_logic_vector(15 downto 0);
    ALU_out: out std_logic_vector(15 downto 0);
    Imm6_out: out std_logic_vector(15 downto 0);
    Imm9_out: out std_logic_vector(8 downto 0);
    RD_out: out std_logic_vector(2 downto 0);
    PC_updated: out std_logic_vector(15 downto 0);
    C_out,Z_out: out std_logic;
    CZ_write_out:out std_logic
    );
  end component;

	component Mem is
    port(
    clk: in std_logic;
    PC_in : in std_logic_vector(15 downto 0);
    Op_in: in std_logic_vector(3 downto 0);
    RegA_in: in std_logic_vector(15 downto 0);
    Imm9_in: in std_logic_vector(8 downto 0);
    RD_in: in std_logic_vector(2 downto 0);
    C_in,Z_in: in std_logic;
    Data_multiple: in std_logic_vector(15 downto 0);
    ALU_out: in std_logic_vector(15 downto 0);
    CZ_write_in: in std_logic;
    PC_out: out std_logic_vector(15 downto 0);
    Op_out: out std_logic_vector(3 downto 0);
    Imm9_out: out std_logic_vector(8 downto 0);
    RD_out: out std_logic_vector(2 downto 0);
    Rdata_Out:out std_logic_vector(15 downto 0);
    RegA_out: out std_logic_vector(15 downto 0);
    Addr_read: out std_logic_vector(15 downto 0);
    Addr_write: out std_logic_vector(15 downto 0);
    Data_write: out std_logic_vector(15 downto 0);
    C_out,Z_out: out std_logic;
    CZ_write_out: out std_logic
    );
 	end component Mem;

  component WriteBack is
    port(
    clk:in std_logic;
    OP_in:in std_logic_vector(3 downto 0);
    PC_in:in std_logic_vector(15 downto 0);
    Raddress_in:in std_logic_vector(2 downto 0);
    Rdata_in:in std_logic_vector(15 downto 0);
    Imm9_in:in std_logic_vector(8 downto 0);
    CZ_write_in : in std_logic;
    Raddress_out:out std_logic_vector(2 downto 0);
    Write_control: out std_logic;
    Imm9_updated: out std_logic_vector(8 downto 0);
    LM_COntrol_out:out std_logic;
    Rdata_out:out std_logic_vector(15 downto 0)
    );
  end component;
	
	signal RF_write:std_logic;
	signal RF_A1,RF_a2,RF_A3: std_logic_vector(2 downto 0);
	signal RF_D1,RF_D2,RF_D3:std_logic_vector(15 downto 0);

	signal Mem_Write_data:std_logic;
	signal Mem_A1_data,Mem_D2_data,Mem_D1_data: std_logic_vector(15 downto 0);

	signal PC_new_IF,IR_IF,PC_old_IF: std_logic_vector(15 downto 0);

    signal PC_out_ID:std_logic_vector(15 downto 0);
    signal OP_ID:std_logic_vector(3 downto 0);
    signal RA_ID,Rb_ID,RC_ID:std_logic_vector(2 downto 0);
    signal IMM6_ID:std_logic_vector(5 downto 0);
    signal IMM9_ID:std_logic_vector(8 downto 0);
    signal C_ID,Z_ID:std_logic;

    signal PC_out_RR,IMM6SE_out_RR,Opr1_out_RR,Opr2_out_RR,RegA_in_RR,RegA_out_RR,RegB_in_RR,IMM9SE_out_RR:std_logic_vector(15 downto 0);
    signal OP_out_RR:std_logic_vector(3 downto 0);
    signal Raddress_RR:std_logic_vector(2 downto 0);
    signal IMM9_out_RR:std_logic_vector(8 downto 0);
    signal C_out_RR,Z_out_RR:std_logic;

    signal EX_Haz_Cont1,EX_Haz_Cont2,Carry_EX,Zero_EX,C_out_EX,Z_out_EX:std_logic;
    signal EX_Haz_Data1,EX_Haz_data2,PC_out_EX,RegA_out_EX,ALU_out_EX,PC_Imm_EX,Imm6_out_Ex:std_logic_vector(15 downto 0);
    signal OP_out_EX:std_logic_vector(3 downto 0);
    signal IMM9_out_EX:std_logic_vector(8 downto 0);
    signal Radd_out_EX:std_logic_vector(2 downto 0);
    signal CZ_Write_Out_Ex:std_logic;

    signal Mul_data_Mem,Mul_addr_Mem, PC_out_Mem,RegA_out_Mem,Addr_Read_out_Mem,Addr_Write_out_Mem,Data_Write_out_Mem,ALU_data_Mem:std_logic_vector(15 downto 0);
    signal OP_out_Mem:std_logic_vector(3 downto 0);
    signal IMM9_out_Mem:std_logic_vector(8 downto 0);
    signal Radd_out_Mem:std_logic_vector(2 downto 0);
    signal Rdata_out_Mem:std_logic_vector(15 downto 0);
    signal C_out_Mem,Z_out_Mem,CZ_write_out_Mem:std_logic;

    signal Rdata_out_WB:std_logic_vector(15 downto 0);
    signal R_addr_out_WB:std_logic_vector(2 downto 0);
    signal WR_out_WB,LMcontrol_out_WB:std_logic; 
	 signal Imm9_out_WB:std_logic_vector(8 downto 0);
	 
	 signal write_in_R7,next_PC:std_logic_vector(15 downto 0);
	 signal RF_write_R7,dumdum:std_logic;
	 
	 signal Pri_Imm9_in,Pri_Imm9_out:std_logic_vector(8 downto 0);
	 signal SM_radd:std_logic_vector(2 downto 0);
	 signal SM_cont,SM_dumdum:std_logic; 

begin

   RF1: RF port map(CLK,RF_Write,RF_write_R7,RF_A1,RF_A2,RF_A3,RF_D3,write_in_R7,RF_D1,RF_D2);

   Mem_data : Memory_data port map(clk,Reset,Mem_Write_data,Mem_A1_data,Mem_D2_data,Mem_D1_data);

	R7_adder:Adder_16 port map(Mem_WB_PC,"0000000000000001",next_PC,dumdum);
	
	Priority_SM:Priority port map(Pri_Imm9_in,Pri_Imm9_out,SM_Radd,SM_cont);

	IF1: InstructionFetch port map(
	PC,
	clk,
	PC_new_IF,
	IR_IF,
	PC_old_IF);

	ID1: InstructionDecode port map(
	IF_ID_PC,
	IF_ID_IR,
	clk,
	PC_out_ID,
	OP_ID,
	RA_ID,
	RB_ID,
	RC_ID,
	IMM6_ID,
	IMM9_ID,
	C_ID,
	Z_ID);

	RR1: RegisterRead port map(
  clk,
  ID_RR_PC,
  ID_RR_OP,
  ID_RR_RA,
  ID_RR_RB,
  ID_RR_RC,
  ID_RR_IMM6,
  ID_RR_IMM9,
  ID_RR_C,
  ID_RR_Z,
  RegA_in_RR,
  RegB_in_RR,
  PC_out_RR,
	OP_out_RR,
	Raddress_RR,
	IMM6SE_out_RR,
	IMM9_out_RR,
  Imm9SE_out_RR,
	C_out_RR,
	Z_out_RR,
	Opr1_out_RR,
	Opr2_out_RR,
	RegA_out_RR);

	Ex1: Execute port map(
	clk,
  RR_EX_PC,
  RR_EX_OP,
	RR_EX_RegA,
	RR_EX_OPr1,
	RR_EX_opr2,
	RR_EX_IMM6SE,
	RR_EX_IMM9,
  RR_EX_Imm9SE,
	RR_EX_Radd,
	RR_EX_C,
	RR_EX_Z,
	EX_Haz_Cont1,
	EX_Haz_Cont2,
	EX_Haz_data1,
	EX_Haz_data2,
	Mul_cont,
	EX_Mem_RegA,
  Carry,
  Zero,
	Carry_EX,
	Zero_EX,
	PC_out_EX,
	OP_out_EX,
	RegA_out_EX,
	ALU_out_EX,
  Imm6_out_Ex,   --No use, kept because it was hard to remove
	IMM9_out_EX,
	Radd_out_EX,
	PC_Imm_EX,
	C_out_EX,
	Z_out_EX,
  CZ_write_out_Ex);

	Mem1:Mem port map(
	clk,
  EX_Mem_PC,
	EX_Mem_OP,
	EX_Mem_RegA,
	EX_Mem_Imm9,
	EX_Mem_Radd,
	EX_Mem_C,
	EX_Mem_z,
	RR_EX_Opr2,
	Ex_MEM_ALUO,
  Ex_Mem_CZ_write,
	PC_out_Mem,
	OP_out_Mem,
	IMM9_out_Mem,
	Radd_out_Mem,
  Rdata_Out_Mem,
	RegA_out_Mem,
	Addr_Read_out_Mem,
	Addr_Write_out_Mem,
	Data_Write_out_Mem,
	C_out_Mem,    --No use of this, kept because hard to remove
	Z_out_Mem,    --No use of this, kept because hard to remove
	CZ_write_out_Mem);

	WriteBack1: WriteBack port map(
  clk,
	Mem_WB_OP,
	Mem_WB_PC,
	Mem_WB_Radd,
	Mem_WB_Rdata,
	Mem_WB_Imm9,
  Mem_WB_CZ_write,
  R_Addr_out_WB,
  WR_out_WB,
	IMM9_out_WB,
	LMControl_out_WB,
  Rdata_out_WB
	);

	process(all)

  variable Flush,Flush1,Stall_var: std_logic;
  variable Haz_cont1_EX_Mem_var,Haz_cont1_Mem_WB_var,Haz_Cont1_after_WB_var,Haz_cont2_EX_Mem_var,Haz_cont2_Mem_WB_var,Haz_cont2_after_WB_var: std_logic;
  variable Haz_cont1_EX_Mem_LHI_var,Haz_cont1_Mem_WB_LHI_var,Haz_cont2_EX_Mem_LHI_var,Haz_cont2_Mem_WB_LHI_var: std_logic;
  variable Haz_cont1_EX_Mem_PC_var,Haz_cont1_Mem_WB_PC_var,Haz_Cont1_after_WB_PC_var,Haz_cont2_EX_Mem_PC_var,Haz_cont2_Mem_WB_PC_var,Haz_cont2_after_WB_PC_var: std_logic;
  variable Haz_data_LHI_EX_Mem,Haz_data_LHI_Mem_WB,LHI_RR_EX: std_logic_vector(15 downto 0);
  
  variable Mul_Cont_var:std_logic;

	variable PC_var,IF_ID_PC_var, ID_RR_PC_var,RR_EX_PC_var, EX_MEM_PC_var, MEM_WB_PC_var : std_logic_vector(15 downto 0);
	variable IF_ID_IR_var : std_logic_vector(15 downto 0);
	variable ID_RR_OP_var,RR_EX_OP_var, EX_MEM_OP_var, MEM_WB_OP_var : std_logic_vector(3 downto 0);
	variable ID_RR_RA_var, ID_RR_RB_var, ID_RR_RC_var, RR_EX_Radd_var, EX_MEM_Radd_var, MEM_WB_Radd_var : std_logic_vector(2 downto 0);
	variable RR_EX_RegA_var, Ex_MEM_RegA_var, MEM_WB_RegA_var : std_logic_vector(15 downto 0);
	variable RR_EX_OPR1_var, RR_EX_Opr2_var,Ex_MEM_ALUO_var : std_logic_vector(15 downto 0);
	variable RR_EX_IMM9SE_var : std_logic_vector(15 downto 0);
	variable ID_RR_IMM9_var, RR_EX_IMM9_var, EX_MEM_IMM9_var, MEM_WB_IMM9_var :std_logic_vector(8 downto 0);
	variable ID_RR_IMM6_var :std_logic_vector(5 downto 0);
	variable RR_EX_IMM6SE_var :std_logic_vector(15 downto 0);
	variable Carry_var,Zero_var : std_logic;
	variable ID_RR_C_var,RR_EX_C_var, EX_MEM_C_var : std_logic;
	variable ID_RR_Z_var,RR_EX_Z_var, EX_MEM_Z_var : std_logic;
	variable Data_after_WB_var,PC_after_WB_var :std_logic_vector(15 downto 0);
  variable Mem_WB_Rdata_var:std_logic_vector(15 downto 0);
  variable Ex_Mem_CZ_Write_var,Mem_WB_CZ_Write_var:std_logic;
	variable IF_ID_Flush_var,LM_cont_var : std_logic;
	
	variable SM_begin_stall_var:std_logic_vector(1 downto 0);
	variable SM_later_stall_var,SM_dumdum_var:std_logic;

	begin

        Haz_cont1_EX_Mem_var:='0';
        Haz_cont1_Mem_WB_var:='0';
        Haz_Cont1_after_WB_var:='0';
        Haz_cont2_EX_Mem_var:='0';
        Haz_cont2_Mem_WB_var:='0';
        Haz_cont2_after_WB_var:='0';

        Haz_cont1_EX_Mem_LHI_var:='0';
        Haz_cont1_Mem_WB_LHI_var:='0';
        Haz_cont2_EX_Mem_LHI_var:='0';
        Haz_cont2_Mem_WB_LHI_var:='0';

        Haz_Cont1_EX_Mem_PC_var:='0';
        Haz_Cont1_Mem_WB_PC_var:='0';
        Haz_Cont1_after_WB_PC_var:='0';
        Haz_Cont2_EX_Mem_PC_var:='0';
        Haz_Cont2_Mem_WB_PC_var:='0';
        Haz_Cont2_after_WB_PC_var:='0';
		  
		  Mul_cont_var:='0';
		  LM_cont_var:='0';
		  
		  RF_write_R7<='1';
		  Flush1:='0';
		  Stall_var:='0';
		  
		  SM_begin_stall_var:="00";
		  SM_later_stall_var:='0';
		  SM_dumdum_var:='0';

        Haz_data_LHI_EX_Mem(15 downto 7):=EX_MEM_IMM9;    -- to be used when _ex_mem_lhi is 1
        Haz_data_LHI_EX_MEM(6 downto 0):="0000000";
        Haz_data_LHI_Mem_WB(15 downto 7):=MEM_WB_IMM9;   -- to be used when -mem_wb_lhi is 1
        Haz_data_LHI_MEM_WB(6 downto 0):="0000000";
		  LHI_RR_EX(15 downto 7):=RR_EX_Imm9;
		  LHI_RR_EX(6 downto 0):="0000000";

	-----------------Stalling_logic-------------------

		 if(RR_EX_OP = "0100" and not(RR_EX_Radd="111")) then
			if(ID_RR_OP = "0011" or ID_RR_OP = "1000") then
				Stall_var := '0';
			else
				if(ID_RR_OP = "0000" or ID_RR_OP = "0010" or ID_RR_OP = "0101" or ID_RR_OP = "1100") then
					if(RR_EX_Radd = ID_RR_RA or RR_EX_Radd = ID_RR_RB) then
						Stall_var := '1';
					else
						Stall_var := '0';
					end if;
				elsif(ID_RR_OP = "0001" or ID_RR_OP = "0110") then
					if(RR_EX_Radd = ID_RR_RA) then
						Stall_var := '1';
					else
						Stall_var := '0';
					end if;
				elsif(ID_RR_OP = "0100" or ID_RR_OP = "1001") then
					if(RR_EX_Radd = ID_RR_RB) then
						Stall_var := '1';
					else
						Stall_var := '0';
					end if;
			   elsif(ID_RR_OP = "0111") then
						Stall_var := '1';
				else
						Stall_var := '0';
				end if;
			end if;
		 elsif(RR_EX_OP="0110") then
			Stall_var:='1';
		 else
			Stall_var:='0';
		 end if;

       --R and R,SW,BEQ,JLR

       if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (RR_EX_OP="0000" or RR_EX_OP="0010" or RR_EX_OP="0001") and CZ_write_out_Ex='1') then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_MEM_var:='1';
            elsif(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_MEM_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (RR_EX_OP="0000" or RR_EX_OP="0010" or RR_EX_OP="0001") and CZ_write_out_Ex='1') then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_Mem_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (RR_EX_OP="0000" or RR_EX_OP="0010" or RR_EX_OP="0001") and CZ_write_out_Ex='1') then
        	if(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_Mem_var:='1';
            end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (EX_MEM_OP="0000" or EX_MEM_OP="0010" or EX_MEM_OP="0001")  and EX_Mem_CZ_Write='1') then
        	if(ID_RR_RA=EX_MEM_Radd) then
            	Haz_Cont1_Mem_WB_var:='1';
            elsif(ID_RR_RB=EX_MEM_Radd) then
            	Haz_Cont2_Mem_WB_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (EX_MEM_OP="0000" or EX_MEM_OP="0010" or EX_MEM_OP="0001")  and EX_Mem_CZ_Write='1') then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (EX_MEM_OP="0000" or EX_MEM_OP="0010" or EX_MEM_OP="0001")  and EX_Mem_CZ_Write='1') then
        	if(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_var:='1';
            end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (MEM_WB_OP="0000" or MEM_WB_OP="0010" or MEM_WB_OP="0001") and Mem_WB_CZ_Write='1') then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';
            elsif(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (MEM_WB_OP="0000" or MEM_WB_OP="0010" or MEM_WB_OP="0001") and Mem_WB_CZ_Write='1') then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (MEM_WB_OP="0000" or MEM_WB_OP="0010" or MEM_WB_OP="0001") and Mem_WB_CZ_Write='1') then
        	if(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1'; 
			end if;
        end if;

        --LHI and R,SW,BEQ,JLR

        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and RR_EX_OP="0011") then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_Mem_LHI_var:='1';
            elsif(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_Mem_LHI_var:='1';
        	end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and RR_EX_OP="0011") then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_Mem_LHI_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and RR_EX_OP="0011") then
        	if(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_Mem_LHI_var:='1';
            end if;
        end if;
       	if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and EX_Mem_OP="0011") then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_LHI_var:='1';
            elsif(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_LHI_var:='1';
        	end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and EX_Mem_OP="0011") then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_LHI_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and EX_Mem_OP="0011") then
        	if(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_LHI_var:='1';
            end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and Mem_WB_OP="0011") then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';
            elsif(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1';
        	end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and Mem_WB_OP="0011") then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';      --No need to make separate control bit of LHI for _after_WB_ as there is only one register after that
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and Mem_WB_OP="0011") then
        	if(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1';      --No need to make separate control bit of LHI for _after_WB_ as there is only one register after that
            end if;
        end if;


       --JAL,JLR and R,BEQ,SW,JLR

       if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (RR_EX_OP="1000" or RR_EX_OP="1001")) then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_MEM_PC_var:='1';
            elsif(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_MEM_PC_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (RR_EX_OP="1000" or RR_EX_OP="1001")) then
        	if(ID_RR_RA=RR_EX_Radd) then
            	Haz_Cont1_EX_Mem_PC_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (RR_EX_OP="1000" or RR_EX_OP="1001")) then
        	if(ID_RR_RB=RR_EX_Radd) then
            	Haz_Cont2_EX_Mem_PC_var:='1';
			end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (EX_MEM_OP="1000" or EX_MEM_OP="1001")) then
        	if(ID_RR_RA=EX_MEM_Radd) then
            	Haz_Cont1_Mem_WB_PC_var:='1';
            elsif(ID_RR_RB=EX_MEM_Radd) then
            	Haz_Cont2_Mem_WB_PC_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (EX_MEM_OP="1000" or EX_MEM_OP="1001")) then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_PC_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (EX_MEM_OP="1000" or EX_MEM_OP="1001")) then
        	if(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_PC_var:='1';
            end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and (MEM_WB_OP="1000" or MEM_WB_OP="1001")) then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_PC_var:='1';
            elsif(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_PC_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and (MEM_WB_OP="1000" or MEM_WB_OP="1001")) then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_PC_var:='1';
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and (MEM_WB_OP="1000" or MEM_WB_OP="1001")) then
        	if(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_PC_var:='1';
            end if;
        end if;

        --LW and R,SW,BEQ,JLR

        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and EX_Mem_OP="0100") then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_var:='1';             --No need for another control bit as we anyway write in Rdata
            elsif(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_var:='1';
            end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and EX_Mem_OP="0100") then
        	if(ID_RR_RA=EX_Mem_Radd) then
            	Haz_Cont1_Mem_WB_var:='1';
            end if;
       	elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and EX_Mem_OP="0100") then
        	if(ID_RR_RB=EX_Mem_Radd) then
            	Haz_Cont2_Mem_WB_var:='1';
            end if;
        end if;
        if((ID_RR_OP="0000" or ID_RR_OP="0010" or ID_RR_OP="1100" or ID_RR_OP="0101") and Mem_WB_OP="0100") then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';
            elsif(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1';
        	end if;
        elsif((ID_RR_OP="0001" or ID_RR_OP="0110") and Mem_WB_OP="0100") then
        	if(ID_RR_RA=Mem_WB_Radd) then
            	Haz_Cont1_after_WB_var:='1';      --No need to make separate control bit of LHI for _after_WB_ as there is only one register after that
            end if;
        elsif((ID_RR_OP="1001" or ID_RR_OP="0100") and Mem_WB_OP="0100") then
        	if(ID_RR_RB=Mem_WB_Radd) then
            	Haz_Cont2_after_WB_var:='1';      --No need to make separate control bit of LHI for _after_WB_ as there is only one register after that
            end if;
        end if;


    if(Ex_Mem_OP="0100" or Ex_Mem_OP="0110") then
      Mem_A1_data<=Addr_Read_out_Mem;
      Mem_Write_Data<='1';
    elsif(Ex_Mem_OP="0101" or Ex_Mem_OP="0111") then
      Mem_A1_data<=Addr_Write_Out_Mem;
      Mem_Write_Data<='0' or Reset;
    else
      Mem_Write_Data<='1';
    end if;
    Mem_D2_data<=Data_Write_Out_Mem;

--------------------------------

    if(RR_EX_OP="1000" or RR_Ex_OP="1001") then
      Flush:='1';
    elsif(RR_Ex_OP="1100") then
      if(ALU_out_Ex="1111111111111111") then
        Flush:='1';
      else
        Flush:='0';
      end if;
    else
      Flush:='0';
    end if;
	 
------------------------------------
	if((Mem_WB_OP="0000" or Mem_WB_OP="0001" or Mem_WB_OP="0010") and Mem_WB_CZ_write='1' and Mem_WB_Radd="111")  then
		write_in_R7<=Mem_WB_Rdata;
	elsif(Mem_WB_OP="0011" and Mem_WB_radd="111") then
		write_in_R7<=Rdata_out_WB;
	elsif(Mem_WB_OP="0100" and Mem_WB_Radd="111") then
		write_in_R7<=Mem_WB_Rdata;
	elsif(Reset='1') then
		write_in_R7<="0000000000000001";
	elsif(Mem_WB_OP="1111") then
		write_in_R7<=next_PC;
		RF_write_R7<='0';
	else
		write_in_R7<=next_PC;
	end if;
	
------------------------------	

	if(RR_EX_OP="0110" or RR_EX_OP="0111") then
		Mul_Cont_var:='1';          --Not written else for managing two LMs next to each other
		LM_cont_var:='1';
	end if;
	if(Mem_WB_OP="0110") then
		LM_cont_var:=LMcontrol_out_WB;
	end if;
	if(LM_cont_var='0') then
		Mul_Cont_var:='0';
	end if;
----------------------------------
	if(ID_RR_OP="0111" and not(RR_EX_OP="0111")) then
		SM_begin_stall_var:="11";
		SM_later_stall_var:='1';
	end if;
	if(SM_begin_stall="11") then
		SM_begin_stall_var:="10";
	elsif(SM_begin_stall="10") then
		SM_begin_stall_var:="01";
	end if;
	
	if(SM_begin_stall="01") then
		SM_later_stall_var:='1';
		SM_begin_stall_var:="00";
		SM_dumdum_var:='1';
	end if;
	
	if(SM_begin_stall_var="10" or SM_begin_stall_var="01") then
		stall_var:='1';
	end if;
	
	if(ID_RR_OP="0111" and  RR_EX_OP="0111") then
		SM_later_stall_var:='1';
	end if;
---------------------------------
	if(SM_dumdum='1') then
		Pri_Imm9_in<=ID_RR_Imm9;
	else
		Pri_Imm9_in<=RR_EX_Imm9;
	end if;
	
	if(SM_later_stall_var='1') then
		RF_A2<=SM_Radd;
	else
		RF_A2<=ID_RR_RB;
	end if;	
	
	if(ID_RR_OP="0111" and SM_cont='0') then
		RR_EX_OP_var:="1111";
	end if;
---------------------------------
	if((RR_EX_OP="0000" or RR_EX_OP="0001" or RR_EX_OP="0010") and CZ_write_out_EX='1' and Radd_out_EX="111") then
		PC_var:=ALU_out_EX;
		Flush:='1';
	elsif(RR_EX_OP="0011" and RR_EX_Radd="111") then
		PC_var:=LHI_RR_EX;
		Flush:='1';
	elsif(EX_Mem_OP="0100" and EX_Mem_Radd="111") then
		PC_var:=Mem_D1_data;
		Flush:='1';
		Flush1:='1';
	end if;	 
	
	if(Stall_var='1' or SM_later_stall_var='1') then
      PC_var:=PC_old_IF;
    elsif(RR_EX_OP="1000" or RR_EX_OP="1001") then
      PC_var:=PC_Imm_Ex;
    elsif(RR_EX_OP="1100") then
      if(ALU_out_EX="1111111111111111") then
        PC_var:=PC_Imm_Ex;
      else
        PC_var:=PC_new_IF;
      end if;
    else
      PC_var:=PC_new_IF;
    end if;
-----------------------------------

    RF_A1<=ID_RR_RA;
    RegA_in_RR<=RF_D1;
    RegB_in_RR<=RF_D2;
--------------------------------	

    Ex_Haz_Cont1<=Haz_Cont1_Ex_Mem or Haz_Cont1_Mem_WB or Haz_Cont1_after_WB or Haz_Cont1_Ex_Mem_LHI or Haz_Cont1_Mem_WB_LHI or Haz_Cont1_EX_Mem_PC or Haz_Cont1_Mem_WB_PC or Haz_Cont1_after_WB_PC ;
    Ex_Haz_Cont2<=Haz_Cont2_Ex_Mem or Haz_Cont2_Mem_WB or Haz_Cont2_after_WB or Haz_Cont2_Ex_Mem_LHI or Haz_Cont2_Mem_WB_LHI or Haz_Cont2_EX_Mem_PC or Haz_Cont2_Mem_WB_PC or Haz_Cont2_after_WB_PC ;

    if(Haz_Cont1_Ex_Mem='1') then
      EX_Haz_Data1<=Ex_Mem_ALUO;
    elsif(Haz_Cont1_EX_Mem_LHI='1') then
      Ex_Haz_Data1<=Haz_Data_LHI_Ex_Mem;
    elsif(Haz_Cont1_EX_Mem_PC='1') then
      Ex_Haz_Data1<=EX_Mem_PC;
    elsif(Haz_Cont1_Mem_WB='1') then
      Ex_Haz_Data1<=Mem_WB_Rdata;
    elsif(Haz_Cont1_Mem_WB_LHI='1') then
      Ex_Haz_Data1<=Haz_data_LHI_Mem_WB;
    elsif(Haz_Cont1_Mem_WB_PC='1') then
      Ex_Haz_data1<=Mem_WB_PC;
    elsif(Haz_Cont1_after_WB='1') then
      Ex_Haz_data1<=Data_after_WB;
    elsif(Haz_Cont1_after_WB_PC='1') then
      Ex_Haz_data1<=PC_after_WB;
    end if;

    if(Haz_Cont2_Ex_Mem='1') then
      EX_Haz_Data2<=Ex_Mem_ALUO;
    elsif(Haz_Cont2_EX_Mem_LHI='1') then
      Ex_Haz_Data2<=Haz_Data_LHI_Ex_Mem;
    elsif(Haz_Cont2_EX_Mem_PC='1') then
      Ex_Haz_Data2<=EX_Mem_PC;
    elsif(Haz_Cont2_Mem_WB='1') then
      Ex_Haz_Data2<=Mem_WB_Rdata;
    elsif(Haz_Cont2_Mem_WB_LHI='1') then
      Ex_Haz_Data2<=Haz_data_LHI_Mem_WB;
    elsif(Haz_Cont2_Mem_WB_PC='1') then
      Ex_Haz_data2<=Mem_WB_PC;
    elsif(Haz_Cont2_after_WB='1') then
      Ex_Haz_data2<=Data_after_WB;
    elsif(Haz_Cont2_after_WB_PC='1') then
      Ex_Haz_data2<=PC_after_WB;
	end if;
---------------------------------------------
    if(stall_var = '0') then

      if(SM_later_stall_var='0') then
			IF_ID_PC_var := PC_old_IF;
			if(Flush='1') then
				IF_ID_IR_var:="1111111111111111";
			else
				IF_ID_IR_var:=IR_IF;
			end if;

			ID_RR_PC_var := PC_out_ID;
			if(Flush='1') then
				ID_RR_OP_var := "1111";
			else
				ID_RR_OP_var:=OP_ID;
			end if;
				ID_RR_RA_var := RA_ID;
				ID_RR_RB_var := RB_ID;
				ID_RR_RC_var := RC_ID;
				ID_RR_IMM6_var := Imm6_ID;
				ID_RR_IMM9_var := Imm9_ID;
				ID_RR_C_var := C_ID;
				ID_RR_Z_var := Z_ID;
		else
			IF_ID_PC_var:=IF_ID_PC;
			IF_ID_IR_var:=IF_ID_IR;

			ID_RR_PC_var:=ID_RR_PC;
			ID_RR_OP_var:=ID_RR_OP;
			ID_RR_RA_var := ID_RR_RA;
			ID_RR_RB_var := ID_RR_RB;
			ID_RR_RC_var := ID_RR_RC;
			ID_RR_IMM6_var := ID_RR_Imm6;
			ID_RR_IMM9_var := ID_RR_Imm9;
			ID_RR_C_var := ID_RR_C;
			ID_RR_Z_var :=ID_RR_Z;
		end if;
		
		RR_EX_PC_var := PC_out_RR; 
      if(Flush='1') then
        RR_Ex_OP_var := "1111";
      else
        RR_Ex_OP_var:=OP_out_RR;
      end if;
		if(SM_begin_stall_var="11") then
			RR_EX_OP_var:="1111";
		end if;
		if(ID_RR_OP="0111" and SM_cont='0') then
			RR_EX_OP_var:="1111";
		end if;
		RR_EX_Radd_var := Raddress_RR;
		RR_EX_Imm6SE_var := Imm6SE_out_RR;
		if(SM_later_stall_var='1' and not(SM_begin_stall_var="11")) then
			RR_EX_Imm9_var:=Pri_Imm9_out;
		else
			RR_EX_Imm9_var:=Imm9_out_RR;
		end if;
		RR_EX_IMM9SE_var := Imm9SE_out_RR;
		RR_EX_C_var := C_out_RR;
		RR_EX_Z_var := Z_out_RR;
		RR_EX_OPR1_var := Opr1_out_RR;
		RR_EX_OpR2_var := Opr2_out_RR;
		RR_EX_RegA_var := RegA_out_RR;
--------------------------------------------
    else
      IF_ID_PC_var:=IF_ID_PC;
      IF_ID_IR_var:=IF_ID_IR;

      ID_RR_PC_var:=ID_RR_PC;
      ID_RR_OP_var:=ID_RR_OP;
      ID_RR_RA_var := ID_RR_RA;
		ID_RR_RB_var := ID_RR_RB;
		ID_RR_RC_var := ID_RR_RC;
		ID_RR_IMM6_var := ID_RR_Imm6;
		ID_RR_IMM9_var := ID_RR_Imm9;
		ID_RR_C_var := ID_RR_C;
		ID_RR_Z_var :=ID_RR_Z;

      RR_EX_PC_var:=RR_EX_PC;
		if(RR_EX_OP="0100") then
			RR_Ex_OP_var:="1111";
		elsif(RR_EX_OP="0110" and LM_cont_var='0') then
			RR_EX_OP_var:="1111";
		else
			RR_EX_OP_var:=RR_EX_OP;
		end if;
      RR_EX_Radd_var := RR_EX_Radd;
		RR_EX_Imm6SE_var := RR_EX_IMM6SE;
		RR_EX_Imm9_var := RR_EX_IMM9;
		RR_EX_IMM9SE_var := RR_EX_IMM9SE;
		RR_EX_C_var := RR_EX_C;
		RR_EX_Z_var := RR_EX_Z;
		RR_EX_OPR1_var := RR_EX_OPR1;
		RR_EX_OpR2_var := RR_EX_OpR2;
		RR_EX_RegA_var := RR_EX_Rega;
	end if;
----------------------------------------    No need for stall after this
    Carry_var:=Carry_Ex;
    Zero_var:=Zero_Ex;
    Ex_Mem_PC_var:=PC_out_Ex;
	 if(Flush1='1') then
		Ex_Mem_OP_var:="1111";
	 else
		Ex_Mem_OP_var:=OP_out_Ex;
	 end if;
    EX_Mem_RegA_var:=RegA_out_Ex;
    Ex_Mem_ALUO_var:=ALU_out_Ex;
    EX_Mem_Imm9_var:=Imm9_out_Ex;
    Ex_Mem_Radd_var:=Radd_out_Ex;
    EX_MEM_C_var:=C_out_Ex;
    EX_MEM_Z_var:=Z_out_Ex;
    Ex_Mem_Cz_Write_var:=CZ_write_out_Ex;

    MEM_WB_PC_var := PC_out_Mem;
    MEM_WB_OP_var := Op_out_Mem;
    if(Mem_WB_OP="0110") then
      MEM_WB_IMM9_var:=Imm9_out_WB;
    else
      MEM_WB_IMM9_var := Imm9_out_Mem;
    end if;
		MEM_WB_Radd_var := Radd_out_MEm;
    if(Ex_Mem_OP="0100" or Ex_Mem_OP="0110") then
      Mem_WB_Rdata_var:=Mem_D1_data;
    else
      Mem_WB_Rdata_var:=Rdata_out_Mem;
    end if;
		MEM_WB_RegA_var := RegA_out_MEm;
    Mem_WB_CZ_Write_var:=CZ_Write_out_Mem;

    RF_A3<=R_Addr_out_WB;
    RF_write<=WR_out_WB and (not(Reset));
    RF_D3<=Rdata_out_WB;
    PC_after_WB_var:=Mem_WB_PC;
    Data_after_WB_var:=Rdata_out_WB;
	 
	 if(RR_EX_OP="0110" and LM_Cont_var='0') then
		EX_Mem_OP_var:="1111";
		Mem_WB_OP_var:="1111";
	end if;

		if(clk'event and clk='1') then

      IF_ID_IR<=IF_ID_IR_var;

      ID_RR_PC <= ID_RR_PC_var;
			ID_RR_RA <= ID_RR_RA_var;
			ID_RR_RB <= ID_RR_RB_var;
			ID_RR_RC <= ID_RR_RC_var; 
			ID_RR_IMM6 <= ID_RR_IMM6_var;
			ID_RR_IMM9 <= ID_RR_IMM9_var;
			ID_RR_C <= ID_RR_C_var;
			ID_RR_Z <= ID_RR_Z_var;

			RR_EX_PC <= RR_EX_PC_var;
			RR_EX_Radd <= RR_EX_Radd_var;
			RR_EX_Imm6SE <= RR_EX_Imm6SE_var;
			RR_EX_Imm9 <= RR_EX_Imm9_var;
			RR_EX_C <= RR_EX_C_var;
			RR_EX_Z <= RR_EX_Z_var;
			RR_EX_OPR1 <= RR_EX_OPR1_var;
			RR_EX_OpR2 <= RR_EX_OPR2_var;
			RR_EX_RegA <= RR_EX_RegA_var;
			RR_EX_IMM9SE <= RR_EX_IMM9SE_var;
			
			EX_Mem_PC<=EX_Mem_PC_var;
			EX_Mem_Radd<=EX_Mem_Radd_var;
			EX_Mem_RegA<=Ex_Mem_RegA_var;
			EX_Mem_ALUO<=Ex_Mem_ALUO_var;
			EX_Mem_Imm9<=Ex_Mem_Imm9_var;
			EX_Mem_C<=EX_Mem_C_var;
			Ex_Mem_Z<=Ex_Mem_Z_var;
			EX_Mem_CZ_Write<=Ex_Mem_CZ_Write_var;

      Haz_Cont1_Ex_Mem<=Haz_Cont1_EX_Mem_var;
      Haz_Cont1_Mem_WB<=Haz_Cont1_Mem_WB_var;
      Haz_Cont1_after_WB<=Haz_Cont1_after_WB_var;
      Haz_Cont2_Ex_Mem<=Haz_Cont2_EX_Mem_var;
      Haz_Cont2_Mem_WB<=Haz_Cont2_Mem_WB_var;
      Haz_Cont2_after_WB<=Haz_Cont2_after_WB_var;
      Haz_Cont1_Ex_Mem_LHI<=Haz_Cont1_EX_Mem_LHI_var;
      Haz_Cont1_Mem_WB_LHI<=Haz_Cont1_Mem_WB_LHI_var;
      Haz_Cont2_Ex_Mem_LHI<=Haz_Cont2_EX_Mem_LHI_var;
      Haz_Cont2_Mem_WB_LHI<=Haz_Cont2_Mem_WB_LHI_var;
      Haz_Cont1_Ex_Mem_PC<=Haz_Cont1_EX_Mem_PC_var;
      Haz_Cont1_Mem_WB_PC<=Haz_Cont1_Mem_WB_PC_var;
      Haz_Cont1_after_WB_PC<=Haz_Cont1_after_WB_PC_var;
      Haz_Cont2_Ex_Mem_PC<=Haz_Cont2_EX_Mem_PC_var;
      Haz_Cont2_Mem_WB_PC<=Haz_Cont2_Mem_WB_PC_var;
      Haz_Cont2_after_WB_PC<=Haz_Cont2_after_WB_PC_var;

			MEM_WB_PC <= MEM_WB_PC_var;
			MEM_WB_IMM9 <= MEM_WB_IMM9_var;
			MEM_WB_Radd <= MEM_WB_Radd_var;
      Mem_WB_Rdata<=Mem_WB_Rdata_var;
			MEM_WB_RegA <= MEM_WB_RegA_var;
      Mem_WB_CZ_Write<=Mem_WB_CZ_Write_var;

      PC_after_WB<=PC_after_WB_var;
      Data_after_WB<=Data_after_WB_var;
		
		Mul_Cont<=Mul_Cont_var;
		SM_begin_stall<=SM_begin_stall_var;
		SM_dumdum<=SM_dumdum_var;
		
		if(Reset='1') then
			IF_ID_IR<="1111111111111111";
			ID_RR_OP<="1111";
			RR_EX_OP<="1111";
			EX_MEM_OP<="1111";
			MEM_WB_OP<="1111";
			PC<="0000000000000001";
			Carry<='0';
			Zero<='0';
			Mul_Cont<='0';
			SM_begin_stall<="00";
		else
			IF_ID_PC<=IF_ID_PC_var;
			ID_RR_OP<=ID_RR_OP_var;
			RR_EX_OP<=RR_EX_OP_var;
			EX_Mem_OP<=EX_Mem_OP_var;
			Mem_WB_OP<=Mem_WB_OP_var;
			PC<=PC_var;
			Carry<=Carry_var;
			Zero<=Zero_var;
		end if;
		end if;
	end process;
end Behave;