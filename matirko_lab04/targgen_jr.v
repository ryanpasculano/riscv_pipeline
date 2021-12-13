/* 

This module contains the Jump Register Target Gen for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module TARGGEN_JR (input [`WIDTH-1:0] rs1, imm, output reg [`WIDTH-1:0] out); 
	always @(*) begin
		out = rs1 + {imm, 1'b0}; 
	end

endmodule
