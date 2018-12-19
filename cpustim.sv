`timescale 1ns/10ps
module cpustim();
	logic reset, clk;
	
	parameter ClockDelay = 5000;
	
	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	cpu dut (.reset, .clk);
	
	integer i;
	initial begin
		reset = 1; @(posedge clk);
		reset = 0; @(posedge clk);
		for (i = 0; i < 500; i++) begin
			@(posedge clk);
		end
		$stop;
	end
endmodule
		