
/*

This module represents the register file for the single-cycle
RISC-V CPU. Inputs ir_1 and ir_2 are two register addresses (5 bit)
and the outputs are assigned to rs1 and rs2 outputs if control 
signal (rt_wen) is high. 

Michael Matirko
CSCI320 
Bucknell University

*/ 

module REGFILE(input clock, input rt_wen, input [4:0] ir1, ir2, wa, input [31:0] wd, output wire [31:0] rs1, rs2);
 	reg [6:0] i; 
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			registers[i] = 32'b0; 		
		end
	end 

	// Used to translate the indicies to register names when printing reg contents
	reg [4:0] reg_id; 
	wire [255:0] reg_str; 

	// Create the 32-word memory
	reg [31:0] registers [31:0];

	assign rs1 = registers[ir1];
	assign rs2 = registers[ir2];


	always @(negedge clock) begin
		if (rt_wen) 
			
			if (wa == 5'b0) 
				$display("%t: Attempted to write to $zero (address %b), write not performed", $time, wa);
			else

			// If write is enabled, perform the write
			registers[wa] = wd; 
		end 

	// This task is used to print out the contents of all of the registers
	// had to hardcode this because delays are a bad idea
	// reg names are in the same order as in the lab output sample
	task disp; 
		begin

			$display($time, ": zero: 0x%08h  ra: 0x%08h  sp: 0x%08h  gp: 0x%08h", registers[0], registers[1], registers[2], registers[3]);
			$display($time, ":   tp: 0x%08h  t0: 0x%08h  t1: 0x%08h  t2: 0x%08h", registers[4], registers[5], registers[6], registers[7]);
			$display($time, ":   s0: 0x%08h  s1: 0x%08h  a0: 0x%08h  a1: 0x%08h", registers[8], registers[9], registers[10], registers[11]);
			$display($time, ":   a2: 0x%08h  a3: 0x%08h  a4: 0x%08h  a5: 0x%08h", registers[12], registers[13], registers[14], registers[15]);
			$display($time, ":   a6: 0x%08h  a7: 0x%08h  s2: 0x%08h  s3: 0x%08h", registers[16], registers[17], registers[18], registers[19]);
			$display($time, ":   s4: 0x%08h  s5: 0x%08h  s6: 0x%08h  s7: 0x%08h", registers[20], registers[21], registers[22], registers[23]);
			$display($time, ":   s8: 0x%08h  s9: 0x%08h s10: 0x%08h s11: 0x%08h", registers[24], registers[25], registers[26], registers[27]);
			$display($time, ":   t3: 0x%08h  t4: 0x%08h  t5: 0x%08h  t6: 0x%08h", registers[28], registers[29], registers[30], registers[31]);
		end
	endtask

endmodule



