/* 

This module contains the Jump Target Gen for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module TARGGEN_J (input [19:0] imm, input [31:0] cur_pc, output reg [`WIDTH-1:0] out); 
	always @(*) begin
		// Sign extend immediate to be the full 32 bits
		out = cur_pc + {{11{imm[19]}}, imm, 1'b0}; 
	end

endmodule
