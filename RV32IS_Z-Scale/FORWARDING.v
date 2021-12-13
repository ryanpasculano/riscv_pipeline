

`include "riscv.vh"
module FORWARDING (
    input wire [`BITS32] alu_out, 
    input wire [`BITS32] m4_out, 
    input wire rf_wen, 
    input wire mem_rw, 
    input wire [`BITS2] mem_val, 
    input wire [`BITS32] pc, 
    input wire [`BITS32] instruction, 
    input wire [`BITS2] wb_Sel,
    input wire clk, 
    input wire BE_rdy,
    output reg [`BITS32] alu_out2, 
    output reg [`BITS32] wdata, 
    output reg [`BITS5] wb_addr, 
    output reg rf_wen2, 
    output reg mem_rw2, 
    output reg [`BITS2] mem_val2, 
    output reg [`BITS32] pc2, 
    output reg [`BITS32] instruction2,
    output reg [`BITS2] wb_Sel2,
    output reg BE_rdy2
    );

always@(posedge clk)
begin
    alu_out2 = alu_out;
    wdata = m4_out;
    wb_addr = instruction2[11:7];
    rf_wen2 = rf_wen;
    mem_rw2 = mem_rw;
    mem_val2 = mem_val;
    wb_Sel2 = wb_Sel;
    BE_rdy2 = BE_rdy;


    //if((BE_rdy == 1'b1)) // this is weird
    //    begin
            pc2 = pc;
            instruction2 = instruction;
    //    end



end   
endmodule