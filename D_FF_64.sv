`timescale 1ns/10ps
module D_FF_64 (in, out, reset, clk);
	input logic reset, clk;
	input logic [63:0] in;
	output logic [63:0] out;
	
	genvar i;
	generate 
		for (i = 0; i < 64; i++) begin : eachOut
			D_FF eachO (.q(out[i]), .d(in[i]), .reset, .clk);
		end
	endgenerate
endmodule

module D_FF_64_testbench();
	logic reset, clk;
	logic [63:0] in, out;
	
	D_FF_64 dut (.in, .out, .reset, .clk);
	
	parameter ClockDelay = 5000;	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		integer i;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		for (i = 0; i < 50; i++) begin 
			in <= $random(); @(posedge clk);
		end
		$stop;
	end
endmodule
