`include "riscv.vh"
module JTYPESEXT (
	input wire imm20,
	input wire [`BITS10] imm10_1,
	input wire imm11,
	input wire [`BITS8] imm19_12,
	output reg [`BITS32] jump
	);



always@(*)
	begin
		if (imm20 == `TRUE)
		begin
			jump = ({12'hfff, imm20, imm19_12, imm11, imm10_1} << 1);
		end
		else
		begin
			jump = ({12'h000, imm20, imm19_12, imm11, imm10_1} << 1);
		end
	end
	
endmodule // end JTYPESEXT
