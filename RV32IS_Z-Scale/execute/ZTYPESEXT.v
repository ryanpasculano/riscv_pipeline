`include "riscv.vh"
module ZTYPESEXT(
	input wire [`BITS5] imm5, 
	output reg [`BITS32] imm32
	);


initial
begin
	$display("intiial ZTYPESEXT");
end

always@(*)
	begin
		imm32 = {27'h00000, imm5};
	end

endmodule // end ZTypeSignExtend