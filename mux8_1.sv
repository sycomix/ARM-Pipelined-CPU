module mux8_1(out, i000, i001, i010, i011, i100, i101, i110, i111, sel0, sel1, sel2);
	output logic out;
	input logic i000, i001, i010, i011, i100, i101, i110, i111, sel0, sel1, sel2;

	logic v0, v1;

	mux4_1 m0 (.out(v0), .i00(i000), .i01(i001), .i10(i010), .i11(i011), .sel0, .sel1);
	mux4_1 m1 (.out(v1), .i00(i100), .i01(i101), .i10(i110), .i11(i111), .sel0, .sel1);
	mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel2));
endmodule

module mux8_1_testbench();
	logic i000, i001, i010, i011, i100, i101, i110, i111, sel0, sel1, sel2;
	logic out;

	mux8_1 dut (.out, .i000, .i001, .i010, .i011, .i100, .i101, .i110, .i111, .sel0, .sel1, .sel2);

	integer i;
	initial begin
		for(i=0; i<2048; i++) begin
			{sel2, sel1, sel0, i000, i001, i010, i011, i100, i101, i110, i111} = i; #10;
		end
	end
endmodule 