`include "riscv.vh"
module UTYPE(
	input wire [`BITS20] imm20, 
	output reg [`BITS32] imm32
	);

always@(*)
	begin
		imm32 <= {imm20, 12'h000};
	end

endmodule // end UType