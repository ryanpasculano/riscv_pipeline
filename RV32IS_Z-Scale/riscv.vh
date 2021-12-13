`ifndef _riscv_vh_
`define _riscv_vh_

/*
 RISCV CPU definitions for lab01
 */

`define WIDTH 32  // bit width of processor
`define CYCLE 5   // simulation time ticks per clock

`define INIT_PC 32'h1000 // initial PC value
`define START_OF_MEM 32'h1000
`define END_OF_MEM 32'h13ff
`define START_OF_REGFILE 0
`define END_OF_REGFILE 31
`define START_OF_MEMFILE 32'h3000
`define END_OF_MEMFILE 32'heffff
`define INSTR_MEM_FILE "mem.in"

// USE THIS TO SWAP PROGRAM FILES
`define PROGRAM_FILE "big_numbers.hex"
//`define PROGRAM_FILE "li.hex"
//`define PROGRAM_FILE "signs.hex"
//`define PROGRAM_FILE "multiply.hex"
//`define PROGRAM_FILE "lab03prog2.hex"


`define REG_FILE "reg.in"

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
`define imm20        31:12  // 12-bit immediate for I type instructions


 /*-----------------------------------------------------------------------*
  * Opcode Assignments for `op Operations                                 *
  *-----------------------------------------------------------------------*/

// this list is not complete.
`define LOAD   7'h03 // all load instructions
`define FENCE  7'h0f // fence and fence.i
`define ITYPE  7'h13 // all I-type arithmetic instructions
`define AUIPC  7'h17 // auipc only
`define IWTYPE 7'h1b // all wide I-type arithmatic
`define STORE  7'h23 // all store instructions
`define RTYPE  7'h33 // all R-type instructions
`define LUI    7'h37 // lui only
`define RWTYPE 7'h3b // all wide R-type instructions
`define BRANCH 7'h63 // all branch instructions
`define JALR   7'h67 // jalr only
`define JAL    7'h6f // jal only
`define SYSTEM 7'h73 // equal to SYSCALL


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


/*-----------------------------------------------------------------------*
 * AluFun Assignments for the AluFun    						                     *
 *-----------------------------------------------------------------------*/
`define ALU_ADD   4'b0000
`define ALU_MUL   4'b0001
`define ALU_SUB   4'b0010
`define ALU_SLL   4'b0011
`define ALU_MULH  4'b0100
`define ALU_SLT   4'b0101
`define ALU_XOR   4'b0110
`define ALU_DIV   4'b0111
`define ALU_SRL   4'b1000
`define ALU_SRA   4'b1001
`define ALU_OR    4'b1010
`define ALU_REM   4'b1011
`define ALU_AND   4'b1100
`define ALU_CAT   4'b1101
`define ALU_NOP		4'b1111
`define ALU_ERR		4'bxxxx


/*-----------------------------------------------------------------------*
 * mux Assignments for the MUX2, MUX4, and MUX5    						                     *
 *-----------------------------------------------------------------------*/
`define PS_PCP4			3'b000
`define PS_JALR			3'b001
`define PS_BRCH			3'b010
`define PS_JUMP			3'b011
`define PS_EXCP			3'b100
`define PS_ERR			3'bxxx
`define M2_RS1			1'b0
`define M2_UTYPE		1'b1
`define M2_ERR			1'bx
`define M4_PC				2'b00
`define M4_ITYPE		2'b01
`define M4_STYPE		2'b10
`define M4_RS2			2'b11
`define M4_CSR			2'b00
`define M4_PCP4			2'b01
`define M4_ALU			2'b10
`define M4_DATA			2'b11
`define M4_ERR			2'bxx


/*-----------------------------------------------------------------------*
 * pc_sel Assignments for the MUX5    						                     *
 *-----------------------------------------------------------------------*/


/*-----------------------------------------------------------------------*
 * string indicides                                                      *
 *-----------------------------------------------------------------------*/
`define CHAR00_07   255:192
`define CHAR08_15   191:128
`define CHAR16_23   127:64
`define CHAR24_31   63:0

/*-----------------------------------------------------------------------*
 * 0 based bit lengths                                                   *
 *-----------------------------------------------------------------------*/
`define BITS64			63:0
`define BITS32			31:0
`define BITS20			19:0
`define BITS12			11:0
`define BITS10			9:0
`define BITS9				8:0
`define BITS8				7:0
`define BITS7				6:0
`define BITS6				5:0
`define BITS5				4:0
`define BITS4				3:0
`define BITS3				2:0
`define BITS2				1:0
`define REGADDR 		4:0		// DEPRECATED BUT AFRAID TO DELETE

/*-----------------------------------------------------------------------*
 * MISC                                                                  *
 *-----------------------------------------------------------------------*/
`define PLUS4		32'h00000004
`define ecall		32'h00000073
`define ecall		32'h00000073
`define TRUE		1'b1
`define FALSE		1'b0

`endif