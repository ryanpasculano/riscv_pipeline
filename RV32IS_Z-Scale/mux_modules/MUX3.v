`include "riscv.vh"
module MUX3 (
	input wire [`BITS32] in1,
	input wire [`BITS32] in2,
	input wire [`BITS32] in3,
	input wire [`BITS2] sel,
	output reg [`BITS32] out
	);
initial
begin
	$display("initial MUX3");
end
always@(*)
	case(sel)
		2'b00		: out = in1;	
		2'b01		: out = in2;	
		2'b10		: out = in3;	
		2'b11		: out = 32'hxxxxxxxx;
		2'bxx		: out = in2;			// THIS IS A BAD IDEA
		default		: out = 32'hzzzzzzzz;
	endcase

endmodule