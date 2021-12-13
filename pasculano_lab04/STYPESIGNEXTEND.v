`include "riscv.vh"
module STYPESIGNEXTEND(
	input wire [`BITS7] imm7, 
	input wire [`BITS5] imm5, 
	output reg [`BITS32] imm32
	);


always@(*)
	begin
		if (imm7[6] == `TRUE)
		begin
			imm32 = {20'h11111, imm7, imm5};
		end
		else
		begin	
			imm32 = {20'h00000, imm7, imm5};
		end		
	end

endmodule // end STypeSignExtend