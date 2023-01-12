module PE_Group_System
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 4,
		parameter BufferSize = 16,
		parameter W_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = W_PEGroupSize + O_PEGroupSize - 1,
		parameter W_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 2,
		parameter ACC_Pipeline_Stages = 7,
		parameter AddressWidth = 32) 
	(   clk, aclr, 
		W_DataIn, I_DataIn, O_DataOut,
		W_Off_WEn, W_On_WEn,
		I_Off_WEn, I_On_WEn,
		O_Off_WEn, O_On_WEn,
		W_Off_WAddr, W_Off_RAddr, W_On_WAddr, W_On_RAddr,
		I_Off_WAddr, I_Off_RAddr, I_On_WAddr, I_On_RAddr,
		O_Off_RAddr, O_Off_WAddr, O_On_RAddr, O_On_WAddr,
		O_Off_DataOutValid,
		O_On_Fill);

    input clk, aclr;

    input [DataWidth - 1 : 0] W_DataIn, I_DataIn, O_DataIn;

	output [DataWidth - 1 : 0] O_DataOut;

	input W_Off_WEn, W_On_WEn;
	input I_Off_WEn, I_On_WEn;
	input O_Off_WEn, O_On_WEn;

	input [AddressWidth - 1 : 0] W_Off_WAddr, W_Off_RAddr, W_On_WAddr, W_On_RAddr;
	input [AddressWidth - 1 : 0] I_Off_WAddr, I_Off_RAddr, I_On_WAddr, I_On_RAddr;
	input [AddressWidth - 1 : 0] O_Off_RAddr, O_Off_WAddr, O_On_RAddr, O_On_WAddr;

	input OFF_O_DataOutValid;

	input O_On_Fill;

	wire [DataWidth - 1 : 0] OFF_W_DataIn, OFF_I_DataIn, OFF_O_DataIn;
	wire [DataWidth - 1 : 0] OFF_W_DataOut, OFF_I_DataOut, OFF_O_DataOut;

	assign OFF_W_DataIn = W_DataIn;
	assign OFF_I_DataIn = I_DataIn;

	assign OFF_O_DataIn = ON_O_DataOut;
	assign O_DataOut = OFF_O_DataOut;
	
    wire [DataWidth - 1 : 0] ON_W_DataIn, ON_I_DataIn, ON_O_DataIn;
	wire [DataWidth - 1 : 0] ON_W_DataOut, ON_I_DataOut, ON_O_DataOut;

	wire [DataWidth - 1 : 0] PE_Group_W_DataIn, PE_Group_I_DataIn, PE_Group_O_DataIn;
	wire [DataWidth - 1 : 0] PE_Group_O_DataOut;

	wire [DataWidth - 1 : 0] Zero;
	assign Zero = 0;
	
	assign PE_Group_W_DataIn = ON_W_DataOut;
	assign PE_Group_I_DataIn = ON_I_DataOut;
	assign PE_Group_O_DataIn = O_On_Fill ? ON_O_DataOut ; Zero;

	assign ON_W_DataIn = OFF_W_DataOut;
	assign ON_I_DataIn = OFF_I_DataOut;
	
	wire W_DataInRdy, I_DataInRdy;
	wire O_DataOutValid;

	assign ON_O_DataIn = PE_Group_O_DataOut;
	assign O_DataOutRdy = 1'b1;
	
	wire W_DataInValid, I_DataInValid, O_DataInValid;

    PE_Group #(.DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize), .W_PEGroupSize(W_PEGroupSize), .O_PEGroupSize(O_PEGroupSize),
    .I_PEGroupSize(I_PEGroupSize), .W_PEAddrWidth(W_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth), .BlockCount(BlockCount),
    .BlockCountWidth(BlockCountWidth))
	dut(.clk(clk), .aclr(aclr),
		.W_DataInValid(W_DataInValid), .W_DataInRdy(W_DataInRdy), .W_DataIn(PE_Group_W_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(PE_Group_I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(PE_Group_O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(PE_Group_O_DataOut))
    
    RAM Weight_Off_Chip_Memory
        (.clock(clk), .data(OFF_W_DataIn), .rdaddress(W_Off_RAddr), .wraddress(W_Off_WAddr), .wren(W_Off_WEn), .q(OFF_W_DataOut));

    RAM Weight_On_Chip_Memory
        (.clock(clk), .data(ON_W_DataIn), .rdaddress(W_On_RAddr), .wraddress(W_On_WAddr), .wren(W_On_WEn), .q(ON_W_DataOut));

    RAM Input_Off_Chip_Memory
        (.clock(clk), .data(OFF_I_DataIn), .rdaddress(I_Off_RAddr), .wraddress(I_Off_WAddr), .wren(I_Off_WEn), .q(OFF_I_DataOut));

    RAM Input_On_Chip_Memory
        (.clock(clk), .data(ON_I_DataIn), .rdaddress(I_On_RAddr), .wraddress(I_On_WAddr), .wren(I_On_WEn), .q(ON_I_DataOut));

    RAM Output_Off_Chip_Memory
        (.clock(clk), .data(OFF_O_DataIn), .rdaddress(O_Off_RAddr), .wraddress(O_Off_WAddr), .wren(O_Off_WEn), .q(OFF_O_DataOut));

    RAM Output_On_Chip_Memory
        (.clock(clk), .data(ON_O_DataIn), .rdaddress(O_On_RAddr), .wraddress(O_On_WAddr), .wren(O_On_WEn), .q(ON_O_DataOut));

endmodule
