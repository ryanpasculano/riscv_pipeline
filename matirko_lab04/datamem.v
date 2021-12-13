/* 

This module contains the datamem module required for the CSCI320 
single-cycle RISCV CPU project.

Michael Matirko
CSCI320
Bucknell University

*/ 

module DATAMEM (input clock, input [31:0] wdata, addr, input mem_rw, mem_val, output reg [31:0] rdata); 

	// Create the memory
	reg [31:0] datamem [`STACK_TOP:`STACK_BOT];

	always @(addr, mem_rw) begin
			if (mem_rw == 0) begin
			$display($time, ": *** DMEM READ 0x%8h at mem address datamem[0x%0h] ", rdata, addr);
			rdata = datamem[addr >> 2];
			end 
	end 

	always @(negedge clock) begin
		if (mem_rw) begin
			$display($time, ": *** DMEM WRITE 0x%8h to mem address datamem[0x%0h] ", wdata, addr);
			datamem[addr >> 2] = wdata;
			 
			end 

	end 

endmodule
