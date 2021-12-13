// This module is simply a helper module for the decoder (to keep the decoder module 
// relatively short.) It takes in the address of a register and translates that to 
// a human-readable name rather than the 5 bit binary value specified in the 
// opcode. 
//
// This also allows easy renaming of the registers, i.e, if we wanted to call x1
// t0 instead, a temp register, this only requires renaming in one place (the constants
// file, riscv.h).
//
// Michael Matirko
// CSCI320
// Lab04

module REGHELPER(input wire [4:0] reg_id, output reg [255:0] reg_name);
	always@(*) begin
		case (reg_id)
			5'b00000: reg_name = `REGX0; 
			5'b00001: reg_name = `REGX1;
			5'b00010: reg_name = `REGX2; 
			5'b00011: reg_name = `REGX3;
			5'b00100: reg_name = `REGX4; 
			5'b00101: reg_name = `REGX5;
			5'b00110: reg_name = `REGX6;
			5'b00111: reg_name = `REGX7;
			5'b01000: reg_name = `REGX8; 
			5'b01001: reg_name = `REGX9;
			5'b01010: reg_name = `REGX10; 
			5'b01011: reg_name = `REGX11; 
			5'b01100: reg_name = `REGX12;
			5'b01101: reg_name = `REGX13;
			5'b01110: reg_name = `REGX14;
			5'b01111: reg_name = `REGX15; 
			5'b10000: reg_name = `REGX16; 
			5'b10001: reg_name = `REGX17;
			5'b10010: reg_name = `REGX18;
			5'b10011: reg_name = `REGX19;
			5'b10100: reg_name = `REGX20;
			5'b10101: reg_name = `REGX21;
			5'b10110: reg_name = `REGX22;
			5'b10111: reg_name = `REGX23;
			5'b11000: reg_name = `REGX24;
			5'b11001: reg_name = `REGX25;
			5'b11010: reg_name = `REGX26;
			5'b11011: reg_name = `REGX27;
			5'b11100: reg_name = `REGX28;
			5'b11101: reg_name = `REGX29;
			5'b11110: reg_name = `REGX30;
			5'b11111: reg_name = `REGX31; 
		endcase
	end
		
endmodule 
