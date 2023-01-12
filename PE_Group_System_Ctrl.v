module PE_Group_System_Ctrl
    #(  parameter W_Off_Size = 27,
        parameter I_Off_Size = 147,
        parameter O_Off_Size = 25,
        parameter W_On_Size = 3,
        parameter I_On_Size = 7,
        parameter O_On_Size = 5,
        parameter Off_AddressWidth = 9,
        parameter On_AddressWidth = 3,
        parameter AddressCountWidth = 10
        )
    ();
    input clk, rst;
    input W_DataInValid, I_DataInValid, O_DataInValid;
    input [Off_AddressWidth - 1 : 0] W_Off_WAddr, I_Off_WAddr, O_Off_File_WAddr, O_Off_On_WAddr;
    input [On_AddressWidth - 1 : 0] W_On_WAddr, I_On_WAddr, O_On_Off_WAddr, O_On_PE_WAddr;
    
    output W_Off_WEn, I_Off_WEn, O_Off_WEn;
    output W_Off_REn, I_Off_REn, O_Off_REn;

    output W_On_WEn, I_On_WEn, O_On_WEn;
    output W_On_REn, I_On_REn, O_On_REn;

    output O_DataOutRdy;
    
    output reg [AddressCountWidth - 1 : 0] W_Off_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] W_Off_RAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] W_On_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] W_On_RAddr_Counter;
    
    output reg [AddressCountWidth - 1 : 0] I_Off_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] I_Off_RAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] I_On_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] I_On_RAddr_Counter;

    output reg [AddressCountWidth - 1 : 0] O_Off_File_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_Off_On_RAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_On_Off_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_On_PE_RAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_On_PE_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_On_Off_RAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_Off_On_WAddr_Counter;
    output reg [AddressCountWidth - 1 : 0] O_Off_File_RAddr_Counter;

    wire O_Off_File_WEn, O_Off_On_REn, O_On_Off_WEn, O_On_PE_REn, O_On_PE_WEn, O_On_Off_REn, O_Off_On_WEn, O_Off_File_REn;

    assign O_Off_WEn = O_Off_File_WEn | O_Off_On_WEn;
    assign O_Off_REn = O_Off_On_REn | O_Off_File_REn;
    assign O_On_WEn = O_On_Off_WEn | O_On_PE_WEn;
    assign O_On_REn = O_On_PE_REn | O_On_Off_REn;
    
    reg [W_Off_Size - 1 : 0] W_Off_Valid;
    reg [I_Off_Size - 1 : 0] I_Off_Valid;
    reg [O_Off_Size - 1 : 0] O_Off_Valid;
    
    reg [W_On_Size - 1 : 0] W_On_Valid;
    reg [I_On_Size - 1 : 0] I_On_Valid;
    reg [O_On_Size - 1 : 0] O_On_Valid;
    always @(posedge clk) begin

        //Weight Memory Address Pointer
        if(rst) begin
            W_Off_WAddr_Counter <= 0;
        end
        else if(W_Off_WEn) begin
            W_Off_WAddr_Counter <= W_Off_WAddr_Counter + 1;
        end
        else begin
            W_Off_WAddr_Counter <= W_Off_WAddr_Counter;
        end

        if(rst) begin
            W_Off_RAddr_Counter <= 0;
        end
        else if(W_Off_REn) begin
            W_Off_RAddr_Counter <= W_Off_RAddr_Counter + 1;
        end
        else begin
            W_Off_RAddr_Counter <= W_Off_RAddr_Counter;
        end

        if(rst) begin
            W_On_WAddr_Counter <= 0;
        end
        else if(W_On_WEn) begin
            W_On_WAddr_Counter <= W_On_WAddr_Counter + 1;
        end
        else begin
            W_On_WAddr_Counter <= W_On_WAddr_Counter;
        end

        if(rst) begin
            W_On_RAddr_Counter <= 0;
        end
        else if(W_On_REn) begin
            W_On_RAddr_Counter <= W_On_RAddr_Counter + 1;
        end
        else begin
            W_On_RAddr_Counter <= W_On_RAddr_Counter;
        end

        //Input Memory Address Counter

        if(rst) begin
            I_Off_WAddr_Counter <= 0;
        end
        else if(I_Off_WEn) begin
            I_Off_WAddr_Counter <= I_Off_WAddr_Counter + 1;
        end
        else begin
            I_Off_WAddr_Counter <= I_Off_WAddr_Counter;
        end

        if(rst) begin
            I_Off_RAddr_Counter <= 0;
        end
        else if(I_Off_REn) begin
            I_Off_RAddr_Counter <= I_Off_RAddr_Counter + 1;
        end
        else begin
            I_Off_RAddr_Counter <= I_Off_RAddr_Counter;
        end

        if(rst) begin
            I_On_WAddr_Counter <= 0;
        end
        else if(I_On_WEn) begin
            I_On_WAddr_Counter <= I_On_WAddr_Counter + 1;
        end
        else begin
            I_On_WAddr_Counter <= I_On_WAddr_Counter;
        end

        if(rst) begin
            I_On_RAddr_Counter <= 0;
        end
        else if(I_On_REn) begin
            I_On_RAddr_Counter <= I_On_RAddr_Counter + 1;
        end
        else begin
            I_On_RAddr_Counter <= I_On_RAddr_Counter;
        end

        //Output Memory Address Counter

        if(rst) begin
            O_Off_File_WAddr_Counter <= 0;
        end
        else if(O_Off_File_WEn) begin
            O_Off_File_WAddr_Counter <= O_Off_File_WAddr_Counter + 1;
        end
        else begin
            O_Off_File_WAddr_Counter <= O_Off_File_WAddr_Counter;
        end
    
        if(rst) begin
            O_Off_On_RAddr_Counter <= 0;
        end
        else if(O_Off_On_REn) begin
            O_Off_On_RAddr_Counter <= O_Off_On_RAddr_Counter + 1;
        end
        else begin
            O_Off_On_RAddr_Counter <= O_Off_On_RAddr_Counter;
        end

        if(rst) begin
            O_On_Off_WAddr_Counter <= 0;
        end
        else if(O_On_Off_WEn) begin
            O_On_Off_WAddr_Counter <= O_On_Off_WAddr_Counter + 1;
        end
        else begin
            O_On_Off_WAddr_Counter <= O_On_Off_WAddr_Counter;
        end

        if(rst) begin
            O_On_PE_RAddr_Counter <= 0;
        end
        else if(O_On_PE_REn) begin
            O_On_PE_RAddr_Counter <= O_On_PE_RAddr_Counter + 1;
        end
        else begin
            O_On_PE_RAddr_Counter <= O_On_PE_RAddr_Counter;
        end

        if(rst) begin
            O_On_PE_WAddr_Counter <= 0;
        end
        else if(O_On_PE_WEn) begin
            O_On_PE_WAddr_Counter <= O_On_PE_WAddr_Counter + 1;
        end
        else begin
            O_On_PE_WAddr_Counter <= O_On_PE_WAddr_Counter;
        end

        if(rst) begin
            O_On_Off_RAddr_Counter <= 0;
        end
        else if(O_On_Off_REn) begin
            O_On_Off_RAddr_Counter <= O_On_Off_RAddr_Counter + 1;
        end
        else begin
            O_On_Off_RAddr_Counter <= O_On_Off_RAddr_Counter;
        end

        if(rst) begin
            O_Off_On_WAddr_Counter <= 0;
        end
        else if(O_Off_On_WEn) begin
            O_Off_On_WAddr_Counter <= O_Off_On_WAddr_Counter + 1;
        end
        else begin
            O_Off_On_WAddr_Counter <= O_Off_On_WAddr_Counter;
        end

        if(rst) begin
            O_Off_File_RAddr_Counter <= 0;
        end
        else if(O_Off_File_REn) begin
            O_Off_File_RAddr_Counter <= O_Off_File_RAddr_Counter + 1;
        end
        else begin
            O_Off_File_RAddr_Counter <= O_Off_File_RAddr_Counter;
        end

    end
    
    always @(*) begin
        if (W_DataInValid) begin
            W_Off_WEn = 1;
        end
    end
    always @(posedge clk) begin
        if (W_DataInValid) begin
            W_Off_Valid[W_Off_WAddr] <= 1;
        end
    end
    

    
endmodule
