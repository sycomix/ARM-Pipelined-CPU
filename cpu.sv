`timescale 1ns/10ps
module cpu(reset, clk);
	logic [63:0] PCAddr;
	logic [31:0] instruction;
	logic [63:0] WriteData, ReadData1, ReadData2; 
	
	input logic reset, clk;
	logic [4:0] RdAddr, RnAddr, RmAddr;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [11:0] Imm12;
	logic [8:0] Imm9;
	logic [5:0] Shamt;
	logic negative, zero, overflow, carry_out;
	logic negativeC, zeroC, overflowC, carry_outC, flagEn;
	logic invertClk; //reg clock
	
	// control signals
	logic Reg2Loc, RegWrite, ALUSrc, MemWrite, MemToReg, BrTaken, UncondBr;
	logic [2:0] ALUOp;
	logic BCondCheck, read_enable, isAddIOp, isLSROp;
	logic [3:0] xfer_size;
	
	// stage EX
	logic [4:0] EX_RdAddr, EX_RnAddr, EX_RegFileAb;
	logic [18:0] EX_CondAddr19;
	logic [25:0] EX_BrAddr26;
	logic [11:0] EX_Imm12;
	logic [8:0] EX_Imm9;
	logic [5:0] EX_Shamt;
	logic EX_RegWrite, EX_ALUSrc, EX_MemWrite, EX_MemToReg, EX_UncondBr;
	logic [2:0] EX_ALUOp;
	logic EX_read_enable, EX_isAddIOp, EX_isLSROp;
	logic [3:0] EX_xfer_size;
	logic [63:0] EX_ReadData1, EX_ReadData2, ALUResult;
	
	// stage MEM
	logic [4:0] MEM_RdAddr;
	logic [18:0] MEM_CondAddr19;
	logic [25:0] MEM_BrAddr26;
	logic MEM_RegWrite, MEM_MemWrite, MEM_MemToReg, MEM_UncondBr;
	logic MEM_read_enable;
	logic [3:0] MEM_xfer_size;
	logic [63:0] MEM_ALUResult, MEM_ReadData2;
	logic	[63:0] MEM_WriteData;
	
	// stage WB
	logic [4:0] WB_RdAddr;
	logic [63:0] WB_WriteData;
	logic WB_RegWrite;
	
	// get PC address
	PC pc (.reset, .clk, .out(PCAddr), .UncondBr(EX_UncondBr), .BrTaken(BrTaken), .CondAddr19(EX_CondAddr19), .BrAddr26(EX_BrAddr26));
	
	// get instruction
	instructmem getInstr (.address(PCAddr), .instruction, .clk);
								
	assign RdAddr = instruction[4:0];
	assign RnAddr = instruction[9:5];
	assign RmAddr = instruction[20:16];
	assign BrAddr26 = instruction[25:0];
	assign CondAddr19 = instruction[23:5];
	assign Imm12 = instruction[21:10];
	assign Imm9 = instruction[20:12];
	assign Shamt = instruction[15:10];
	
	// set signals
	SetSignals setS (.instruction, .Reg2Loc, .RegWrite, .ALUSrc, .ALUOp, .MemWrite, .read_enable, .MemToReg, 
							.UncondBr, .isAddIOp, .isLSROp, .xfer_size, .flagEn);
	
	// register file
	logic [4:0] RegFileAb;
	mux2_1 getAb0 (.out(RegFileAb[0]), .i0(RdAddr[0]), .i1(RmAddr[0]), .sel(Reg2Loc));
	mux2_1 getAb1 (.out(RegFileAb[1]), .i0(RdAddr[1]), .i1(RmAddr[1]), .sel(Reg2Loc));
	mux2_1 getAb2 (.out(RegFileAb[2]), .i0(RdAddr[2]), .i1(RmAddr[2]), .sel(Reg2Loc));
	mux2_1 getAb3 (.out(RegFileAb[3]), .i0(RdAddr[3]), .i1(RmAddr[3]), .sel(Reg2Loc));
	mux2_1 getAb4 (.out(RegFileAb[4]), .i0(RdAddr[4]), .i1(RmAddr[4]), .sel(Reg2Loc));
	regfile regFile (.ReadData1, .ReadData2, .WriteData(WB_WriteData), .ReadRegister1(RnAddr), 
				.ReadRegister2(RegFileAb), .WriteRegister(WB_RdAddr), .RegWrite(WB_RegWrite), .clk(invertClk));
	not #0.05 invertC (invertClk, clk);	// invert clock for forwarding
				
	// forwarding logic
	logic forward1, forward2;
	logic [63:0] forwardData1, forwardData2;
	logic [63:0] pipeData1, pipeData2;
	mux2_1_64 decideForward1 (.in0(ReadData1), .in1(forwardData1), .out(pipeData1), .sel(forward1));
	mux2_1_64 decideForward2 (.in0(ReadData2), .in1(forwardData2), .out(pipeData2), .sel(forward2));
	forwarding forwardLogic(.RF_Reg1(RnAddr), .RF_Reg2(RegFileAb), .ALUReg(EX_RdAddr), .ALUData(ALUResult), 
					.ALURegWrite(EX_RegWrite), .WBReg(MEM_RdAddr), .WBData(MEM_WriteData), .WBRegWrite(MEM_RegWrite),
					.forward1, .forward2, .forwardData1, .forwardData2);
						
	
	// --------------------------------------------------------------------------------------------------
	RegisterPipeline pipe1 (.RegWrite(RegWrite),       .RegWriteNew(EX_RegWrite),
									.ALUSrc(ALUSrc),           .ALUSrcNew(EX_ALUSrc),
									.MemWrite(MemWrite),       .MemWriteNew(EX_MemWrite),
									.MemToReg(MemToReg),       .MemToRegNew(EX_MemToReg),
									.UncondBr(UncondBr),       .UncondBrNew(EX_UncondBr),
									.read_enable(read_enable), .read_enableNew(EX_read_enable), 
									.isAddIOp(isAddIOp),       .isAddIOpNew(EX_isAddIOp),
									.isLSROp(isLSROp),         .isLSROpNew(EX_isLSROp),
									.ALUOp(ALUOp),             .ALUOpNew(EX_ALUOp), 
									.xfer_size(xfer_size),     .xfer_sizeNew(EX_xfer_size),
									.flagEn(flagEn),           .flagEnNew(EX_flagEn),
									.RdAddr(RdAddr),           .RdAddrNew(EX_RdAddr), 
									.RnAddr(RnAddr),           .RnAddrNew(EX_RnAddr),
									.RmAddr(RegFileAb),        .RmAddrNew(EX_RegFileAb),
									.CondAddr19(CondAddr19),   .CondAddr19New(EX_CondAddr19),
									.BrAddr26(BrAddr26),       .BrAddr26New(EX_BrAddr26),
									.Imm12(Imm12),             .Imm12New(EX_Imm12),
									.Imm9(Imm9),               .Imm9New(EX_Imm9),
									.Shamt(Shamt),             .ShamtNew(EX_Shamt),
									.data1(pipeData1), 			.data1New(EX_ReadData1),
									.data2(pipeData2), 			.data2New(EX_ReadData2),
									.reset, .clk);
									
	// LSR
	logic [63:0] LSRIn2;
	shifter LSR (.value(EX_ReadData1), .direction(1'b1), .distance(EX_Shamt), .result(LSRIn2));
	
	// execute stage
	logic [63:0] ALUIn2, ALUIn2_next, ALUMuxIn;
	mux2_1_64 getALUImm (.in0({{55{EX_Imm9[8]}}, EX_Imm9[8:0]}), .in1({{52'b0}, EX_Imm12[11:0]}), .out(ALUMuxIn), .sel(EX_isAddIOp));
	mux2_1_64 getALUIn2 (.in0(EX_ReadData2), .in1(ALUMuxIn), .out(ALUIn2), .sel(EX_ALUSrc));
	mux2_1_64 LSROp (.in0(ALUIn2), .in1(LSRIn2), .out(ALUIn2_next), .sel(EX_isLSROp));
	alu execALU (.A(EX_ReadData1), .B(ALUIn2_next), .cntrl(EX_ALUOp), .result(ALUResult), .negative, .zero, .overflow, .carry_out);
	
	controlFlags setFlags (.clk, .en(EX_flagEn), .negative, .zero, .overflow, .carry_out, .negativeC, .zeroC, .overflowC, .carry_outC);
	
	// set BrTaken signal
	PCBrTaken PCBrSignal (.flagEn(EX_flagEn), .UncondBr(EX_UncondBr), .zero, .BCondCheck, .BrTaken);
	
	// B.LT - compare negative flag and overflow flag
	// negative ^ overflow = BCondCheck
	xor #0.05 bCondCheck (BCondCheck, negativeC, overflowC);
	
	
	// --------------------------------------------------------------------------------------------------
	RegisterPipeline pipe2 (.RegWrite(EX_RegWrite),       .RegWriteNew(MEM_RegWrite),
									//.ALUSrc(),                   .ALUSrcNew(),
									.MemWrite(EX_MemWrite),       .MemWriteNew(MEM_MemWrite),
									.MemToReg(EX_MemToReg),       .MemToRegNew(MEM_MemToReg),
									//.UncondBr(),                  .UncondBrNew(),
									.read_enable(EX_read_enable), .read_enableNew(MEM_read_enable), 
									//.isAddIOp(),                 .isAddIOpNew(),
									//.isLSROp(),                  .isLSROpNew(),
									//.ALUOp(),                    .ALUOpNew(), 
									.xfer_size(EX_xfer_size),     .xfer_sizeNew(MEM_xfer_size),
									//.flagEn(),                   .flagEnNew(),
									.RdAddr(EX_RdAddr),           .RdAddrNew(MEM_RdAddr), 
									//.RnAddr(),                   .RnAddrNew(),
									//.RmAddr(),                   .RmAddrNew(),
									.CondAddr19(EX_CondAddr19),   .CondAddr19New(MEM_CondAddr19),
									.BrAddr26(EX_BrAddr26),       .BrAddr26New(MEM_BrAddr26),
									//.Imm12(),                    .Imm12New(),
									//.Imm9(),                     .Imm9New(),
									//.Shamt(),                    .ShamtNew(),
									.data1(ALUResult), 		      .data1New(MEM_ALUResult),
									.data2(EX_ReadData2), 	  	   .data2New(MEM_ReadData2),
									.reset, .clk);
									
	// memory stage
	logic	[63:0] DataMemDOut;
	datamem dataMem (.address(MEM_ALUResult), .write_enable(MEM_MemWrite), .read_enable(MEM_read_enable), .write_data(MEM_ReadData2),
							.clk, .xfer_size(MEM_xfer_size), .read_data(DataMemDOut));
	mux2_1_64 getWritebackData (.in0(MEM_ALUResult), .in1(DataMemDOut), .out(MEM_WriteData), .sel(MEM_MemToReg));
	
	
	// --------------------------------------------------------------------------------------------------
	RegisterPipeline pipe3 (.RegWrite(MEM_RegWrite),      .RegWriteNew(WB_RegWrite),
									//.ALUSrc(),                   .ALUSrcNew(),
									//.MemWrite(),                 .MemWriteNew(),
									//.MemToReg(),                 .MemToRegNew(WB_MemToReg),
									//.UncondBr(),                 .UncondBrNew(),
									//.read_enable(),              .read_enableNew(), 
									//.isAddIOp(),                 .isAddIOpNew(),
									//.isLSROp(),                  .isLSROpNew(),
									//.ALUOp(),                    .ALUOpNew(), 
									//.xfer_size(),                .xfer_sizeNew(),
									//.flagEn(),                   .flagEnNew(),
									.RdAddr(MEM_RdAddr),          .RdAddrNew(WB_RdAddr), 
									//.RnAddr(),                   .RnAddrNew(),
									//.RmAddr(),                   .RmAddrNew(),
									//.CondAddr19,()               .CondAddr19New(),
									//.BrAddr26(),                 .BrAddr26New(),
									//.Imm12(),                    .Imm12New(),
									//.Imm9(),                     .Imm9New(),
									//.Shamt(),                    .ShamtNew(),
									.data1(MEM_WriteData), 		   .data1New(WB_WriteData),
									//.data2(), 	  	             .data2New(),
									.reset, .clk);
									
endmodule 
