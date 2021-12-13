`include "riscv.vh"
module BRANCHTARGGEN (
	input wire [`BITS32] pc,
	input wire imm12,
	input wire [`BITS6] imm10_5,
	input wire [`BITS4] imm4_1,
	input wire imm11,
	output reg [`BITS32] branch
	);

always@(*)
	begin
		if (imm12 == 1'b1)
		begin
			branch = pc + ({20'hfffff, imm12, imm11, imm10_5, imm4_1} << 1);	
		end
		else 
		begin
			branch = pc + ({20'h00000, imm12, imm11, imm10_5, imm4_1} << 1);
		end
	end
	
endmodule // end BRANCHTARGGEN
