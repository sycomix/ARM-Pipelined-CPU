module SetSignals(instruction, Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite, read_enable, MemToReg, UncondBr, isAddIOp, isLSROp, xfer_size, flagEn);
	output logic Reg2Loc, RegWrite, ALUSrc, MemWrite, read_enable, MemToReg, UncondBr, isAddIOp, isLSROp, flagEn;
	output logic [2:0] ALUOp;
	input logic [31:0] instruction;
	//input logic BCondCheck, zero;
	logic [10:0] CPUOp;
	output logic [3:0] xfer_size;
	
	assign CPUOp = instruction[31:21];
	
	// figure out the instruction to perform
	always_comb begin
		casex(CPUOp)
			// AND
			11'b10001010000: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 1'b0;
				ALUOp = 3'b100;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end 
				
			// ADDS
			11'b10101011000: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 1'b0;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b1;
			end 
			
			// EOR
			11'b11001010000: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 1'b0;
				ALUOp = 3'b110;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end 
			
			// SUBS
			11'b11101011000: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 1'b0;
				ALUOp = 3'b011;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b1;
			end 
			
			// ADDI
			11'b1001000100x: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b1;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end 
			
			// LDUR
			11'b11111000010: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				read_enable = 1'b1;
				MemToReg = 1'b1;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'b1000;
				flagEn = 1'b0;
			end 
			
			// STUR
			11'b11111000000: begin
				Reg2Loc = 1'b0; //???
				RegWrite = 1'b0;
				ALUSrc = 1'b1;
				ALUOp = 3'b010;
				MemWrite = 1'b1;
				read_enable = 1'b0;
				MemToReg = 1'bx;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'b1000;
				flagEn = 1'b0;
			end 
			
			// CBZ
			11'b10110100xxx: begin
				Reg2Loc = 1'b0;
				RegWrite = 1'b0;
				ALUSrc = 1'b0;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'bx;
				//BrTaken = zero;  // zero signal
				UncondBr = 1'b0;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b1;
			end 
			
			// B.LT
			11'b01010100xxx: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 1'bx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'bx;
				//BrTaken = BCondCheck;
				UncondBr = 1'b0;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end 
			
			// B
			11'b000101xxxxx: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 1'bx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'bx;
				//BrTaken = 1'b1;
				UncondBr = 1'b1;
				isAddIOp = 1'b0;
				isLSROp = 1'b0;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end 
			
			// LSR
			11'b11010011010: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b1;
				ALUSrc = 1'bx;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				read_enable = 1'b0;
				MemToReg = 1'b0;
				//BrTaken = 1'b0;
				UncondBr = 1'bx;
				isAddIOp = 1'b0;
				isLSROp = 1'b1;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end
			
			default: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 1'bx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				read_enable = 1'bx;
				MemToReg = 1'bx;
				//BrTaken = 1'bx;
				UncondBr = 1'bx;
				isAddIOp = 1'bx;
				isLSROp = 1'bx;
				xfer_size = 4'bxxxx;
				flagEn = 1'b0;
			end
		endcase
	end
endmodule
