module PE_Group_System_Addr_Ctrl
    #(  parameter AddressCount = 27,
        parameter AddressCountWidth = 5,
        parameter TotalReadTimes = 135,
        parameter TotalReadTimesWidth = 9,
        parameter TotalWriteTimes = 135,
        parameter TotalWriteTimesWidth = 9,
        parameter EntryReadTimes = 5,
        parameter EntryReadTimesWidth = 3)
    (clk, rst, DataInValid, DataOutRdy, DataInRdy, DataOutValid, 
    , WAddr, RAddr, WEn, REn, WAddr_Counter, RAddr_Counter);
    input clk, rst;

    input DataInValid, DataOutRdy;
    output DataInRdy, DataOutValid;
    
    input [AddressCountWidth - 1 : 0] WAddr;
    input [AddressCountWidth - 1 : 0] RAddr;
    
    output WEn;
    output REn;

    output reg [TotalWriteTimesWidth - 1 : 0] WAddr_Counter;
    output reg [TotalReadTimesWidth - 1 : 0] RAddr_Counter;
    
    reg [AddressCount - 1 : 0] Valid;
    reg [TotalReadTimesWidth - 1 : 0] ReadCount [0 : AddressCount - 1];
    
    assign DataInRdy = ~Valid[WAddr];
    assign DataOutValid = Valid[RAddr];
    
    assign WEn = DataInValid & DataInRdy;
    assign REn = DataOutValid & DataOutRdy;
    
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for(i = 0; i < AddressCount; i = i + 1) begin
                Valid[i] <= 0;
            end
        end
        else begin
            if (REn && ReadCount[RAddr] == EntryReadTimes - 1) begin
                Valid[RAddr] <= 0;
            end
            if (WEn) begin
                Valid[WAddr] <= 1;
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < AddressCount; i = i + 1) begin
                ReadCount[i] <= 0;
            end                
        end
        else if(REn && ReadCount[RAddr] == EntryReadTimes - 1) begin
            ReadCount[RAddr] <= 0;
        end
        else if(REn && Valid[RAddr]) begin
            ReadCount[RAddr] <= ReadCount[RAddr] + 1;
        end
    end

    always @(posedge clk) begin

        if(rst) begin
            WAddr_Counter <= 0;
        end
        else if(WEn) begin
            WAddr_Counter <= WAddr_Counter + 1;
        end
        else begin
            WAddr_Counter <= WAddr_Counter;
        end

        if(rst) begin
            RAddr_Counter <= 0;
        end
        else if(REn) begin
            RAddr_Counter <= RAddr_Counter + 1;
        end
        else begin
            RAddr_Counter <= RAddr_Counter;
        end
    end

    
endmodule
