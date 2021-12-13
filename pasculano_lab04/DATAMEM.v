`include "riscv.vh"
module DATAMEM (
	input wire [`BITS32] rs2, 
	input wire [`BITS32] alu_out,
	input wire mem_rw,
	input wire [`BITS2] mem_val,
	input wire clk,  
	output reg [`BITS32] out
	);
///////////////////////// internal memory storage //////////////////////////////
reg [`BITS32] mem [`END_OF_MEMFILE >> 2: `START_OF_MEMFILE >> 2];  
// store enough 32-bit words.

//////////////////////////////// initial ///////////////////////////////////////
initial
	begin
		$display($time, ":reading in reg_file memory");
	end

always@(mem_rw, alu_out) //Cant use * because mem is too big
	begin
		if (mem_rw == `FALSE)
			begin
				out = mem[alu_out >> 2];
				//$display("Reading: 0x%08x from address: 0x%08x", out, alu_out >> 2);
			end
	end

// write register to data mem (STORE)
always@(negedge clk)
	begin
		if (mem_rw == `TRUE)
			begin
				mem[alu_out >> 2] <= rs2;  
				//$display("Writing: 0x%08x to address: 0x%08x", rs2, alu_out >> 2);
			end	
	end

endmodule // end DATAMEM