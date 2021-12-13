/*
This module is the decoder module for lab01. It decodes a RISCV 
instruction into a human readable format. 

Michael Matirko
CSCI320 Lab04

*/ 


module DECODER(input wire [31:0] decodein, output reg [255:0] decodeout);
reg [255:0] decode; 


// Register ids
reg [4:0] rs1_enc;
reg [4:0] rs2_enc;
reg [4:0] rd_enc; 
reg signed [19:0] imm19_enc; 
reg signed [11:0] imm12_enc; 

// Decoded register names
wire [255:0] rs1; 
wire [255:0] rs2; 
wire [255:0] rd; 

REGHELPER rs1_helper(rs1_enc, rs1);
REGHELPER rs2_helper(rs2_enc, rs2);
REGHELPER rd_helper(rd_enc, rd);

always @(*) begin
	// Case on opcode (last 7 bits) to determine the instruction type
	case (decodein[`op])
		7'b0000011: 
				begin
				// Case on FUNC3 to determine which op
				// I TYPE
				case(decodein[`func3])
					3'b000: decode = "lb";
					3'b001: decode = "lh";
					3'b010: decode = "lw";
					3'b011: decode = "ld";
					3'b100: decode = "lbu";
					3'b101: decode = "lhu";
					3'b110: decode = "lwu";
					default: $display("Invalid func3");
				endcase

				rs1_enc = decodein[`rs1];
				rd_enc = decodein[`rd];

				$sformat(decode, "%0s %0s %0s %0d", decode, rd, rs1, decodein[`imm12]);

				end


		7'b0001111: 	
				// I TYPE
				begin
				case(decodein[`func3])
					3'b000: decode = "fence";
					3'b001: decode = "fence.i";			
					default: $display("Invalid func3");
				endcase

				rs1_enc = decodein[`rs1];
				rd_enc = decodein[`rd];

				$sformat(decode, "%0s %0s %0s %0d", decode, rd, rs1, decodein[`imm12]);

				end


				

		7'b0010011: 	begin
				// I TYPE
				case(decodein[`func3])
					3'b000: decode = "addi";
					3'b001: decode = "slli";
					3'b010: decode = "slti";
					3'b011: decode = "sltiu";
					3'b100: decode = "xori";
					3'b101: case(decodein[`func7])
							7'b0000000: decode = "srli"; 
							7'b0100000: decode = "srai";
							default: $display("Invalid func7");
						endcase
					3'b110: decode = "ori";
					3'b111: decode = "andi";
					default: $display("Invalid func3");
				endcase
				rs1_enc = decodein[`rs1];
				rd_enc = decodein[`rd];
				
				// Handle li pseudoinstructions (addi rd 0 imm)
				if (decodein[`func3] == 3'b000 && decodein[`rs1] == 5'b00000)
					$sformat(decode, "li %0s %0d", rd, decodein[`imm12]);
				else	
					$sformat(decode, "%0s %0s %0s %0d", decode, rd, rs1, $signed(decodein[`imm12]));
				end

				

		7'b0110111: 	
				// U TYPE
				begin
				
					decode = "lui"; 

				$sformat(decode, "%0s %0s %0d", decode, rd, decodein[`imm20]);
				end 
				

		7'b0011011: 
				// I TYPE
				begin
				case(decodein[`func3])
					3'b000: decode = "addiw";
					3'b001: decode = "slliw";
					3'b101: case(decodein[`func7])
							7'b0000000: decode = "srliw"; 
							7'b0100000: decode = "sraiw";
							default: $display("Invalid func7");
						endcase
					default: $display("Invalid func3");
				endcase
				rs1_enc = decodein[`rs1];
				rd_enc = decodein[`rd];

				$sformat(decode, "%0s %0s %0s %0d", decode, rd, rs1, decodein[`imm12]);
				end

			 

		7'b0100011: 	begin
				// S TYPE EXCEPT FOR SD
				case(decodein[`func3])
					3'b000: decode = "sb";
					3'b001: decode = "sh";
					3'b010: decode = "sw";
					3'b011: decode = "sd"; 
					default: $display("Invalid func3");

				endcase

				rs1_enc = decodein[`rs1];
				rs2_enc = decodein[`rs2];
				imm12_enc = {decodein[31:25], decodein[11:7]};

				$sformat(decode, "%0s %0s, %0d(%0s)", decode, rs2, imm12_enc, rs1);
				end

				

		7'b0110011: 
				begin
				// R TYPE
				case(decodein[`func3])
					3'b000: case(decodein[`func7])
							7'b0000000: decode = "add"; 
							7'b0100000: decode = "sub";
						endcase

					3'b001: decode = "sll";
					3'b010: decode = "slt";
					3'b011: decode = "sltu";
					3'b100: decode = "xor";
					3'b101: case(decodein[`func7])
							7'b0000000: decode = "srl"; 
							7'b0100000: decode = "sra";
							default: $display("Invalid func7");
						endcase
					3'b110: decode = "or";
					3'b111: decode = "and";
					default: $display("Invalid func3");
				endcase 

				rs1_enc = decodein[`rs1];
				rs2_enc = decodein[`rs2];
				rd_enc = decodein[`rd];

				$sformat(decode, "%0s %0s %0s %0s", decode, rd, rs1, rs2);
				end


		7'b1110011: 
				// I TYPE
				begin
				decode = 255'b0;
				case(decodein[`func3])
					3'b000: case(decodein[`imm12])
							12'b000000000000: decode = "ecall"; 
							12'b000000000001: decode = "ebreak";
							default: $display("Invalid immediate");
						endcase
					3'b001: decode = "CSRRW";
					3'b010: decode = "CSRRS";
					3'b011: decode = "CSRRC";
					3'b101: decode = "CSRRWI";
					3'b110: decode = "CSRRSI";
					3'b111: decode = "CSRRCI";
					default: $display("Invalid func3");
				endcase

				rs1_enc = decodein[`rs1];
				rd_enc = decodein[`rd];

				$sformat(decode, "%0s", decode);
				end


		7'b0000000: decode = "nop"; 

		7'b1100011: 
				begin
				// BRANCH TYPE
				case(decodein[`func3])
					3'b000: decode = "beq";
					3'b001: decode = "bne";
	
					default: $display("Invalid func3");
				endcase 

				rs1_enc = decodein[`rs1];
				rs2_enc = decodein[`rs2];
				imm19_enc = {decodein[31], decodein[7], decodein[30:25], decodein[11:8], 1'b0};

				$sformat(decode, "%0s %0s %0s %0h", decode, rs1, rs2, $signed(imm19_enc));
				end

		7'b1101111: 
				begin
				// JUMP TYPE
				decode = "jal"; 
				imm19_enc = {decodein[31], decodein[19:12], decodein[20], decodein[30:21], 1'b0};
				rd_enc = decodein[11:7];

				$sformat(decode, "%0s %0s %0d", decode, rd, $signed(imm19_enc));
				end


		default: begin
				 decode = "INVALID OPCODE OR INSTRUCTION"; 	
				 $sformat(decode, "opcode = %s", decodein[`op]);
  			end 

		endcase
	decodeout = decode; 
	end

endmodule 



