/*
This module is the add4 module for the Verilog implementation
of the single-cycle RISCV processor. It adds four to the memory
address passed in.

CSCI320 Lab04
Michael Matirko

*/ 


module ADD4 (input wire [31:0] addrin, output wire [31:0] addrout);

	assign addrout = addrin + 4;  


endmodule 
