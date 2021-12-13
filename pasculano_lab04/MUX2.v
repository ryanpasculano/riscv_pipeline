`include "riscv.vh"
module MUX2 (
	input wire [`BITS32] in1,
	input wire [`BITS32] in2,
	input wire sel,
	output reg [`BITS32] out
	);



always@(*)
	case(sel)
		`M2_RS1		: out = in1;	
		`M2_UTYPE	: out = in2;	
		`M2_ERR		: out = 32'hxxxxxxxx;
		default: $display("ERROR IN MUX2");//ERROR
	endcase

endmodule