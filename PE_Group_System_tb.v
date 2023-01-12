module PE_Group_System_tb
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
		parameter AddressWidth = 32)();
    
    wire [DataWidth - 1 : 0] O_DataOut;
    
    reg clk, aclr;
    reg [DataWidth - 1 : 0] W_DataIn, I_DataIn, O_DataIn;
    reg OFF_W_WEn, OFF_I_WEn, OFF_O_WEn;
    reg [AddressWidth - 1 : 0] OFF_W_RAddr, OFF_I_RAddr, OFF_O_RAddr;
    reg [AddressWidth - 1 : 0] OFF_W_WAddr, OFF_I_WAddr, OFF_O_WAddr;
    reg ON_W_WEn, ON_I_WEn, ON_O_WEn;
    reg [AddressWidth - 1 : 0] ON_W_RAddr, ON_I_RAddr, ON_O_RAddr;
    reg [AddressWidth - 1 : 0] ON_W_WAddr, ON_I_WAddr, ON_O_WAddr;

	PE_Group_System dut( .clk(clk), .aclr(aclr), 
		.W_DataIn(W_DataIn), .I_DataIn(I_DataIn), .O_DataIn(O_DataIn), .O_DataOut(O_DataOut),
		.OFF_W_WEn(OFF_W_WEn), .OFF_I_WEn(OFF_I_WEn), .OFF_O_WEn(OFF_O_WEn),
		.OFF_W_RAddr(OFF_W_RAddr), .OFF_I_RAddr(OFF_I_RAddr), .OFF_O_RAddr(OFF_O_RAddr),
		.OFF_W_WAddr(OFF_W_WAddr), .OFF_I_WAddr(OFF_I_WAddr), .OFF_O_WAddr(OFF_O_WAddr),
		.ON_W_WEn(ON_W_WEn), .ON_I_WEn(ON_I_WEn), .ON_O_WEn(ON_O_WEn),
		.ON_W_RAddr(ON_W_RAddr), .ON_I_RAddr(ON_I_RAddr), .ON_O_RAddr(ON_O_RAddr),
		.ON_W_WAddr(ON_W_WAddr), .ON_I_WAddr(ON_I_WAddr), .ON_O_WAddr(ON_O_WAddr));
    
    parameter Max_DataCount = 65596;

    reg [AddressWidth - 1 : 0] OFF_W_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] OFF_I_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] OFF_O_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] OFF_W_WAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] OFF_I_WAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] OFF_O_WAddr_Buffer [0 : Max_DataCount - 1];

    reg [AddressWidth - 1 : 0] ON_W_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] ON_I_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] ON_O_RAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] ON_W_WAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] ON_I_WAddr_Buffer [0 : Max_DataCount - 1];
    reg [AddressWidth - 1 : 0] ON_O_WAddr_Buffer [0 : Max_DataCount - 1];

    integer OFF_W_RAddr_fptr;
    integer OFF_I_RAddr_fptr;
    integer OFF_O_RAddr_fptr;
    integer OFF_W_WAddr_fptr;
    integer OFF_I_WAddr_fptr;
    integer OFF_O_WAddr_fptr;
    integer ON_W_RAddr_fptr;
    integer ON_I_RAddr_fptr;
    integer ON_O_RAddr_fptr;
    integer ON_W_WAddr_fptr;
    integer ON_I_WAddr_fptr;
    integer ON_O_WAddr_fptr;
    
    initial begin
        
    end
    initial begin
        clk = 1;
        aclr = 1;
        #1
        aclr = 0;    
    end
    
endmodule

