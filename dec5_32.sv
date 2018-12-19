module dec5_32(out, sel, en);
	input logic en;
	input logic [4:0] sel;
	output logic [31:0] out;
	logic [1:0] v;
	
	dec1_2 d0 (.out0(v[0]), .out1(v[1]), .sel(sel[4]), .en);
	dec4_16 d1 (.out(out[31:16]), .sel(sel[3:0]), .en(v[1]));
	dec4_16 d2 (.out(out[15:0]), .sel(sel[3:0]), .en(v[0]));
endmodule

module dec5_32_testbench();
	logic [4:0] sel;
	logic [31:0] out;
	logic en;
	
	dec5_32 dut (.out, .sel, .en);
	
	integer i;
	initial begin
		en=0;
		for (i=0; i<32; i++) begin
			sel = i; #10;
		end
		en=1;
		for (i=0; i<32; i++) begin
			sel = i; #10;
		end
	end
endmodule