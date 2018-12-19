`timescale 1ns/10ps
module bitSlice(cntrl, A, B, cin, cout, result);
	input logic A, B, cin;
	input logic [2:0] cntrl;
	output logic cout, result;
	logic v0, sum, v4, v5, v6;
	logic iB, usefulB;
	
	// cntrl			Operation						Notes:
	// 000:			result = B						value of overflow and carry_out unimportant
	// 010:			result = A + B
	// 011:			result = A - B
	// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
	// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
	// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
	
	buf #0.05 logic0 (v0, B);
	
	not #0.05 inverseIn0 (iB, B);
	mux2_1 modifiedB (.out(usefulB), .i0(B), .i1(iB), .sel(cntrl[0]));
	adder logic23 (.A, .B(usefulB), .cin, .cout, .sum);
	
	and #0.05 logic4 (v4, A, B);
	or #0.05 logic5 (v5, A, B);
	xor #0.05 logic6 (v6, A, B);
	
	mux8_1 res (.out(result), .i000(v0), .i001(result), .i010(sum), .i011(sum), .i100(v4), .i101(v5), .i110(v6), .i111(result), .sel0(cntrl[0]), .sel1(cntrl[1]), .sel2(cntrl[2]));
	
endmodule

module bitSlice_testbench();
	logic A, B, cin, cout, result;
	logic [2:0] cntrl;

	bitSlice dut (.cntrl, .A, .B, .cin, .cout, .result);
	
	integer i;
	initial begin
		for (i = 0; i < 2**6; i++) begin
			{A, B, cin, cntrl} = i; #10;
		end
	end
endmodule 