module controlFlags(clk, en, negative, zero, overflow, carry_out, negativeC, zeroC, overflowC, carry_outC);
	input logic clk, en, negative, zero, overflow, carry_out;
	output logic negativeC, zeroC, overflowC, carry_outC;
	
	oneBit f0 (.in(negative), .out(negativeC), .writeEn(en), .clk);
	oneBit f1 (.in(zero), .out(zeroC), .writeEn(en), .clk);
	oneBit f2 (.in(overflow), .out(overflowC), .writeEn(en), .clk);
	oneBit f3 (.in(carry_out), .out(carry_outC), .writeEn(en), .clk);
endmodule
