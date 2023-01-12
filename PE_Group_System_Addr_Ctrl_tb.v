`timescale 1ps/1ps
module PE_Group_System_Addr_Ctrl_tb
    #(  parameter AddressCount = 8,
        parameter AddressCountWidth = 3,
        parameter TotalReadTimes = 16,
        parameter TotalReadTimesWidth = 4,
        parameter TotalWriteTimes = 8,
        parameter TotalWriteTimesWidth = 3,
        parameter EntryReadTimes = 2,
        parameter EntryReadTimesWidth = 2)();

    reg clk, rst;

    reg DataInValid, DataOutRdy;
    wire DataInRdy, DataOutValid;
    
    reg [AddressCountWidth - 1 : 0] WAddr;
    reg [AddressCountWidth - 1 : 0] RAddr;
    
    wire WEn;
    wire REn;

    wire [TotalWriteTimesWidth - 1 : 0] WAddr_Counter;
    wire [TotalReadTimesWidth - 1 : 0] RAddr_Counter;

    PE_Group_System_Addr_Ctrl #(.AddressCount(AddressCount), .AddressCountWidth(AddressCountWidth),
    .TotalReadTimes(TotalReadTimes), .TotalReadTimesWidth(TotalReadTimesWidth), 
    .TotalWriteTimes(TotalWriteTimes), .TotalWriteTimesWidth(TotalWriteTimesWidth),
    .EntryReadTimes(EntryReadTimes), .EntryReadTimesWidth(EntryReadTimesWidth))
    dut
    (.clk(clk), .rst(rst), .DataInValid(DataInValid), .DataOutRdy(DataOutRdy), .DataInRdy(DataInRdy), .DataOutValid(DataOutValid)
    ,.WAddr(WAddr), .RAddr(RAddr), .WEn(WEn), .REn(REn), .WAddr_Counter(WAddr_Counter), .RAddr_Counter(RAddr_Counter));

    integer WAddr_Fptr, RAddr_Fptr, i, cnt;

    reg [AddressCountWidth - 1 : 0] WAddr_Buffer [0 : TotalWriteTimes - 1];
    reg [AddressCountWidth - 1 : 0] RAddr_Buffer [0 : TotalReadTimes - 1]; 
    
    initial begin
        WAddr_Fptr = $fopen("Data/W_Off_WAddress.txt", "r");
        RAddr_Fptr = $fopen("Data/W_Off_RAddress.txt", "r");

		for(i = 0; i < TotalWriteTimes; i = i + 1) begin
			cnt = $fscanf(WAddr_Fptr, "%d", WAddr_Buffer[i]);
			$display("Write Address: %d\n", WAddr_Buffer[i]);
		end

        for(i = 0; i < TotalReadTimes; i = i + 1) begin
            cnt = $fscanf(RAddr_Fptr, "%d", RAddr_Buffer[i]);
            $display("Read Address: %d\n", RAddr_Buffer[i]);
        end
        
        $fclose(WAddr_Fptr);
        $fclose(RAddr_Fptr);
    end

    always #2 begin
        WAddr = WAddr_Buffer[WAddr_Counter];
        RAddr = RAddr_Buffer[RAddr_Counter];
    end

    initial begin
        clk = 1;
        rst = 1;
        
        DataInValid = 0;
        DataOutRdy = 0;
        WAddr = 0;
        RAddr = 0;

        #1
        rst = 0;

        DataInValid = 1;
        DataOutRdy = 1;
    end

    always #1 clk = ~clk;

endmodule
