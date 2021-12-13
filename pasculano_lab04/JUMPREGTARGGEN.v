`include "riscv.vh"
module JUMPREGTRAGGEN (
	input wire [`BITS32] rs1,
	input wire [`BITS32] itype,
	output reg [`BITS32] jalr
	);

always@(*)
	begin
		jalr = rs1 + (itype << 1);
	end

endmodule // end JUMPREGTARGGEN
