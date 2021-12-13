`include "riscv.vh"
module STYPESEXT(
	input wire [`BITS7] imm11_5, 
	input wire [`BITS5] imm4_0, 
	output reg [`BITS32] imm32
	);



always@(*)
	begin
		if (imm11_5[6] == `TRUE)
		begin
			imm32 = {20'h11111, imm11_5, imm4_0};
		end
		else
		begin	
			imm32 = {20'h00000, imm11_5, imm4_0};
		end		
	end

endmodule // end STypeSExt