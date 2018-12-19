`timescale 1ns/10ps
module mux2_1_64 (in0, in1, out, sel);
	input logic sel;
	input logic [63:0] in0, in1;
	output logic [63:0] out;
	
	genvar i;
	generate 
		for (i = 0; i < 64; i++) begin : eachOut
			mux2_1 eachO (.out(out[i]), .i0(in0[i]), .i1(in1[i]), .sel);
		end
	endgenerate
endmodule

module mux2_1_64_testbench();
	logic sel;
	logic [63:0] in0, in1;
	logic [63:0] out;
	
	mux2_1_64 dut (in0, in1, out, sel);
	
	integer i;
	initial begin
		sel = 0;
		for (i = 0; i < 4; i++) begin
			in0 = $random(); in1 = $random(); #10;
		end
		sel = 1;
		for (i = 0; i < 4; i++) begin
			in0 = $random(); in1 = $random(); #10;
		end
	end
endmodule	
