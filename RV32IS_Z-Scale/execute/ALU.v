`include "riscv.vh"
module ALU (
	input wire [`BITS32] op1,
	input wire [`BITS32] op2,
	input wire [`BITS4] AluFun,
	output reg [`BITS32] out
	);

wire [`BITS64] tempMult = op1 * op2;

initial
begin
	$display("init ALU");
end
always@(*)
	begin
	case(AluFun)
			`ALU_ADD	: out = op1 + op2;			//4'b0000
			`ALU_MUL	: out = tempMult[31:0];		//4'b0001
			`ALU_SUB	: out = op1 - op2;			//4'b0010
			`ALU_SLL	: out = op1 << op2;			//4'b0011
			`ALU_MULH	: out = tempMult[63:32];	//4'b0100 
			`ALU_SLT	: out = (op1 - op2) >> 31;	//4'b0101
			`ALU_XOR	: out = op1 ^ op2;			//4'b0110
			`ALU_DIV	: out = op1 / op2;			//4'b0111
			`ALU_SRL	: out = op1 >> op2;			//4'b1000
			`ALU_SRA	: out = {op1[31] * op2, (op1 >> op2)};
			// Caution: Untested Garbage			//4'b1001
			`ALU_OR		: out = op1 | op2;			//4'b1010
			`ALU_REM	: out = op1 % op2;			//4'b1011
			`ALU_AND	: out = op1 & op2;			//4'b1100
			`ALU_CAT	: out = op1; 				//4'b1101 Handled in sign extend
			`ALU_NOP	: out = 32'hxxxxxxxx;		//4'b1111
		endcase
	end

endmodule // end ALU
