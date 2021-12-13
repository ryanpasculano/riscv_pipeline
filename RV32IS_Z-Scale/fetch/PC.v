// PC module
// CSCI320 
// Project 2
// Three-stage piplined RISCV CPU (RV32IS Z-Scale)
//
// Michael Matirko
// Ryan Pasculano 

`include "riscv.vh"
module PC(
 	input wire [`BITS32] in_addr, 
 	input wire clk, 
 	output reg [`BITS32] pc
 	);

initial begin
	$display("in pc, clk is: %b", clk);
	$display("in pc, in_addr is: %x", in_addr);

end
	always@(posedge clk)
		begin
  			pc <= (in_addr === 32'hXXXXXXXX || in_addr === 32'hzzzzzzzz )? `INIT_PC : in_addr;
  		end

 endmodule // end PC
