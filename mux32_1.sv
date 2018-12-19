module mux32_1(out, i0, i1, sel0, sel1, sel2, sel3, sel4);
	output logic out;
	input logic [15:0] i0, i1;
	input logic sel0, sel1, sel2, sel3, sel4;

	logic v0, v1;

	mux16_1 m0 (.out(v0), .i0(i0[7:0]), .i1(i0[15:8]), .sel0, .sel1, .sel2, .sel3);
	mux16_1 m1 (.out(v1), .i0(i1[7:0]), .i1(i1[15:8]), .sel0, .sel1, .sel2, .sel3);
	mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel4));
endmodule

module mux32_1_testbench();
	logic [15:0] i0, i1;
	logic sel0, sel1, sel2, sel3, sel4;
	logic out;

	mux32_1 dut (.out, .i0, .i1, .sel0, .sel1, .sel2, .sel3, .sel4);

	integer i;
	integer j;
	integer k;
	initial begin
		for(i=0; i<32; i++) begin
			{sel4, sel3, sel2, sel1, sel0} = i;
			for(j=0; j<2**16; j++) begin
				{i0[0], i0[1], i0[2], i0[3], i0[4], i0[5], i0[6], i0[7],
				 i0[8], i0[9], i0[10], i0[11], i0[12], i0[13], i0[14], i0[15]} = j;
				for(k=0; k<2**16; k++) begin
					{i1[0], i1[1], i1[2], i1[3], i1[4], i1[5], i1[6], i1[7],
					 i1[8], i1[9], i1[10], i1[11], i1[12], i1[13], i1[14], i1[15]} = k; #10;
				end
			end
		end
	end
endmodule 