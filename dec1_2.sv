`timescale 1ns/10ps
module dec1_2(out0, out1, sel, en);
	input logic sel, en;
	output logic out0, out1;
	logic temp;
	
	not #0.05 notGate (temp, sel);
	and #0.05 andGate0 (out0, temp, en);  // out0 = ~sel & en;
	and #0.05 andGate1 (out1, sel, en);  // out1 = sel & en;
endmodule

module dec1_2_testbench();
	logic sel, en;
	logic out0, out1;
	
	dec1_2 dut (.out0, .out1, .sel, .en);
	
	initial begin
		sel=0; en=1; #10;
		sel=0; #10;
		sel=1; en=0;#10;
		sel=1; en=1;#10;
		sel=0; #10;
		sel=1; #10;
		sel=0; en=0;#10;
		sel=0; #10;
	end
endmodule
