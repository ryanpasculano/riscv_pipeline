`ifndef _riscv_vh_
`define _riscv_vh_

/*
 RISCV CPU definitions for lab02
 */

`define WIDTH 32  // bit width of processor
`define CYCLE 10  // simulation time ticks per clock

`define INIT_PC 32'h1000 // initial PC value

// `define PROGRAM_FILE "Lab04-mult.hex"
// `define PROGRAM_FILE "Lab04-biggernum.hex"
`define PROGRAM_FILE "Lab04-signed.hex"

`define START_OF_MEM 32'h1000
`define END_OF_MEM 32'h13FF 

`define STACK_TOP 32'hEFFFF
`define STACK_BOT 32'h03000

/*-----------------------------------------------------------------------*
 * Instruction Fields                                                    *
 *-----------------------------------------------------------------------*/
`define op           6:0    // 7 bit opcode
`define rd           11:7   // 5-bit destination register specifier
`define rs1          19:15  // 5-bit source register specifier
`define rs2          24:20  // 5-bit source/dest register spec or sub opcode
`define func3        14:12  // 3-bit func3 field
`define func7        31:25  // 7-bit func7 field

`define imm12        31:20  // 12-bit immediate for I type instructions
`define imm20        31:12  // 20-bit immediate for U type instructions

 /*-----------------------------------------------------------------------*
  * Opcode Assignments for `op Operations                                 *
  *-----------------------------------------------------------------------*/

// this list is not complete.
`define RTYPE  7'h33 // all R-type instructions
`define ITYPE  7'h13 // all I-type instructions
`define UTYPE  7'h37 // all U-type instructions 
`define UJTYPE 7'h6F // jal 
`define SBTYPE 7'h63 // branches 
`define STYPE  7'h23 // all S-type instructions 

`define LOAD   7'h03 // all load instructions

`define ADDI   7'h13 // also li when rs2 is x0
`define ECALL  7'h73 // equal to SYSCALL

/*-----------------------------------------------------------------------*
 * Register Names                                                 *
 *-----------------------------------------------------------------------*/
`define REGX0	"zero"
`define REGX1	"ra"
`define REGX2	"sp"
`define REGX3	"gp"
`define REGX4	"tp"
`define REGX5	"t0"
`define REGX6	"t1"
`define REGX7	"t2"
`define REGX8	"s0"
`define REGX9	"s1"
`define REGX10	"a0"
`define REGX11	"a1"
`define REGX12	"a2"
`define REGX13	"a3"
`define REGX14	"a4"
`define REGX15	"a5"
`define REGX16	"a6"
`define REGX17	"a7"
`define REGX18	"s2"
`define REGX19	"s3"
`define REGX20	"s4"
`define REGX21	"s5"
`define REGX22	"s6"
`define REGX23	"s7"
`define REGX24	"s8"
`define REGX25	"s9"
`define REGX26	"s10"
`define REGX27	"s11"
`define REGX28	"t3"
`define REGX29	"t4"
`define REGX30	"t5"
`define REGX31	"t6"

`define ECALL_REG 10 

`define STACK_POINTER 2 

/*-----------------------------------------------------------------------*
 * func3 Assignments for `func3 Operations for RTYPE                     *
 *-----------------------------------------------------------------------*/
`define R3_ADD   3'b000
`define R3_SLL   3'b001
`define R3_SLT   3'b010
`define R3_SLTU  3'b011
`define R3_XOR   3'b100
`define R3_SRL   3'b101
`define R3_OR    3'b110
`define R3_AND   3'b111

`endif
