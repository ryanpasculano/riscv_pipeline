/* 

This module contains the ALU required for the CSCI320 
single-cycle RISCV CPU project. It takes two 32-bit inputs, and a 
4-bit ALUFun that specifies the the operation of the ALU, and
returns a 32-bit result.

Michael Matirko
CSCI320
Bucknell University

*/ 

module ALU (input [3:0] AluFun, input [`WIDTH - 1:0] op2, input [`WIDTH - 1:0] op1, output reg signed [`WIDTH - 1:0] out); 
	reg signed [63:0] temp; 

	always @(*) begin
			case (AluFun)
				4'b0000: out = $signed(op1) + $signed(op2);  
				4'b0001: out = $signed(op1) * $signed(op2); 
				4'b0010: out = $signed(op1) - $signed(op2);
				4'b0011: out = op1 << op2;  
				4'b0100: begin
						temp = $signed(op1) * $signed(op2);
						out = temp[63:32];
					 end	
				4'b0101: out = ($signed(op1) < $signed(op2)) ? 1 : 0; 
				4'b0110: out = op1 ^ op2; 
				4'b0111: out = $signed(op1) / $signed(op2); 
				4'b1000: out = op1 >> op2; 
				4'b1001: out = op1 >>> op2; 
				4'b1010: out = op1 | op2; 
				4'b1011: out = op1 % op2; 
				4'b1100: out = op1 & op2; 

				// LUI
				4'b1101: out = op1; 

			endcase 
		end

endmodule
