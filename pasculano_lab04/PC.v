`include "riscv.vh"
module PC(
 	input wire [`BITS32] in_addr, 
 	input wire clk, 
 	output reg [`BITS32] pc
 	);

	always@(posedge clk)
		begin
  			pc <= (in_addr === 32'hXXXXXXXX)? `INIT_PC : in_addr;
  		end

 endmodule // end PC