// INSTRMEM module
// CSCI320 
// Project 2
// Three-stage piplined RISCV CPU (RV32IS Z-Scale)
//
// Michael Matirko
// Ryan Pasculano 


`include "riscv.vh"
module INSTRMEM (
	input wire [`BITS32] addr, 
	output reg [`BITS32] instr
	);

///////////////////////// internal memory storage //////////////////////////////
reg [`BITS32] mem [`END_OF_MEM >> 2:`START_OF_MEM >> 2];  // store 256 32-bit words.


//////////////////////////////// initial ///////////////////////////////////////
initial
	begin
		$display($time, ":reading in memory");
		$readmemh(`PROGRAM_FILE, mem, `START_OF_MEM >> 2, `END_OF_MEM >> 2);
		//$display("mem is: %x", mem[`START_OF_MEM >> 2]);
	end

always@(*)
	begin
	  instr <= mem[addr >> 2];
	  //instr <= (addr === 32'hXXXXXXXX)? 32'h00000000 : mem[addr >> 2];
	end

endmodule // end INSTR_MEM
