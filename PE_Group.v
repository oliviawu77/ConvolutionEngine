module PE_Group 
	#(	parameter DataWidth = 32,
		parameter BufferWidth = 4,
		parameter BufferSize = 16,
		parameter K_PEGroupSize = 4,
		parameter O_PEGroupSize = 4,
		parameter I_PEGroupSize = K_PEGroupSize + O_PEGroupSize - 1,
		parameter K_PEAddrWidth = 2,
		parameter O_PEAddrWidth = 2,
		parameter I_PEAddrWidth = 3,
		parameter BlockCount = 4,
		parameter BlockCountWidth = 2,
		parameter ACC_Pipeline_Stages = 7) 
	(	clk, aclr,
		K_DataInValid, K_DataInRdy, K_DataIn,
		I_DataInValid, I_DataInRdy, I_DataIn,
		O_DataInValid, O_DataInRdy, O_DataIn,
		O_DataOutValid, O_DataOutRdy, O_DataOut);

	input clk, aclr;
	input K_DataInValid;
	input I_DataInValid;
	input O_DataInValid, O_DataOutRdy;
	input [DataWidth - 1 : 0] K_DataIn;
	input [DataWidth - 1 : 0] O_DataIn;
	input [DataWidth - 1 : 0] I_DataIn;
	
	wire [DataWidth - 1 : 0] K_Data [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_Data [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_Data [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	
	wire K_InValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire I_InValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire O_InValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];

	wire K_InRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire I_InRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire O_InRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];

	wire K_OutValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire I_OutValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire O_OutValid [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];

	wire K_OutRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire I_OutRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire O_OutRdy [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];

	wire [DataWidth - 1 : 0] K_In [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_In [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_In [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];

	wire [DataWidth - 1 : 0] K_Out [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] I_Out [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	wire [DataWidth - 1 : 0] O_Out [0 : O_PEGroupSize - 1][0 : K_PEGroupSize - 1];
	
	output [DataWidth - 1: 0] O_DataOut;
	output K_DataInRdy;
	output reg I_DataInRdy;
	output O_DataInRdy, O_DataOutValid;

	wire K_Rec_Handshaking;
	wire I_Rec_Handshaking;
	wire O_Rec_Handshaking;
	wire O_Send_Handshaking;

	wire [K_PEAddrWidth - 1 : 0] K_PEAddr;
	wire [I_PEAddrWidth - 1 : 0] I_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_In_PEAddr;
	wire [O_PEAddrWidth - 1 : 0] O_Out_PEAddr;

	wire O_IN_BLOCK_EQUAL_TO_ZERO;
	wire O_IN_BLOCK_EQUAL_TO_BLOCK_COUNT;
	wire O_IN_BLOCK_MORE_THAN_BLOCK_COUNT;

	wire O_OUT_BLOCK_EQUAL_TO_ZERO;
	wire O_OUT_BLOCK_EQUAL_TO_BLOCK_COUNT;

	wire [DataWidth - 1 : 0] O_ACCDataOut [0 : O_PEGroupSize - 1];
	wire O_ACCDataOutValid [0 : O_PEGroupSize - 1];
	wire O_ACCDataOutRdy [0 : O_PEGroupSize - 1];

	wire O_Edge_PE_InRdy;
	reg I_Edge_PE_InValid;
	reg O_Edge_PE_InValid;

	genvar i, j;

	assign K_DataInRdy = K_InRdy[0][K_PEAddr];
	assign O_Edge_PE_InRdy = O_InRdy[O_In_PEAddr][0];
	assign O_DataInRdy = O_IN_BLOCK_EQUAL_TO_ZERO ? O_Edge_PE_InRdy : 0;

	assign K_Rec_Handshaking = K_DataInValid & K_DataInRdy;
	assign I_Rec_Handshaking = I_Edge_PE_InValid & I_DataInRdy;
	assign O_Rec_Handshaking = O_Edge_PE_InValid & O_Edge_PE_InRdy;
	assign O_Send_Handshaking = O_DataOutValid & O_DataOutRdy;

	assign O_DataOut = O_ACCDataOut[O_Out_PEAddr];
	assign O_DataOutValid = O_ACCDataOutValid[O_Out_PEAddr];

	always @(*) begin
		case(I_PEAddr)
			0: I_Edge_PE_InValid = I_InValid[0][0];
			1: I_Edge_PE_InValid = I_InValid[1][0];
			2: I_Edge_PE_InValid = I_InValid[2][0];
			3: I_Edge_PE_InValid = I_InValid[3][0];
			4: I_Edge_PE_InValid = I_InValid[3][1];
			5: I_Edge_PE_InValid = I_InValid[3][2];
			6: I_Edge_PE_InValid = I_InValid[3][3];
			default: I_Edge_PE_InValid = 0;
		endcase
	end
	
	always @(*) begin
		case(O_In_PEAddr)
			0: O_Edge_PE_InValid = O_InValid[0][0];
			1: O_Edge_PE_InValid = O_InValid[1][0];
			2: O_Edge_PE_InValid = O_InValid[2][0];
			3: O_Edge_PE_InValid = O_InValid[3][0];
			default: O_Edge_PE_InValid = 0;
		endcase
	end
	always @(*) begin
		case(I_PEAddr)
			0: I_DataInRdy = I_InRdy[0][0];
			1: I_DataInRdy = I_InRdy[1][0];
			2: I_DataInRdy = I_InRdy[2][0];
			3: I_DataInRdy = I_InRdy[3][0];
			4: I_DataInRdy = I_InRdy[3][1];
			5: I_DataInRdy = I_InRdy[3][2];
			6: I_DataInRdy = I_InRdy[3][3];
			default: I_DataInRdy = 0;
		endcase
	end

	PE_Controller #(.K_PEGroupSize(K_PEGroupSize), .O_PEGroupSize(O_PEGroupSize), 
					.K_PEAddrWidth(K_PEAddrWidth), .O_PEAddrWidth(O_PEAddrWidth), .I_PEAddrWidth(I_PEAddrWidth),
					.BlockCount(BlockCount), .BlockCountWidth(BlockCountWidth))
	ctrl (			.clk(clk), .aclr(aclr), 
					.EN_K(K_Rec_Handshaking), .EN_I(I_Rec_Handshaking), .EN_O_In(O_Rec_Handshaking), .EN_O_Out(O_Send_Handshaking),
					.K_PEAddr(K_PEAddr), .I_PEAddr(I_PEAddr), .O_In_PEAddr(O_In_PEAddr), .O_Out_PEAddr(O_Out_PEAddr),
					.O_IN_BLOCK_EQUAL_TO_ZERO(O_IN_BLOCK_EQUAL_TO_ZERO), .O_IN_BLOCK_MORE_THAN_BLOCK_COUNT(O_IN_BLOCK_MORE_THAN_BLOCK_COUNT));

	//edges
	
	generate
		//Kernel
		//Broadcast Kernel to each edge PE
		for(i = 0; i < K_PEGroupSize; i = i + 1) begin: AssignIOutRdyFirstRow
			assign K__In[0][i] = K_DataIn;
		end

		for(i = 0; i < K_PEGroupSize; i = i + 1) begin: AssignWInValid
			assign K_InValid[0][i] = K_DataInValid && (K_PEAddr == i);
		end

		//just discard the value
		for(i = 0; i < K_PEGroupSize; i = i + 1) begin: AssignWOutRdy
			assign K_OutRdy[O_PEGroupSize - 1][i] = 1'b1;
		end

		//Image
		//Broadcast Image to each edge PE
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: AssignIInValidFirstColumn
			assign I_In[i][0] = I_DataIn;
		end
		for(i = 1; i < K_PEGroupSize; i = i + 1) begin: AssignIInValidLastRow
			assign I_In[O_PEGroupSize - 1][i] = I_DataIn;
		end
		
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: AssignIInValidFirstColumn
			assign I_InValid[i][0] = I_DataInValid && (I_PEAddr == i);
		end
		for(i = 1; i < K_PEGroupSize; i = i + 1) begin: AssignIInValidLastRow
			assign I_InValid[O_PEGroupSize - 1][i] = I_DataInValid && (I_PEAddr == O_PEGroupSize - 1 + i);
		end

		//just discard the value
		for(i = 0; i < K_PEGroupSize; i = i + 1) begin: AssignIOutRdyFirstRow
			assign I_OutRdy[0][i] = 1'b1;
		end
		for(i = 1; i < O_PEGroupSize; i = i + 1) begin: AssignIOutRdyLastColumn
			assign I_OutRdy[i][K_PEGroupSize - 1] = 1'b1;
		end

		//Output
		//Broadcast Output to each edge PE
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: AssignOInValid
			assign O_In[i][0] = O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataIn : 0;
		end

		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: AssignOInValid
			assign O_InValid[i][0] = (O_In_PEAddr == i) && (O_IN_BLOCK_EQUAL_TO_ZERO ? O_DataInValid : ~O_IN_BLOCK_MORE_THAN_BLOCK_COUNT);
		end

		//ACC
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: AssignOInValid
			assign O_ACCDataOutRdy[i] = (O_Out_PEAddr == i) && O_DataOutRdy;
		end

	endgenerate

	generate    
		for ( i = 0 ; i < O_PEGroupSize ; i = i + 1) begin :generate_PE_i
			for ( j = 0 ; j < K_PEGroupSize ; j = j + 1)begin :generate_PE_j   
				PE #(.DataWidth(DataWidth))
				PE_buffer(
						.clk(clk),
						.aclr(aclr),
						
						// W part
						.W_DataInValid(K_InValid[i][j]),
						.W_DataInRdy(K_InRdy[i][j]),
						.W_DataIn(K_In[i][j]),
						.W_DataOut(K_Out[i][j]),
						.W_DataOutValid(K_OutValid[i][j]),
						.W_DataOutRdy(K_OutRdy[i][j]),
						
						// I part
						.I_DataInValid(I_InValid[i][j]),
						.I_DataInRdy(I_InRdy[i][j]),
						.I_DataIn(I_In[i][j]),
						.I_DataOut(I_Out[i][j]),
						.I_DataOutValid(I_OutValid[i][j]),
						.I_DataOutRdy(I_OutRdy[i][j]),
						
						// O part
						.O_DataInValid(O_InValid[i][j]),
						.O_DataInRdy(O_InRdy[i][j]),
						.O_DataIn(O_In[i][j]),
						.O_DataOut(O_Out[i][j]),
						.O_DataOutValid(O_OutValid[i][j]),
						.O_DataOutRdy(O_OutRdy[i][j])
				);
			end
		end
		
		for(i = 0; i < O_PEGroupSize - 1; i = i + 1) begin: Inner_Weight_Wires_i
			for(j = 0; j < K_PEGroupSize; j = j + 1) begin: Inner_Weight_Wires_j
				assign K_InValid[i+1][j] = K_OutValid[i][j];
				assign K_OutRdy[i][j] = K_InRdy[i+1][j];
				assign K_In[i+1][j] = K_Out[i][j];
			end
		end
		
		
		for(i = 0; i < O_PEGroupSize - 1; i = i + 1) begin: Inner_Input_Wires_i
			for(j = 1; j < K_PEGroupSize; j = j + 1) begin: Inner_Input_Wires_j
				assign I_InValid[i][j] = I_OutValid[i+1][j-1];
				assign I_OutRdy[i+1][j-1] = I_InRdy[i][j];
				assign I_In[i][j] = I_Out[i+1][j-1];
			end
		end
		
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: Inner_Output_Wires_i
			for(j = 1; j < K_PEGroupSize; j = j + 1) begin: Inner_Output_Wires_j
				assign O_InValid[i][j] = O_OutValid[i][j-1];
				assign O_OutRdy[i][j-1] = O_InRdy[i][j];
				assign O_In[i][j] = O_Out[i][j-1];
			end
		end
		
		for(i = 0; i < O_PEGroupSize; i = i + 1) begin: generate_ACC
			ACC #(	.DataWidth(DataWidth), .Pipeline_Stages(ACC_Pipeline_Stages), 
					.NOPCount(BlockCount), .NOPCountWidth(BlockCountWidth)) acc
				(	.clk(clk), .aclr(aclr), 
					.DataInValid(O_OutValid[i][K_PEGroupSize - 1]), .DataIn(O_Out[i][K_PEGroupSize - 1]), 
					.DataInRdy(O_OutRdy[i][K_PEGroupSize - 1]), .DataOutValid(O_ACCDataOutValid[i]), .DataOutRdy(O_ACCDataOutRdy[i]),
					.DataOut(O_ACCDataOut[i]));
		end
		
	endgenerate 
	
endmodule 