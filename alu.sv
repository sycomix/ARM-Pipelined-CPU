`timescale 1ns/10ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic[63:0] A, B;
	output logic[63:0] result;
	input logic[2:0] cntrl;
	output logic zero, negative, overflow, carry_out;
	logic isNegateOp, tmp0, tmp1;
	logic [63:0] cOutBits;
	
	not #0.05 logic0 (tmp0, cntrl[2]);
	and #0.05 logic1 (isNegateOp, tmp0, cntrl[1], cntrl[0]);

	bitSlice b0 (.cntrl, .A(A[0]), .B(B[0]), .cin(isNegateOp), .cout(cOutBits[0]), .result(result[0]));
	
	genvar i;
	generate 
		for (i = 1; i < 64; i++) begin : eachBit
			bitSlice bI (.cntrl, .A(A[i]), .B(B[i]), .cin(cOutBits[i - 1]), .cout(cOutBits[i]), .result(result[i]));
		end
	endgenerate
	
	// zero flag
	logic [15:0][15:0] out1;
	genvar j;
	generate
		for (j = 0; j < 16; j++) begin : eachOut1
			dec4_16 d (.out(out1[j][15:0]), .sel(result[j * 4 + 3: j * 4]), .en(1'b1));
		end
	endgenerate

	logic [3:0][15:0] out2;
	genvar k;
	generate
		for (k = 0; k < 4; k++) begin : eachOut2
			dec4_16 d (.out(out2[k]), .sel({out1[4 * k][0], out1[4 * k + 1][0], out1[4 * k + 2][0], out1[4 * k + 3][0]}), .en(1'b1));
		end
	endgenerate
	
	logic [15:0] out3;
	dec4_16 d (.out(out3), .sel({out2[0][15], out2[1][15], out2[2][15], out2[3][15]}), .en(1'b1));
	buf #0.05 isZero (zero, out3[15]);

	
	// negative flag
	buf #0.05 isNegative (negative, result[63]);
	
	// overflow flag
	xor #0.05 isOverflow (overflow, cOutBits[63], cOutBits[62]);
	
	// carry_out flag
	buf #0.05 getCarryOut (carry_out, cOutBits[63]);
endmodule
