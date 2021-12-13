/*
  module memory

  Implements a 32-bit big-endian memory block. The address is initialised at 0
  and for each positive clock edge, the current address is incremented. The
  addressed memory word is output on "out". Data is read from the file
  'mem.in'.

  This file was used from lab 00 in order to implement the memory
  block on lab04. 
*/

`include "riscv.vh"

module MEM(input wire [31:0] address, output wire [31:0] out);

reg [31:0] mem [`START_OF_MEM >> 2:`END_OF_MEM >> 2];       // store 256 32-bit words.

initial begin
	$readmemh(`PROGRAM_FILE, mem, `START_OF_MEM >> 2, `END_OF_MEM >> 2);
	//out = mem[address >> 2];			            // Assign the memory output
end

	assign out = mem[address >> 2];			            // Assign the memory output

endmodule

