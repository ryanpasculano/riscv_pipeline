`include "riscv.vh"
module ADD4(
	input wire [`BITS32] in_addr, 
	output reg [`BITS32] out_addr
	);

always@(*)
	begin
		out_addr <= in_addr + `PLUS4;
	end

endmodule // end ADD4