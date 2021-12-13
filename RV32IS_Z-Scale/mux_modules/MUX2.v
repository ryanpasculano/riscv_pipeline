`include "riscv.vh"
module MUX2 (
	input wire [`BITS32] in1,
	input wire [`BITS32] in2,
	input wire sel,
	output reg [`BITS32] out
	);

initial
begin
	$display("initial MUX2");
end

always@(*)
	case(sel)
		`M2_RS1		: out = in1;	
		`M2_UTYPE	: out = in2;	
		`M2_ERR		: out = 32'hxxxxxxxx;
		//default: $display("ERROR IN MUX2 %d, %d, %d, %d",in1, in2, sel, out);//ERROR
	endcase

endmodule