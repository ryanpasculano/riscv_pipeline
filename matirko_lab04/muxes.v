/* 

This module contains the muxes required for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module MUX (input sel, input [`WIDTH-1:0] in0, in1, output reg [`WIDTH-1:0] out); 
	always @(*) begin
			case (sel)
				0: out = in0; 
				1: out = in1; 
			endcase 
		end

endmodule

module MUX4 (input [1:0] sel, input [`WIDTH-1:0] in0, in1, in2, in3, output reg [`WIDTH-1:0] out); 
	always @(*) begin
			case (sel)
				0: out = in0; 
				1: out = in1; 
				2: out = in2; 
				3: out = in3;
				
			endcase 
		end

endmodule

module MUX5 (input [2:0] sel, input [`WIDTH-1:0] in0, in1, in2, in3, in4, output reg [`WIDTH-1:0] out); 
	always @(*) begin
			case (sel)
				0: out = in0; 
				1: out = in1; 
				2: out = in2; 
				3: out = in3;
				4: out = in4; 
				default: out = 1'bx; 
				
			endcase 
		end

endmodule

