module dec2_4(out, sel, en);
	input logic en;
	input logic [1:0] sel;
	output logic [3:0] out;
	logic v0, v1;
	
	dec1_2 d1 (.out0(v0), .out1(v1), .sel(sel[1]), .en);
	dec1_2 d2 (.out0(out[0]), .out1(out[1]), .sel(sel[0]), .en(v0));
	dec1_2 d3 (.out0(out[2]), .out1(out[3]), .sel(sel[0]), .en(v1));
endmodule

module dec2_4_testbench();
	logic [1:0] sel;
	logic en;
	logic [3:0] out;
	
	dec2_4 dut (.out, .sel, .en);
	
	integer i;
	initial begin
		en=0;
		for (i=0; i<4; i++) begin
			sel = i; #10;
		end
		en=1;
		for (i=0; i<4; i++) begin
			sel = i; #10;
		end
	end
endmodule
