module RegisterPipeline(RegWrite, RegWriteNew,
								ALUSrc, ALUSrcNew,
								MemWrite, MemWriteNew,
								MemToReg, MemToRegNew,
								UncondBr, UncondBrNew,
								read_enable, read_enableNew,
								isAddIOp, isAddIOpNew,
								isLSROp, isLSROpNew,
								ALUOp, ALUOpNew,
								xfer_size, xfer_sizeNew,
								flagEn, flagEnNew,
								RdAddr, RdAddrNew,
								RnAddr, RnAddrNew,
								RmAddr, RmAddrNew,
								CondAddr19, CondAddr19New,
								BrAddr26, BrAddr26New,
								Imm12, Imm12New,
								Imm9, Imm9New,
								Shamt, ShamtNew,
								data1, data1New,
								data2, data2New,
								reset, clk);
							
	input logic RegWrite, ALUSrc, MemWrite, MemToReg, UncondBr, read_enable, isAddIOp, isLSROp;
	input logic [2:0] ALUOp;
	input logic [3:0] xfer_size;
	input logic flagEn;
	input logic [4:0] RdAddr, RnAddr, RmAddr;
	
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	input logic [11:0] Imm12;
	input logic [8:0] Imm9;
	input logic [5:0] Shamt;
	input logic [63:0] data1, data2;
	
	
	output logic RegWriteNew, ALUSrcNew, MemWriteNew, MemToRegNew, UncondBrNew, read_enableNew, isAddIOpNew, isLSROpNew;
	output logic [2:0] ALUOpNew;
	output logic [3:0] xfer_sizeNew;
	output logic flagEnNew;
	output logic [4:0] RdAddrNew, RnAddrNew, RmAddrNew;
	
	output logic [18:0] CondAddr19New;
	output logic [25:0] BrAddr26New;
	output logic [11:0] Imm12New;
	output logic [8:0] Imm9New;
	output logic [5:0] ShamtNew;
	output logic [63:0] data1New, data2New;
	
	input logic reset, clk;

	D_FF RegWriteInst (.q(RegWriteNew), .d(RegWrite), .reset, .clk);
	D_FF ALUSrcInst (.q(ALUSrcNew), .d(ALUSrc), .reset, .clk);
	D_FF MemWriteInst (.q(MemWriteNew), .d(MemWrite), .reset, .clk);
	D_FF MemToRegInst (.q(MemToRegNew), .d(MemToReg), .reset, .clk);
	D_FF UncondBrInst (.q(UncondBrNew), .d(UncondBr), .reset, .clk);
	D_FF read_enableInst (.q(read_enableNew), .d(read_enable), .reset, .clk);
	D_FF isAddIOpInst (.q(isAddIOpNew), .d(isAddIOp), .reset, .clk);
	D_FF isLSROpInst (.q(isLSROpNew), .d(isLSROp), .reset, .clk);

	// Aluop
	D_FF ALUOpInst0 (.q(ALUOpNew[0]), .d(ALUOp[0]), .reset, .clk);
	D_FF ALUOpInst1 (.q(ALUOpNew[1]), .d(ALUOp[1]), .reset, .clk);
	D_FF ALUOpInst2 (.q(ALUOpNew[2]), .d(ALUOp[2]), .reset, .clk);
	
	// xfer_size
	D_FF xfer_sizeInst0 (.q(xfer_sizeNew[0]), .d(xfer_size[0]), .reset, .clk);
	D_FF xfer_sizeInst1 (.q(xfer_sizeNew[1]), .d(xfer_size[1]), .reset, .clk);
	D_FF xfer_sizeInst2 (.q(xfer_sizeNew[2]), .d(xfer_size[2]), .reset, .clk);
	D_FF xfer_sizeInst3 (.q(xfer_sizeNew[3]), .d(xfer_size[3]), .reset, .clk);
	
	// zero, flagEn
	D_FF zeroInst (.q(zeroNew), .d(zero), .reset, .clk);
	D_FF flagEnInst (.q(flagEnNew), .d(flagEn), .reset, .clk);
	
	// RdAddr
	D_FF RdAddrInst0 (.q(RdAddrNew[0]), .d(RdAddr[0]), .reset, .clk);
	D_FF RdAddrInst1 (.q(RdAddrNew[1]), .d(RdAddr[1]), .reset, .clk);
	D_FF RdAddrInst2 (.q(RdAddrNew[2]), .d(RdAddr[2]), .reset, .clk);
	D_FF RdAddrInst3 (.q(RdAddrNew[3]), .d(RdAddr[3]), .reset, .clk);
	D_FF RdAddrInst4 (.q(RdAddrNew[4]), .d(RdAddr[4]), .reset, .clk);
	
	// RnAddr
	D_FF RnAddrInst0 (.q(RnAddrNew[0]), .d(RnAddr[0]), .reset, .clk);
	D_FF RnAddrInst1 (.q(RnAddrNew[1]), .d(RnAddr[1]), .reset, .clk);
	D_FF RnAddrInst2 (.q(RnAddrNew[2]), .d(RnAddr[2]), .reset, .clk);
	D_FF RnAddrInst3 (.q(RnAddrNew[3]), .d(RnAddr[3]), .reset, .clk);
	D_FF RnAddrInst4 (.q(RnAddrNew[4]), .d(RnAddr[4]), .reset, .clk);
	
	// RmAddr
	D_FF RmAddrInst0 (.q(RmAddrNew[0]), .d(RmAddr[0]), .reset, .clk);
	D_FF RmAddrInst1 (.q(RmAddrNew[1]), .d(RmAddr[1]), .reset, .clk);
	D_FF RmAddrInst2 (.q(RmAddrNew[2]), .d(RmAddr[2]), .reset, .clk);
	D_FF RmAddrInst3 (.q(RmAddrNew[3]), .d(RmAddr[3]), .reset, .clk);
	D_FF RmAddrInst4 (.q(RmAddrNew[4]), .d(RmAddr[4]), .reset, .clk);
	
	// CondAddr19
	genvar i;
	generate 
		for (i = 0; i < 19; i++) begin : CondAddr19Loop
			D_FF CondAddr19Inst (.q(CondAddr19New[i]), .d(CondAddr19[i]), .reset, .clk);
		end
	endgenerate
	
	// BrAddr26
	genvar j;
	generate 
		for (j = 0; j < 26; j++) begin : BrAddr26Loop
			D_FF BrAddr26Inst (.q(BrAddr26New[j]), .d(BrAddr26[j]), .reset, .clk);
		end
	endgenerate
	
	// Imm12
	genvar k;
	generate 
		for (k = 0; k < 12; k++) begin : Imm12Loop
			D_FF Imm12Inst (.q(Imm12New[k]), .d(Imm12[k]), .reset, .clk);
		end
	endgenerate
	
	// Imm9
	genvar l;
	generate 
		for (l = 0; l < 9; l++) begin : Imm9Loop
			D_FF Imm9Inst (.q(Imm9New[l]), .d(Imm9[l]), .reset, .clk);
		end
	endgenerate
	
	// Shamt
	genvar m;
	generate 
		for (m = 0; m < 7; m++) begin : ShamtLoop
			D_FF ShamtInst (.q(ShamtNew[m]), .d(Shamt[m]), .reset, .clk);
		end
	endgenerate
	
	// data1
	D_FF_64 data1Inst (.in(data1), .out(data1New), .reset, .clk);
	
	// data2
	D_FF_64 data2Inst (.in(data2), .out(data2New), .reset, .clk);
endmodule 