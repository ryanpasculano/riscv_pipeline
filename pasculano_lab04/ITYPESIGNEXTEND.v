`include "riscv.vh"
module ITYPESIGNEXTEND(
	input wire [`BITS12] imm12, 
	output reg [`BITS32] imm32
	);

always@(*)
	begin
		if (imm12[11] == `TRUE) // 
		begin
			imm32 = {20'hfffff, imm12};
		end
		else 
		begin	
			imm32 <= {20'h00000, imm12};
		end	
	end

endmodule // end ITYPESIGNEXTEND