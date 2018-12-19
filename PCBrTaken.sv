module PCBrTaken (flagEn, UncondBr, BCondCheck, zero, BrTaken);
	input logic flagEn, UncondBr, BCondCheck, zero;
	output logic BrTaken;
	
	always_comb begin
		if (UncondBr == 1'b1)
			BrTaken = 1'b1;
		else if (UncondBr == 1'b0) begin
			if (flagEn == 1'b1) begin
				if (zero == 1'b0 || zero == 1'b1)
					BrTaken = zero;
				else
					BrTaken = 1'b0;
//				BrTaken = zero;
			end else if (flagEn == 1'b0) begin
				if (BCondCheck == 1'b0 || BCondCheck == 1'b1) 
					BrTaken = BCondCheck;
				else 
					BrTaken = 1'b0;
//				BrTaken = BCondCheck;
			end else
				BrTaken = 1'b0;
		end else
			BrTaken = 1'b0;
	end
endmodule

module PCBrTaken_testbench();
	logic flagEn, UncondBr, BCondCheck, zero, BrTaken;
	
	PCBrTaken dut (.flagEn, .UncondBr, .BCondCheck, .zero, .BrTaken);
	
	initial begin
		UncondBr = 1'b1; #10;
		UncondBr = 1'b0; #10;
		flagEn = 1'b0; #10;
		flagEn = 1'b1; #10;
		flagEn = 1'bx; #10;
		UncondBr = 1'bx; #10;
	end
endmodule