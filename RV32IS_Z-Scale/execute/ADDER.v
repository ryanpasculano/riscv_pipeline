`include "riscv.vh"
module ADDER(
	input wire [`BITS32] op1, 
	input wire [`BITS32] op2, 
	output reg [`BITS32] out
	);
initial
begin
	$display("init ADDER");
end
always@(*)
	begin
		out <= op1 + op2;
	end

endmodule // end ADD4