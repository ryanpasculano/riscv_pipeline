/*

This module represents the controller for the single-cycle RISCV CPU. 
It takes in the full instruction and branch_eq signal, and outputs the following control 
signals:

-> pc_sel
-> AluFun
-> Op2Sel
-> Op1Sel
-> Wb_sel
-> Rf_wen
-> Mem_rw
-> Mem_val

Michael Matirko
CSCI320: Lab04
Bucknell University

*/


module CONTROL(input [`WIDTH-1:0] inst, input br_eq, output reg [2:0] pc_sel, output reg [3:0] AluFun, output reg [1:0] Op2Sel, Wb_sel,
			output reg Op1Sel, Rf_wen, Mem_rw, Mem_val);

reg [6:0] opcode; 
reg [6:0] func7; 
reg [2:0] func3; 
reg [11:0] imm; 

	always @(*) begin
		opcode = inst[`op];
		case (opcode)
			`RTYPE: begin 
				func3 = inst[`func3];
				func7 = inst[`func7];
				pc_sel = 3'b000; 
				Op2Sel = 2'b11; 
				Op1Sel = 1'b0;
				Wb_sel = 2'b10;
				Rf_wen = 1'b1; 
				Mem_rw = 1'b0; 
				Mem_val = 1'bx; 
				case (func3)
					// add, mul, sub
					3'b000: case(func7)
							7'b0: AluFun = 4'b0000; 
							7'b1: AluFun = 4'b0001;
							7'b100000: AluFun = 4'b0010; 
							
						endcase

					// sll, mulh
					3'b001: case(func7)
							7'b0: AluFun = 4'b0011; 
							7'b1: AluFun = 4'b0100; 
						endcase	
					// slt
					3'b010: AluFun = 4'b0101;

					// xor, div
					3'b100: case(func7)
							7'b0: AluFun = 4'b0110; 
							7'b1: AluFun = 4'b0111;	
						endcase

					// srl, sra 
					3'b101: case(func7)
							7'b0: AluFun = 4'b1000; 
							7'b100000: AluFun = 4'b1001;	
						endcase

					// or, rem 
					3'b110: case(func7)
							7'b0: AluFun = 4'b1010; 
							7'b1: AluFun = 4'b1011;	
						endcase

					// and 
					3'b111: AluFun = 1100; 
				endcase 
				end
			///// END OF R TYPES //////

			`ITYPE: begin 
				func3 = inst[`func3];
				imm = inst[`imm12];
				pc_sel = 3'b000; 
				Op2Sel = 2'b01; 
				Op1Sel = 1'b0;
				Wb_sel = 2'b10;
				Rf_wen = 1'b1; 
				Mem_rw = 1'b0; 
				Mem_val = 1'bx; 
				case (func3)
					// addi 
					3'b000: AluFun = 4'b0;

					// slli 
					3'b001: AluFun = 4'b0011; 

					// slti
					3'b010: AluFun = 4'b0101; 

					// xori
					3'b100: AluFun = 4'b0110; 

					// srli, srai
					3'b101: begin
						case(inst[`func7])
							// srli 
							7'b0: AluFun = 4'b1000;

							// srai
							7'b0100000: AluFun = 4'b1001; 
						endcase
						end

					// ori
					3'b110: begin
						AluFun = 4'b1010; 
						end 

					// andi
					3'b111: AluFun = 4'b1100; 
								
				endcase 
				end

			`LOAD: begin 
				func3 = inst[`func3];
				imm = inst[`imm12];
				pc_sel = 3'b000; 
				Op2Sel = 2'b01; 
				Op1Sel = 1'b0;
				Wb_sel = 2'b11;
				Rf_wen = 1'b1; 
				Mem_rw = 1'b0; 
				Mem_val = 1'bx; 
				AluFun = 4'b0000;
				end

			///// END OF I TYPES & LOADS//////

			`UTYPE: begin 
				func3 = inst[`func3];
				imm = inst[`imm12];
				pc_sel = 3'b000; 
				Op2Sel = 2'b01; 
				Op1Sel = 1'b1;
				Wb_sel = 2'b10;
				Rf_wen = 1'b1; 
				Mem_rw = 1'b0; 
				Mem_val = 1'bx; 
				AluFun = 4'b1101; 
				end
			/////       END OF U TYPES       //////

			`SBTYPE: begin 
				func3 = inst[`func3];
				imm = inst[`imm12];
				case (func3)
					// BEQ
					4'b0: if (br_eq)
					      pc_sel = 3'b010;
					      else pc_sel = 3'b000; 
					
					// BNE
					4'b1: if (br_eq == 0)
					      pc_sel = 3'b010;
					      else pc_sel = 3'b000;
				endcase 

				Op2Sel = 2'bxx; 
				Op1Sel = 1'bx;
				Wb_sel = 2'bxx;
				Rf_wen = 1'bx; 
				Mem_rw = 1'bx; 
				Mem_val = 1'bx; 
				AluFun = 4'bxxxx; 
				end
			/////       END OF SB TYPES       //////

			`UJTYPE: begin 
				func3 = inst[`func3];
				imm = inst[`imm12];
				pc_sel = 3'b011; 
				Op2Sel = 2'bxx; 
				Op1Sel = 1'bx;
				Wb_sel = 2'b01;
				Rf_wen = 1'b1; 
				Mem_rw = 1'bx; 
				Mem_val = 1'bx; 
				AluFun = 4'bxxxx; 
				end
			/////       END OF UJ TYPES       //////

			`STYPE: begin 
				pc_sel = 3'b000; 
				Op2Sel = 2'b10; 
				Op1Sel = 1'b0;
				Wb_sel = 2'b10;
				Rf_wen = 1'b1; 
				Mem_rw = 1'b1; 
				Mem_val = 1'bx;
				AluFun = 4'b0000;  
				end
			/////       END OF STYPES       //////

			`ECALL: begin
				pc_sel = 3'b000; 
				Op2Sel = 2'bxx; 
				Op1Sel = 1'bx;
				Wb_sel = 2'bxx;
				Rf_wen = 1'b0; 
				Mem_rw = 1'b0; 
				Mem_val = 1'bx; 
				end 
		endcase
	end

endmodule 


















