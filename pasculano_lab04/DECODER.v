`include "riscv.vh"
module DECODER(input wire [`WIDTH - 1:0] instr_bin, output reg [255:0] instr_str);


reg [63:0] funcName;
wire [63:0] rd_out;
wire [63:0] rs1_out;
wire [63:0] rs2_out;
//reg [63:0] rd = rd_out;
//reg [63:0] rs = rs_out;

DECODER_REG decoder_rd(instr_bin[11:7], rd_out);
DECODER_REG decoder_rs1(instr_bin[19:15], rs1_out);
DECODER_REG decoder_rs(instr_bin[24:20], rs2_out);

integer signed imm12;
integer signed imm20;
integer signed immSB;
reg signed [19:0] immUJ;
//integer imm20;
//always@(*)


always@(*)
	begin
	imm12 = instr_bin[`imm12];
	imm20 = instr_bin[`imm20];
	immSB = {instr_bin[31], instr_bin[7], instr_bin[30:25], instr_bin[11:8], 1'b0};
	immUJ = {instr_bin[31], instr_bin[19:12], instr_bin[20], instr_bin[30:21]};

		case(instr_bin[`op])
			`LOAD   :  // load look at funct3
			begin
				if(instr_bin[`func3] == 3'b000)
				begin
					funcName = "lb      ";			// lb
				end
				else if (instr_bin[`func3] == 3'b001)
				begin
					funcName = "lh      ";			// lh
				end
				else if (instr_bin[`func3] == 3'b010)
				begin
					funcName = "lw      ";			// lw
				end
				else 
				begin
					funcName = "error   ";	
				end
				$sformat(instr_str, "%-8s%-8s%d(%-8s)", funcName, rd_out, $signed(instr_bin[`imm12]), rs1_out);
			
				//$sformat(instr_str, "%d", imm12);
				//instr_str = {funcName, rd_out, imm12, "(", rs1_out, ")  "};
				
			end
			`FENCE  : $display("Invalid Opcode"); // fence look at funct3
			`ITYPE  : 
			begin
				case(instr_bin[`func3])
					`R3_ADD  : 
					begin
					if ((instr_bin[`func3] == `R3_ADD) && (instr_bin[`rs1] == 5'b00000))
						begin
							funcName = "li      ";
						end	
					else 
						begin
							funcName = "addi    "; // addi	
						end
					end
					`R3_SLL  : funcName = "slli    "; // slli
					`R3_SLT  : funcName = "slti    "; // slti
					`R3_SLTU : funcName = "sltiu   "; // sltiu
				    `R3_XOR  : funcName = "xori    "; // xori
					`R3_SRL  : 
					begin
						if (instr_bin[`func7] == 7'b0000000)
							begin
								funcName = "srli    ";      // srli
							end
						else
							begin
								funcName = "srai    ";      // srai
							end
					end
					`R3_OR   : funcName = "ori     "; // ori
					`R3_AND  : funcName = "andi    "; // andi
					default: $display("Invalid Opcode");
				endcase
				if (funcName == 	"li      ")
					$sformat(instr_str, "%-8s%-8s%-8d        ", funcName, rd_out, $signed(instr_bin[`imm12]));
				else 
					$sformat(instr_str, "%-8s%-8s%-8s%-8d", funcName, rd_out, rs1_out, $signed(instr_bin[`imm12]));
			
				//instr_str[`CHAR08_15] = rd_out;
				//instr_str[`CHAR16_23] = rs1_out;
				//instr_str[`CHAR24_31] = imm12;
			end
			`AUIPC  : $display("Invalid Opcode"); // auipc
			`IWTYPE : $display("Invalid Opcode"); // WIDE but shifting look at funct3 and 7
			`STORE  : // load store at funct3
			begin
				if(instr_bin[`func3] == 3'b000)
				begin
					funcName = "sb      ";			// sb
				end
				else if (instr_bin[`func3] == 3'b001)
				begin
					funcName = "sh      ";			// sh
				end
				else if (instr_bin[`func3] == 3'b010)
				begin
					funcName = "sw      ";			// sw
				end
				else 
				begin
					funcName = "error   ";	
				end
				$sformat(instr_str, "%-8s%-8s%d(%-8s)", funcName, rs2_out, $signed({instr_bin[31:25], instr_bin[11:7]}), rs1_out);
			
				//$sformat(instr_str, "%d", imm12);
				//instr_str = {funcName, rd_out, imm12, "(", rs1_out, ")  "};
				
			end
			`RTYPE  : 
			begin
				case(instr_bin[`func3])
					`R3_ADD  : 
					begin
						if (instr_bin[`func7] == 7'b0000000)
							begin
								instr_str[`CHAR00_07] = "add     ";     // add
							end
						else if (instr_bin[`func7] == 7'b0000001)
							begin
								instr_str[`CHAR00_07] = "mul     ";  	// mul
							end
						else
							begin
								instr_str[`CHAR00_07] = "sub     ";     // sub
							end
					end
					`R3_SLL  :  // sll
					begin
						if (instr_bin[`func7] == 7'b0000000)
							begin
								instr_str[`CHAR00_07] = "sll    ";     // sll
							end
						else
							begin
								instr_str[`CHAR00_07] = "mulh    ";     // mulh
							end
					end
					`R3_SLT  : instr_str[`CHAR00_07] = "slt     "; // slt
					`R3_SLTU : instr_str[`CHAR00_07] = "sltu    "; // sltu
					`R3_XOR  : // xor
					begin
						if (instr_bin[`func7] == 7'b0000000)
							begin
								instr_str[`CHAR00_07] = "xor     ";     // xor
							end
						else
							begin
								instr_str[`CHAR00_07] = "div     ";     // div
							end
					end
					`R3_SRL  : 
					begin
						if (instr_bin[`func7] == 7'b0)
							begin
								instr_str[`CHAR00_07] = "srl     ";     // srl
							end
						else
							begin
								instr_str[`CHAR00_07] = "sra     ";     // sra
							end
					end
					`R3_OR   :  // or
					begin
						if (instr_bin[`func7] == 7'b0)
							begin
								instr_str[`CHAR00_07] = "or      ";     // or
							end
						else
							begin
								instr_str[`CHAR00_07] = "rem     ";     // rem
							end
					end
					`R3_AND  : instr_str[`CHAR00_07] = "and     "; // and
					default: $display("Invalid Opcode");
				endcase
				instr_str[`CHAR08_15] = rd_out;
				instr_str[`CHAR16_23] = rs1_out;
				instr_str[`CHAR24_31] = rs2_out;
			end
			`LUI :  // lui good to go
			begin
				funcName = "lui     ";
				$sformat(instr_str, "%-8s%-8s%-8d", funcName, rd_out, imm20);
				
			end
			`RWTYPE : $display("Invalid Opcode"); // wide rtype ignore for now
			`BRANCH : 
			begin
				case(instr_bin[`func3])
					3'b000: funcName = "beq     "; // beq
					3'b001: funcName = "bne     "; // beq
					3'b100: funcName = "blt     "; // beq
					3'b101: funcName = "bge     "; // beq
					3'b110: funcName = "bltu    "; // beq
					3'b111: funcName = "bgeu    "; // beq
				endcase
				//instr_str = {funcName, rd_out, rs1_out, immSB};
				$sformat(instr_str, "%-8s%-8s%-8s%-8d", funcName, rd_out, rs1_out, immSB);
			
			end
			`JALR   : $display("Invalid Opcode"); // jalr done
			`JAL    : 
			begin
				if (instr_bin[11:7] == 5'b00000)
				begin
					funcName = "j       "; // j
					$sformat(instr_str, "%-8s%-8d", funcName, immUJ);
				end
				else 
				begin
					funcName = "jal     "; // jal
					$sformat(instr_str, "%-8s%-8s%-8d", funcName, rd_out, immUJ);
				end
				
				
			
				//instr_str = {funcName, rd_out, immUJ};
			end
			`SYSTEM : 
			begin
				case(instr_bin[14:12])
					3'b000: 
					begin
						if (instr_bin[31:20] == 12'b0)
							begin
								instr_str[255:0] = "ecall                           ";     // ecall
							end
						else
							begin
								instr_str[255:0] = "ebreak                          ";     // ebreak
							end
					end
					3'b001: instr_str[255:0] = "CSRRW                           "; // CSRRW
					3'b010: instr_str[255:0] = "CSRRS                           "; // CSRRS
					3'b011: instr_str[255:0] = "CSRRC                           "; // CSRRC
					3'b101: instr_str[255:0] = "CSRRWI                          "; // CSRRWI
					3'b110: instr_str[255:0] = "CSRRSI                          "; // CSRRSI
					3'b111: instr_str[255:0] = "CSRRCI                          "; // CSRRCI
					default: $display("Invalid Opcode");
				endcase
				//instr_str[191:128] = rd_out;
				//instr_str[127:64] = rs1_out;
				//imm <= instr_bin[31:20];
				//instr_str[63:0] = sprintf("%d", instr_bin[31:20]);
			end
			default: 
				begin
					instr_str[255:0] = "nop                             ";
				end
		endcase
	end


function [31:0] rname(input[`REGADDR] r);
	reg [31:0] name;
	begin
		case(r)
			0: name = "zero";
			1: name = "ra";
			2: name = "sp";
			3: name = "gp";
			4: name = "tp";
			5, 6, 7: $sformat(name, "t%1d", r-5);
			8, 9: $sformat(name, "s%1d", r-8);
			10, 11, 12, 13, 14, 15, 16, 17: $sformat(name, "a%1d", r-10);
			18, 19, 20, 21, 22, 23, 24, 25: $sformat(name, "s%1d", r-16);
			26: name = "s10";
			27: name = "s11";
			28, 29, 30, 31: $sformat(name, "t%1d", r-25);
			default: name = "xxxx";
		endcase
		$sformat(rname, "%4s", name);
		rname = name;
	end
endfunction // end rname
endmodule // end DECODER

