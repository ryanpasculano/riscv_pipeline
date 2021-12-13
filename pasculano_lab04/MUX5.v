`include "riscv.vh"
module MUX5 (
	input wire [`BITS32] in1,
	input wire [`BITS32] in2,
	input wire [`BITS32] in3,
	input wire [`BITS32] in4,
	input wire [`BITS32] in5,
	input wire [`BITS3] sel,
	output reg [`BITS32] out
	);

always@(*)
	case(sel)
		`PS_PCP4	: out = in1;	
		`PS_JALR	: out = in2;	
		`PS_BRCH	: out = in3;	
		`PS_JUMP	: out = in4;	
		`PS_EXCP	: out = in5;	
		`PS_ERR		: out = 32'hxxxxxxxx;
		default		: out = 32'hzzzzzzzz;
	endcase

endmodule