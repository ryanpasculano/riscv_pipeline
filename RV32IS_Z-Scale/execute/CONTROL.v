`include "riscv.vh"
module CONTROL (
	input wire [`BITS32] pc,
	input wire [`BITS32] pc2,
	input wire [`BITS32] instr,
	input wire [`BITS32] rs1,
	input wire [`BITS32] rs2,
	output reg [`BITS3] pc_sel, 
	output reg [`BITS4] AluFun,
	output reg [`BITS2] Op2Sel,
	output reg Op1Sel,
	output reg [`BITS2] Wb_sel,
	output reg Rf_wen,
	output reg Mem_rw,
	output reg [`BITS2] Mem_val
	);

// Branch Condition Generator Module
wire br_eq;
wire br_lt;
wire br_ltu;
BRANCHCONDGEN branchcondgen(rs1, rs2, br_eq, br_lt, br_ltu);

initial
	begin
		
		$display("init CONTROL");
	end

always@(*)
	case(instr[`op])
			`LOAD   : //0x03
			begin
				pc_sel <= `PS_PCP4; 
				AluFun <= `ALU_ADD; 
				Op2Sel <= 2'b01;
				Op1Sel <= 1'b0;
				Wb_sel <= 2'b11;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'b0;
				Mem_val<= 2'b11; // Mem_val b = 00 h = 01 w = 11
			end
			`FENCE  : //0x0f
			begin // ERROR FOR NOW
				$display("FENCE");
			 	pc_sel <= `PS_ERR; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'bx;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			`ITYPE  : //0x13
			begin
				pc_sel <= `PS_PCP4; 
				case(instr[`func3])
						`R3_ADD  :	AluFun <= `ALU_ADD;
						`R3_SLL  : 	AluFun <= `ALU_SLL;
						`R3_SLT  : 	AluFun <= `ALU_SLT;
						`R3_XOR  : 	AluFun <= `ALU_XOR;
						`R3_SRL  : 	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_SRL;
								end
							else 
								begin
									AluFun <= `ALU_SRA;
								end
						end
						`R3_OR   : 	AluFun <= `ALU_OR;
						`R3_AND  : 	AluFun <= `ALU_AND;
						default: AluFun <= 4'bxxxx;
				endcase
				Op2Sel <= 2'b01;
				Op1Sel <= 1'b0;
				Wb_sel <= 2'b10;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;

				$display("Op2Sel: %x", Op2Sel);
			end
			`AUIPC  : //0x17
			begin // ERROR FOR NOW
				$display("AUIPC");
			 	pc_sel <= `PS_ERR; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'bx;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			`IWTYPE : //0x1b
			begin //ERROR FOR NOW
				$display("IWTYPE");
			 	pc_sel <= `PS_ERR; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'bx;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			`STORE  : //0x23
			begin
				//$display("STORE");
			 	pc_sel <= `PS_PCP4; 
				AluFun <= `ALU_ADD; 
				Op2Sel <= 2'b10;
				Op1Sel <= 1'b0;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'b0;
				Mem_rw <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_val<= 1'b1;
			 end  	
			`RTYPE  : //0x33
			begin
				pc_sel <= `PS_PCP4; 
			 	case(instr[`func3])
						`R3_ADD  :	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_ADD;
								end
							else if (instr[`func7] == 7'b0000001) 
								begin
									AluFun <= `ALU_MUL;	
								end
							else 
								begin
									AluFun <= `ALU_SUB;
								end
							
						end
						`R3_SLL  : 	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_SLL;	
								end
							else 
								begin
									AluFun <= `ALU_MULH;
								end
							
						end
						`R3_SLT  : 	AluFun <= `ALU_SLT;
						`R3_XOR  : 	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_XOR;
								end
							else
								begin 
									AluFun <= `ALU_DIV;
								end
						end
						`R3_SRL  : 	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_SRL;	
								end
							else 
								begin
									AluFun <= `ALU_SRA;	
								end	
						end
						`R3_OR   : 	
						begin
							if (instr[`func7] == 7'b0000000)
								begin
									AluFun <= `ALU_OR;
								end
							else 
								begin
									AluFun <= `ALU_REM;
								end
						end	
						`R3_AND  : 	AluFun <= `ALU_AND; // done
						default: AluFun <= `ALU_ERR;
				endcase
				Op2Sel <= 2'b11; 
				Op1Sel <= 1'b0;
				Wb_sel <= 2'b10;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;

			 end 
			`LUI    : //0x37
			begin
				pc_sel <= `PS_PCP4; 
				AluFun <= `ALU_CAT; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'b1;
				Wb_sel <= 2'b10;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end  	
			`RWTYPE : //0x3b
			begin // ERROR FOR NOW
				//$display("RWTYPE");
			 	pc_sel <= `PS_ERR; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'bx;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			`BRANCH : //0x63
			begin
				//$display("BRANCH");
				//$display("SHOULD BRANCH: %d %d", br_eq, instr[`func3]);
			
				if ((br_eq == 1'b1 && instr[`func3] == 3'b000) || (br_eq == 1'b0 && instr[`func3] == 3'b001) || (br_lt == 1'b1 && instr[`func3] == 3'b100) || (br_eq == 1'b0 && instr[`func3] == 3'b101) || (br_ltu == 1'b1 && instr[`func3] == 3'b110) || (br_eq == 1'b0 && instr[`func3] == 3'b111))
					pc_sel <= `PS_BRCH;			
				else 
				begin
					pc_sel <= `PS_PCP4;
				end
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'b0;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'b0;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end  	
			`JALR   : //0x67
			begin // ERROR FOR NOW
				//$display("JALR");
			 	pc_sel <= `PS_JALR; 
				AluFun <= `ALU_ADD; 
				Op2Sel <= 2'b01;
				Op1Sel <= 1'b0;
				Wb_sel <= 2'b01;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			`JAL    : //0x6f
			begin
				pc_sel <= `PS_JUMP; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'b01;
				Rf_wen <= 1'b1 && (pc2 + 3'b100 == pc);
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end  	
			`SYSTEM : //0x73
			begin
				pc_sel <= `PS_PCP4; 
				AluFun <= `ALU_NOP; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'b0;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end 
			default: //ERROR
			begin
				//$display("ERROR: Invalid opcode: 0x%08h", instr);
			 	pc_sel <= `PS_ERR; 
				AluFun <= `ALU_ERR; 
				Op2Sel <= 2'bxx;
				Op1Sel <= 1'bx;
				Wb_sel <= 2'bxx;
				Rf_wen <= 1'bx;
				Mem_rw <= 1'bx;
				Mem_val<= 1'bx;
			 end  	
			endcase

endmodule // end CONTROL