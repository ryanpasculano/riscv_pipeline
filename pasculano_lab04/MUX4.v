`include "riscv.vh"
module MUX4 (
	input wire [`BITS32] in1,
	input wire [`BITS32] in2,
	input wire [`BITS32] in3,
	input wire [`BITS32] in4,
	input wire [`BITS2] sel,
	output reg [`BITS32] out
	);


always@(*)
	case(sel)
			2'b00	: out = in1;	
			2'b01	: out = in2;	
			2'b10	: out = in3;	
			2'b11	: out = in4;	
			2'bxx	: out = 32'hxxxxxxxx;
			default : $display("ERROR IN MUX4");//ERROR
	endcase

endmodule