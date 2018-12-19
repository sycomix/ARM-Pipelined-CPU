module regfile (ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk);
	input logic RegWrite, clk;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	logic [31:0] selRegister;
	logic [63:0][31:0] curr;
	
	logic [31:0][63:0] registers;
	
	dec5_32 writeControl (.out(selRegister), .sel(WriteRegister), .en(RegWrite));
	
	integer l;
	always_comb begin
		for (l = 0; l < 64; l++) begin
			curr[l][31] = 1'b0;
		end
	end
	
	genvar i;
	genvar k;
	generate 
		for (i = 0; i < 31; i++) begin : eachReg
			for (k = 0; k < 64; k++) begin : eachBit
				oneBit oBit (.in(WriteData[k]), .out(curr[k][i]), .writeEn(selRegister[i]), .clk);
			end
		end
	endgenerate
	
	genvar j;
	generate 
		for (j = 0; j < 64; j++) begin : oneBit
			mux32_1 read1 (.out(ReadData1[j]), .i0(curr[j][15:0]), .i1(curr[j][31:16]),
								.sel0(ReadRegister1[0]), .sel1(ReadRegister1[1]), .sel2(ReadRegister1[2]),
								.sel3(ReadRegister1[3]), .sel4(ReadRegister1[4]));
			mux32_1 read2 (.out(ReadData2[j]), .i0(curr[j][15:0]), .i1(curr[j][31:16]),
								.sel0(ReadRegister2[0]), .sel1(ReadRegister2[1]), .sel2(ReadRegister2[2]),
								.sel3(ReadRegister2[3]), .sel4(ReadRegister2[4]));
		end
	endgenerate
	
	integer m, n;
	always_comb begin
		for (m = 0; m < 32; m++) begin
			for (n = 0; n < 64; n++) begin
				registers[m][n] = curr[n][m];
			end
		end
	end
endmodule
