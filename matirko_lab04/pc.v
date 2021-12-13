
/*
This module contains the verilog representation of 
the program counter for the single-cycle RISCV datapath
for CSCI320 lab04. 
*/ 

module PC (input clock, input [31:0] next, output reg [31:0] pc);

always @(posedge clock) begin
	if (pc === 32'bx)
		pc <= `START_OF_MEM;          // Set the initial value of the program counter (0x1000)
	else
		pc <= next;                   // Assigns the new PC to output (updates @posedge clock)
end

endmodule

