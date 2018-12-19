module forwarding(RF_Reg1, RF_Reg2, ALUReg, ALUData, ALURegWrite, WBReg, WBData, WBRegWrite,
						forward1, forward2, forwardData1, forwardData2);
	input logic ALURegWrite, WBRegWrite;
	input logic [4:0] RF_Reg1, RF_Reg2, ALUReg, WBReg;
	input logic [63:0] ALUData, WBData;
	output logic forward1, forward2;
	output logic [63:0] forwardData1, forwardData2;
	
	always_comb begin
		if ((RF_Reg1 != 5'd31) & ALURegWrite & WBRegWrite & (RF_Reg1 == ALUReg) & (RF_Reg1 == WBReg)) begin
			forward1 = 1'b1;
			forwardData1 = ALUData;
		end else if ((RF_Reg1 != 5'd31) & ALURegWrite & (RF_Reg1 == ALUReg)) begin
			forward1 = 1'b1;
			forwardData1 = ALUData;
		end else if ((RF_Reg1 != 5'd31) & WBRegWrite & (RF_Reg1 == WBReg)) begin
			forward1 = 1'b1;
			forwardData1 = WBData;
		end else begin
			forward1 = 1'b0;
			forwardData1 = 64'bx;
		end
		
		if ((RF_Reg2 != 5'd31) & ALURegWrite & WBRegWrite & (RF_Reg2 == ALUReg) & (RF_Reg2 == WBReg)) begin
			forward2 = 1'b1;
			forwardData2 = ALUData;
		end else if ((RF_Reg2 != 5'd31) & ALURegWrite & (RF_Reg2 == ALUReg)) begin
			forward2 = 1'b1;
			forwardData2 = ALUData;
		end else if ((RF_Reg2 != 5'd31) & WBRegWrite & (RF_Reg2 == WBReg)) begin
			forward2 = 1'b1;
			forwardData2 = WBData;
		end else begin
			forward2 = 1'b0;
			forwardData2 = 64'bx;
		end
	end
endmodule

module forwarding_testbench();
	logic ALURegWrite, WBRegWrite;
	logic [4:0] RF_Reg1, RF_Reg2, ALUReg, WBReg;
	logic [63:0] ALUData, WBData;
	logic forward1, forward2;
	logic [63:0] forwardData1, forwardData2;
	
	forwarding dut (.RF_Reg1, .RF_Reg2, .ALUReg, .ALUData, .ALURegWrite, .WBReg, .WBData, .WBRegWrite,
						.forward1, .forward2, .forwardData1, .forwardData2);
	
	integer i, j;
	parameter delay = 10;
	
	initial begin
		$display("Testing with register 31");
		RF_Reg1 = 5'd31; RF_Reg2 = 5'd31;
		for (i = 0; i < 4; i++) begin
			{WBRegWrite, ALURegWrite} = i;
			#(delay);
			assert(forward1 == 1'b0 && forward2 == 1'b0);
		end
		
		$display("Testing RF_Reg1");
		$display("{ALURegWrite, WBRegWrite} = 2'b00");
		ALURegWrite = 1'b0;
		WBRegWrite = 1'b0;
		$display("Testing RF_Reg1 == ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		#(delay);
		assert(forward1 == 1'b0);
		$display("Testing RF_Reg1 = ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b0);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		#(delay);
		assert(forward1 == 1'b0);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b01");
		ALURegWrite = 1'b0;
		WBRegWrite = 1'b1;
		$display("Testing RF_Reg1 == ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == WBData);
		$display("Testing RF_Reg1 = ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b0);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == WBData);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b10");
		ALURegWrite = 1'b1;
		WBRegWrite = 1'b0;
		$display("Testing RF_Reg1 == ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		ALUData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == ALUData);
		$display("Testing RF_Reg1 = ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		ALUData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == ALUData);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		#(delay);
		assert(forward1 == 1'b0);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b11");
		ALURegWrite = 1'b1;
		WBRegWrite = 1'b1;
		$display("Testing RF_Reg1 == ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		ALUData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == ALUData);
		$display("Testing RF_Reg1 = ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == ALUData);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 == WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward1 == 1'b1 && forwardData1 == WBData);
		$display("Testing RF_Reg1 != ALUReg, RF_Reg1 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		WBData = $random();
		#(delay);
		assert(forward1 == 1'b0);
		
		// -----------------------------------------------------
		$display("Testing RF_Reg2");
		$display("{ALURegWrite, WBRegWrite} = 2'b00");
		ALURegWrite = 1'b0;
		WBRegWrite = 1'b0;
		$display("Testing RF_Reg2 == ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		#(delay);
		assert(forward2 == 1'b0);
		$display("Testing RF_Reg2 = ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b0);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		#(delay);
		assert(forward2 == 1'b0);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b01");
		ALURegWrite = 1'b0;
		WBRegWrite = 1'b1;
		$display("Testing RF_Reg2 == ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == WBData);
		$display("Testing RF_Reg2 = ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b0);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == WBData);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b10");
		ALURegWrite = 1'b1;
		WBRegWrite = 1'b0;
		$display("Testing RF_Reg2 == ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		ALUData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == ALUData);
		$display("Testing RF_Reg2 = ALUReg, RF_Reg2 != WBReg");
		RF_Reg1 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		ALUData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == ALUData);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		#(delay);
		assert(forward2 == 1'b0);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b0);
		
		$display("{ALURegWrite, WBRegWrite} = 2'b11");
		ALURegWrite = 1'b1;
		WBRegWrite = 1'b1;
		$display("Testing RF_Reg2 == ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd1;
		ALUData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == ALUData);
		$display("Testing RF_Reg2 = ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd1; WBReg = 64'd2;
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == ALUData);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 == WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd1;
		WBData = $random();
		#(delay);
		assert(forward2 == 1'b1 && forwardData2 == WBData);
		$display("Testing RF_Reg2 != ALUReg, RF_Reg2 != WBReg");
		RF_Reg2 = 64'd1; ALUReg = 64'd2; WBReg = 64'd2;
		WBData = $random();
		#(delay);
		assert(forward2 == 1'b0);
			
	end
endmodule
