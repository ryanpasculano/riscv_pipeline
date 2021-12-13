`include "riscv.vh"
module testbench;

// create wires left side
wire [`WIDTH - 1:0] pc_plus_4;
wire [`WIDTH - 1:0] pc;
wire [`WIDTH - 1:0] next_addr;
wire [`WIDTH - 1:0] junk;
wire [`WIDTH - 1:0] instruction;
wire [`WIDTH - 1:0] jalr;
wire [`WIDTH - 1:0] branch; // come fromBranchTargGen
wire [`WIDTH - 1:0] jump; // comes from JumpTargGen
wire [`WIDTH - 1:0] exception; // comes from magic


// create wires right sides
wire [`WIDTH - 1:0] write_data;
wire [`WIDTH - 1:0] itype32;
wire [`WIDTH - 1:0] utype32;
wire [`WIDTH - 1:0] stype32;
wire [`WIDTH - 1:0] rs1;
wire [`WIDTH - 1:0] rs2;
wire [`WIDTH - 1:0] alu_in2;
wire [`WIDTH - 1:0] alu_in1;
wire [`WIDTH - 1:0] alu_out;
wire [`WIDTH - 1:0] data_mem_out;


// create control wires
wire [`WIDTH - 1:0] instr;
wire [2:0] pc_sel; 
wire [3:0] AluFun;
wire [1:0] Op2Sel;
wire Op1Sel;
wire [1:0] Wb_sel;
wire Rf_wen;
wire Mem_rw;
wire [1:0] Mem_val;

// create clock
reg clk = 0;
always #`CYCLE clk = !clk;
// Auxillary wires
wire [255:0] instr_str;

// create modules left side
ADD4 add4(pc, pc_plus_4);
PC pc_module(next_addr, clk, pc); //ATTENTION THIS   \/ SHOULD BE pc_sel
MUX5 mux5_pc_sel(pc_plus_4, jalr, branch, jump, exception, pc_sel, next_addr);
INSTR_MEM instr_mem(pc, instruction);

// create modules right side
REG_FILE reg_file(instruction[19:15], instruction[24:20], instruction[11:7], write_data, Rf_wen, clk, rs1, rs2);
CONTROL control(instruction, rs1, rs2, pc_sel, AluFun, Op2Sel, Op1Sel, Wb_sel, Rf_wen, Mem_rw, Mem_val);
MUX4 mux4_op2(pc, itype32, stype32, rs2, Op2Sel, alu_in2);
MUX2 mux2_op1(rs1, utype32, Op1Sel, alu_in1);
ALU alu(alu_in1, alu_in2, AluFun, alu_out);
MUX4 mux4_wb_sel(junk, pc_plus_4, alu_out, data_mem_out, Wb_sel, write_data);
DATAMEM datamem(rs2, alu_out, Mem_rw, Mem_val, clk, data_mem_out);

//sign extend modules
ITYPESIGNEXTEND itypesignextend(instruction[31:20], itype32);
UTYPE utype(instruction[31:12], utype32);
STYPESIGNEXTEND stypesignextend(instruction[31:25], instruction[11:7], stype32); 

// Branching
JUMPREGTRAGGEN jumpregtraggen(rs1, itype32, jalr);
BRANCHTARGGEN branchtarggen(pc, instruction[31], instruction[30:25], instruction[11:8], instruction[7], branch);
JUMPTARGGEN jumptarggen(pc, instruction[31], instruction[30:21], instruction[20], instruction[19:12], jump);

// Auxillary modues
DECODER decoder(instruction, instr_str);



initial
  begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
    $display($time, ":boot.");
    $display("Running program: %s", `PROGRAM_FILE);
    reg_file.print_reg();
    #100000; 

    $display("Running program: %s", `PROGRAM_FILE);
    $display($time, ":program terminated after 100000 time units");
    $finish;
  end

always@(posedge clk)
  begin
    $display($time, "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    $display($time, " PC: 0x%08x, IR: 0x%08x, Instruction:%s", pc, instruction, instr_str);
    if(instruction[`op] == `ecall)
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
