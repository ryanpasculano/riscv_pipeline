`include "riscv.vh"
module DECODER_REG(input wire [4:0] reg_bin, output reg [63:0] reg_str);


always@(*)
		case(reg_bin[4:0])
			5'b00000: reg_str = "zero    ";
			5'b00001: reg_str = "ra      ";
			5'b00010: reg_str = "sp      ";
			5'b00011: reg_str = "gp      ";
			5'b00100: reg_str = "tp      ";
			5'b00101: reg_str = "t0      ";
			5'b00110: reg_str = "t1      ";
			5'b00111: reg_str = "t2      ";
			5'b01000: reg_str = "s0      ";
			5'b01001: reg_str = "s1      ";
			5'b01010: reg_str = "a0      ";
			5'b01011: reg_str = "a1      ";
			5'b01100: reg_str = "a2      ";
			5'b01101: reg_str = "a3      ";
			5'b01110: reg_str = "a4      ";
			5'b01111: reg_str = "a5      ";
			5'b10000: reg_str = "a6      ";
			5'b10001: reg_str = "a7      ";
			5'b10010: reg_str = "s2      ";
			5'b10011: reg_str = "s3      ";
			5'b10100: reg_str = "s4      ";
			5'b10101: reg_str = "s5      ";
			5'b10110: reg_str = "s6      ";
			5'b10111: reg_str = "s7      ";
			5'b10000: reg_str = "s8      ";
			5'b10001: reg_str = "s9      ";
			5'b10010: reg_str = "s10     ";
			5'b11011: reg_str = "s11     ";
			5'b11100: reg_str = "t3      ";
			5'b11101: reg_str = "t4      ";
			5'b11110: reg_str = "t5      ";
			5'b11111: reg_str = "t6      ";
			default: reg_str =  "error   ";
		endcase

endmodule // end DECODER_REG