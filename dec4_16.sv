module dec4_16(out, sel, en);
	input logic en;
	input logic [3:0] sel;
	output logic [15:0] out;
	logic [3:0] v;
	
	dec2_4 d0 (.out(v), .sel(sel[3:2]), .en);
	dec2_4 d1 (.out(out[15:12]), .sel(sel[1:0]), .en(v[3]));
	dec2_4 d2 (.out(out[11:8]), .sel(sel[1:0]), .en(v[2]));
	dec2_4 d3 (.out(out[7:4]), .sel(sel[1:0]), .en(v[1]));
	dec2_4 d4 (.out(out[3:0]), .sel(sel[1:0]), .en(v[0]));
endmodule

module dec4_16_testbench();
	logic [3:0] sel;
	logic [15:0] out;
	logic en;
	
	dec4_16 dut (.out, .sel, .en);
	
	integer i;
	initial begin
		en=0;
		for (i=0; i<16; i++) begin
			sel = i; #10;
		end
		en=1;
		for (i=0; i<16; i++) begin
			sel = i; #10;
		end
	end
endmodule
