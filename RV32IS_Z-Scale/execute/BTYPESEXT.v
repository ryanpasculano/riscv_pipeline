`include "riscv.vh"
module BTYPESEXT (
	input wire imm12,
	input wire [`BITS6] imm10_5,
	input wire [`BITS4] imm4_1,
	input wire imm11,
	output reg [`BITS32] branch
	);

initial
begin
	$display("init BTYPESEXT");
end
always@(*)
	begin
		if (imm12 == 1'b1)
		begin
			branch = {20'hfffff, imm12, imm11, imm10_5, imm4_1} << 1;	
		end
		else 
		begin
			branch = {20'h00000, imm12, imm11, imm10_5, imm4_1} << 1;
		end
	end
	
endmodule // end BRANCHTARGGEN
