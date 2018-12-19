module mux16_1(out, i0, i1, sel0, sel1, sel2, sel3);
	output logic out;
	input logic [7:0] i0, i1;
	input logic sel0, sel1, sel2, sel3;

	logic v0, v1, v2;

	mux8_1 m0 (.out(v0), .i000(i0[0]), .i001(i0[1]), .i010(i0[2]), .i011(i0[3]),
					.i100(i0[4]), .i101(i0[5]), .i110(i0[6]), .i111(i0[7]), .sel0, .sel1, .sel2);
	mux8_1 m1 (.out(v1), .i000(i1[0]), .i001(i1[1]), .i010(i1[2]), .i011(i1[3]),
					.i100(i1[4]), .i101(i1[5]), .i110(i1[6]), .i111(i1[7]), .sel0, .sel1, .sel2);
	mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel3));
endmodule

module mux16_1_testbench();
	logic [7:0] i0, i1;
	logic sel0, sel1, sel2, sel3;
	logic out;

	mux16_1 dut (.out, .i0, .i1, .sel0, .sel1, .sel2, .sel3);

	integer i;
	integer j;
	initial begin
		for(i=0; i<2**4; i++) begin
			{sel3, sel2, sel1, sel0} = i;
			for(j=0; j<2**16; j++) begin
				{i0[0], i0[1], i0[2], i0[3], i0[4], i0[5], i0[6], i0[7],
				 i1[0], i1[1], i1[2], i1[3], i1[4], i1[5], i1[6], i1[7]} = j; #10;
			end
		end
	end
endmodule 