`include "riscv.vh"
`timescale 1ns / 1ps
module testbench;
///////////////////////// CLOCK GENERATOR //////////////////////////////
reg clk = 0;  


// LOOK at harrison harris book
// mips implementation
// page



always
begin   
    #`CYCLE; 
    clk = ~clk;
end

wire [`BITS32] pc;
wire [`BITS32] pc2;
wire [`BITS32] rs1;
wire [`BITS32] rs2;
wire [`BITS32] pc_plus_4;
wire [`BITS32] addr;
wire [`BITS32] instruction;
wire [`BITS32] instruction2;
wire [`BITS32] br_or_jump;
wire [`BITS32] jalr;
wire [`BITS32] junk;
wire [`BITS32] jsext_out;
wire [`BITS32] bsext_out;
wire [`BITS32] isext_out;
wire [`BITS32] zsext_out;
wire [`BITS32] ssext_out;
wire [`BITS32] utype_out;
wire [`BITS32] alu_out;
wire [`BITS32] alu_out2;
wire [`BITS32] wdata;
wire [`BITS32] mem_out;
wire [`BITS32] instr_mem;
wire [`BITS32] adder_in;
wire [`BITS5] wb_addr;
wire [`BITS2] wb_Sel; 
wire rf_wen;
wire rf_wen2;
wire [`BITS2] mem_val;
wire [`BITS2] mem_val2;
wire mem_rw;
wire mem_rw2;
wire BE_rdy;
wire BE_rdy2;
wire [`BITS3] pc_sel;
wire [`BITS2] m1;
wire [`BITS32] m1_out;
wire [`BITS2] m2;
wire [`BITS32] m2_out;
wire m3;
wire [`BITS32] m3_out;
wire m4;
wire [`BITS32] m4_out;
wire  m5;
wire [`BITS32] m5_out;
wire [`BITS2] m6;
wire [`BITS32] m6_out;
wire [`BITS2] m7;
wire [`BITS32] m7_out;
wire [`BITS2] m8;
wire [`BITS32] m8_out;
wire [`BITS4] AluFun;



wire [255:0] instr_str;

// create modules left side
ADD4 add4(pc, pc_plus_4);
PC pc_module(m2_out, clk, pc);
INSTRMEM instrmem(pc, instruction);

JTYPESEXT jtypesext(instruction2[31], instruction2[30:21], instruction2[20], instruction2[19:12], jsext_out);
BTYPESEXT btypesext(instruction2[31], instruction2[30:25], instruction2[11:8], instruction2[7], bsext_out);
ADDER adder(pc2, m3_out, br_or_jump);
STYPESEXT stypesext(instruction2[31:25], instruction2[11:7], ssext_out);
UTYPE utype(instruction2[31:12], utype_out);
ITYPESEXT itypesext(instruction2[31:20], isext_out);
ZTYPESEXT ztypesext(instruction2[19:15], zsext_out);

REG_FILE reg_file(instruction2[19:15], instruction2[24:20], wb_addr, m8_out, rf_wen2, clk, rs1, rs2);

CONTROL control(pc, pc2, instruction2, m5_out, m4_out, pc_sel, AluFun, m7, Op1Sel, wb_Sel, rf_wen, mem_rw, mem_val);

MUX3 mux1 (br_or_jump, jalr, junk, m1, m1_out);
MUX3 mux2 (pc, pc_plus_4, m1_out, m2, m2_out);
MUX2 mux3 (jsext_out, bsext_out, m3, m3_out);
MUX2 mux4 (alu_out2, rs2, m4, m4_out);
MUX2 mux5 (alu_out2, rs1, m5, m5_out);
MUX3 mux6 (utype_out, m5_out, zsext_out, m6, m6_out);
MUX4 mux7 (pc2, isext_out, ssext_out, m4_out, m7, m7_out);
MUX4 mux8 (junk, pc2, alu_out2, mem_out, m8, m8_out);

ALU alu(m6_out, m7_out, AluFun, alu_out);
DATAMEM datamem (wdata, alu_out2, mem_rw2, mem_val2, clk, mem_out);

MUXMASTER muxmaster(instruction, instruction2, m5_out, m4_out, wb_addr, pc_sel, BE_rdy2, m1, m2, m3, m4, m5, m6, BE_rdy);
FORWARDING forwarding(alu_out, m4_out, rf_wen, mem_rw, mem_val, pc, instruction, wb_Sel, clk, BE_rdy, alu_out2, wdata, wb_addr, rf_wen2, mem_rw2, mem_val2, pc2, instruction2, m8, BE_rdy2);

 

// Auxillary modues
DECODER decoder(instruction2, instr_str);


initial
  begin
    clk = 1'b0; 
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
    $display($time, ":boot.\n");
    $display("Running program: %s", `PROGRAM_FILE);
    reg_file.print_reg();
    #20000; 

    $display("Running program: %s", `PROGRAM_FILE);
    $display($time, ":program terminated after 100 time units");
    $finish;
  end

always@(posedge clk)
  begin

    $display($time, "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    $display($time, " PC: 0x%08x, IR: 0x%08x, Instruction: %s", pc2, instruction2, instr_str);
    if(instruction2[`op] == `ecall)
    begin
      reg_file.ecall();
    end 
  end


always@(negedge clk)
  begin
    $display($time, "--------------------------------------------------------------------");
   reg_file.print_reg();
   
  
  end

endmodule // end testbench
