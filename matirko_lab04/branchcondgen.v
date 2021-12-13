/* 

This module contains the Branch Condition Generator for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module BRANCHCONDGEN (input [31:0] rs1, rs2, output reg br_eq, br_lt, br_ltu); 
	always @(*) begin
		br_eq =  rs1 == rs2 ? 1'b1 : 1'b0;
		br_lt = ($signed(rs1) < $signed(rs2))  ? 1'b1 : 1'b0;
		br_ltu =  rs1 < rs2  ? 1'b1 : 1'b0; 
	end

endmodule
