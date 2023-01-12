`timescale 1ps/1ps
module PE_Group_tb
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 4,
		parameter BufferSize = 16,
		parameter K_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = 7,
		parameter K_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 1,
		parameter BlockCountWidth = 1)();
    
	reg clk, aclr;
	reg K_DataInValid;
	reg I_DataInValid;
	reg O_DataInValid, O_DataOutRdy;
	reg [DataWidth - 1 : 0] K_DataIn;
	reg [DataWidth - 1 : 0] O_DataIn;
	reg [DataWidth - 1 : 0] I_DataIn;
	
	wire [DataWidth - 1: 0] O_DataOut;
	wire K_DataInRdy;
	wire I_DataInRdy;
	wire O_DataInRdy, O_DataOutValid;

    PE_Group #( .DataWidth(DataWidth), .BufferWidth(BufferWidth), .BufferSize(BufferSize),
                .K_PEGroupSize(K_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), .I_PEGroupSize(I_PEGroupSize),
				.K_PEAddrWidth(K_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
				.BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
    dut
	(   .clk(clk), .aclr(aclr),
		.K_DataInValid(K_DataInValid), .K_DataInRdy(K_DataInRdy), .K_DataIn(K_DataIn),
		.I_DataInValid(I_DataInValid), .I_DataInRdy(I_DataInRdy), .I_DataIn(I_DataIn),
		.O_DataInValid(O_DataInValid), .O_DataInRdy(O_DataInRdy), .O_DataIn(O_DataIn),
		.O_DataOutValid(O_DataOutValid), .O_DataOutRdy(O_DataOutRdy), .O_DataOut(O_DataOut));

	initial begin
		clk = 1;
		aclr = 1;
		K_DataInValid = 0;
		I_DataInValid = 0;
		O_DataInValid = 0;
		O_DataOutRdy = 0;
		K_DataIn = 0;
		I_DataIn = 0;
		O_DataIn = 0;
		#1
		aclr = 0;
		O_DataOutRdy = 1;
	end



	//examine O_DataOutValid in each cycle, if DataOutValid is 1, write O_DataOut into Ans_Buffer
	always #2 begin
		if(O_DataOutValid) begin
			$display("%h", O_DataOut);
		end
	end

	//Weight Data
	initial begin
		#1
		//Tile 0

		//Block 0

		K_DataInValid = 1;
        K_DataIn = 32'h40a00000; //5

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41200000; //10

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41700000; //15

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41a00000; //20
		
		#2
		K_DataInValid = 0;
		//End of Block 0
		
		//Block 1
		#2
		K_DataInValid = 1;
        K_DataIn = 32'h40a00000; //5

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41200000; //10

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41700000; //15
		
		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41a00000; //20
		
		#2
		K_DataInValid = 0;
		
		//End of Block 1

		//End of Tile 0
		
		#2
		
		//Tile 1
		//Block 0

		K_DataInValid = 1;
        K_DataIn = 32'h40a00000; //5

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41200000; //10

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41700000; //15

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41a00000; //20
		
		#2
		K_DataInValid = 0;
		//End of Block 0
		
		//Block 1
		#2
		K_DataInValid = 1;
        K_DataIn = 32'h40a00000; //5

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41200000; //10

		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41700000; //15
		
		#2
		K_DataInValid = 1;
        K_DataIn = 32'h41a00000; //20
		
		#2
		K_DataInValid = 0;
		
		//End of Block 1
		//End of Tile 1
	end

	//Input Data
	initial begin
		#1
		//Tile 0

		//Block 0
		#2
		I_DataInValid = 1;
        I_DataIn = 32'h3f800000; //1

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40000000; //2

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40400000; //3

		#2
		I_DataInValid = 1;
		I_DataIn = 32'h40800000; // 4

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40a00000; // 5

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40c00000; // 6	

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40e00000; // 7

		//End of Block 0
		
		
		//Block 1
		#2
		I_DataInValid = 1;
        I_DataIn = 32'h3f800000; //1

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40000000; //2

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40400000; //3

		#2
		I_DataInValid = 1;
		I_DataIn = 32'h40800000; // 4

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40a00000; // 5

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40c00000; // 6	

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40e00000; // 7
		
		#2
		I_DataInValid = 0;
		
		//End of Block 1

		//End of Tile 0
		
		//Tile 1
		//Block 0
		#2
		I_DataInValid = 1;
        I_DataIn = 32'h3f800000; //1

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40000000; //2

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40400000; //3

		#2
		I_DataInValid = 1;
		I_DataIn = 32'h40800000; // 4

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40a00000; // 5

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40c00000; // 6	

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40e00000; // 7
		//End of Block 0
		
		//Block 1
		#2
		I_DataInValid = 1;
        I_DataIn = 32'h3f800000; //1

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40000000; //2

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40400000; //3

		#2
		I_DataInValid = 1;
		I_DataIn = 32'h40800000; // 4

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40a00000; // 5

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40c00000; // 6	

		#2
		I_DataInValid = 1;
        I_DataIn = 32'h40e00000; // 7
		
		#2
		I_DataInValid = 0;
		
		//End of Block 1
		//End of Tile 1
	end

	//Output Data
    initial begin
		#1
		//Tile0
		
		//Block 0
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h42200000; //40

		#2
		O_DataInValid = 0;

		//End of Block 0
		
		//End of Tile 0	
		
		#20

		//Block 1
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h42200000; //40

		#2
		O_DataInValid = 0;

		//End of Block 1

		//Tile1
		
		//Block 0
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h42200000; //40

		#2
		O_DataInValid = 0;
		
		//End of Block 0

		//End of Tile 1

		//Block 1
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41200000; //10
		
		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41a00000; //20

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h41f00000; //30

		#2
		O_DataInValid = 1;
        O_DataIn = 32'h42200000; //40

		#2
		O_DataInValid = 0;

		//End of Block 1

    end

    always #1 clk = ~clk;
		
	
endmodule