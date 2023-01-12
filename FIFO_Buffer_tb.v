`timescale 1ps/1ps
module FIFO_Buffer_tb
    #(  parameter DataWidth = 32)();
        
        parameter BufferSize = 16;

        reg clk, aclr;
        reg Pop1, Pop2, Push;
        reg [DataWidth-1:0] DataIn;

        wire Empty, Full;
        wire [BufferSize-1:0] ReadyM;
        wire [DataWidth-1:0] DataOut1, DataOut2;


    FIFO_Buffer #(.DataWidth(DataWidth)) 
        dut (.clk(clk), .aclr(aclr), .Pop1(Pop1), .Pop2(Pop2), .Push(Push), .DataIn(DataIn),
        .Empty(Empty), .Full(Full), .ReadyM(ReadyM), .DataOut1(DataOut1), .DataOut2(DataOut2));

    initial begin
        clk = 1;
        aclr = 1;
        DataIn = 0;
        Push = 0;
        Pop1 = 0;
        Pop2 = 0;
        #1
        aclr = 0;
        
        Push = 1;
        Pop1 = 0;
        Pop2 = 0;
        
        #16
        Push = 1;
        Pop1 = 1;
        Pop2 = 0;
        #2
        Push = 1;
        Pop1 = 1;
        Pop2 = 0;
        #2
        Push = 1;
        Pop1 = 1;
        Pop2 = 1;
        #2
        Push = 1;
        Pop1 = 0;
        Pop2 = 1;
        #16
        Push = 0;
        Pop1 = 1;
        Pop2 = 0;
        #8
        Push = 0;
        Pop1 = 0;
        Pop2 = 0;   
    end

    always #1 clk = ~clk;
	always #2 DataIn = DataIn + 1;
        
endmodule
