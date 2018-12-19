`timescale 1ns/10ps
module mux2_1(out, i0, i1, sel);
	output logic out;
	input logic i0, i1, sel;
	logic temp, temp1, temp2;
	
	and #0.05 andGate (temp, i1, sel);  // temp = i1 & sel
	not #0.05 notGate (temp1, sel);  // temp1 = ~sel
	and #0.05 andGate2 (temp2, temp1, i0);  // temp2 = ~sel & i0
	or #0.05 orGate (out, temp, temp2);  // out = (i1 & sel) | (i0 & ~sel);
endmodule

module mux2_1_testbench();
	logic i0, i1, sel;
	logic out;

	mux2_1 dut (.out, .i0, .i1, .sel);

	initial begin
		sel=0; i0=0; i1=0; #10;
		sel=0; i0=0; i1=1; #10;
		sel=0; i0=1; i1=0; #10;
		sel=0; i0=1; i1=1; #10;
		sel=1; i0=0; i1=0; #10;
		sel=1; i0=0; i1=1; #10;
		sel=1; i0=1; i1=0; #10;
		sel=1; i0=1; i1=1; #10;
	end
endmodule 
