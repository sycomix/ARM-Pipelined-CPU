module oneBit (in, out, writeEn, clk);
	input logic writeEn, clk;
	input logic in;
	output logic out;
	logic curr;
	
	mux2_1 selectNext (.out(curr), .i0(out), .i1(in), .sel(writeEn));
	D_FF one_dff (.q(out), .d(curr), .reset(1'b0), .clk);
endmodule

module oneBit_testbench();
	logic writeEn, clk;
	logic in;
	logic out;
	
	oneBit dut (.in, .out, .writeEn, .clk);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 1; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 1; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 1; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 1; writeEn <= 1; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		in <= 0; writeEn <= 0; @(posedge clk);
		$stop;
	end
endmodule
