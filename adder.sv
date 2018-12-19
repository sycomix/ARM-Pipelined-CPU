`timescale 1ns/10ps
module adder(A, B, cin, cout, sum);
	input logic A, B, cin;
	output logic cout, sum;
	logic cout1, cout2, cout3;
	
	and #0.05 logic1 (cout1, A, B);
	and #0.05 logic2 (cout2, A, cin);
	and #0.05 logic3 (cout3, B, cin);
	or #0.05 logic4 (cout, cout1, cout2, cout3);
	
	xor #0.05 logic5 (sum, A, B, cin);
endmodule

module adder_testbench();
	logic A, B, cin;
	logic cout, sum;
	
	adder dut (.A, .B, .cin, .cout, .sum);
	
	integer i;
	initial begin
		for (i = 0; i < 2**3; i++) begin
			{A, B, cin} = i; #10;
		end
	end
endmodule
