`timescale 1ns/10ps
module PC (reset, clk, out, UncondBr, BrTaken, CondAddr19, BrAddr26);
	input logic reset, clk, BrTaken, UncondBr;
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	output logic [63:0] out;
	logic [63:0] current, addFour, branch, selBr1, selBr2, CondAddr19_e, BrAddr26_e, prev, next;
	
	assign CondAddr19_e = {{45{CondAddr19[18]}}, CondAddr19[18:0]};
	assign BrAddr26_e = {{38{BrAddr26[25]}}, BrAddr26[25:0]};
	
	mux2_1_64 BrSrc (.in0(CondAddr19_e), .in1(BrAddr26_e),.out(selBr1), .sel(UncondBr));
	mux2_1_64 PCSrc (.in0(addFour), .in1(branch),.out(next), .sel(BrTaken));
	D_FF_64 transfer (.in(next), .out, .reset, .clk);
	
	// branch
	D_FF_64 keepOld (.in(out), .out(prev), .reset, .clk);
	mux2_1_64 chooseSrc (.in0(out), .in1(prev),.out(current), .sel(BrTaken));

	shifter mul4 (.value(selBr1), .direction(1'b0), .distance(6'b010), .result(selBr2));
	alu addBr (.A(current), .B(selBr2), .cntrl(3'b010), .result(branch), .negative(), .zero(), .overflow(), .carry_out());
	alu add4 (.A(current), .B(64'b0100), .cntrl(3'b010), .result(addFour), .negative(), .zero(), .overflow(), .carry_out());
			
endmodule

module PC_testbench();
	logic reset, clk, BrTaken, UncondBr;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [63:0] out;
	
	parameter ClockDelay = 5000;
	
	PC dut (.reset, .clk, .out, .UncondBr, .BrTaken, .CondAddr19, .BrAddr26);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		integer i, j;
		reset <= 1; @(posedge clk);
		reset <= 0; //@(posedge clk);
		
		for (i = 0; i < 4; i++) begin
			{BrTaken, UncondBr} = i;
			for (j = 0; j < 50; j++) begin 
				CondAddr19 = $random(); BrAddr26 = $random();
				@(posedge clk);
			end
		end
		$stop;
	end
endmodule

