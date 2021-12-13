/* 

This module contains the Branch Target Gen for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module TARGGEN_B (input [11:0] imm, input [31:0] cur_pc, output reg [`WIDTH-1:0] out); 
	always @(*) begin
		// Sign extend immediate to be the full 32 bits
		out = cur_pc + {{20{imm[11]}}, imm, 1'b0}; 
	end

endmodule
