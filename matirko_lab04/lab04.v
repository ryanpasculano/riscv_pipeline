/*
	compile with: make all
	Michael Matirko
	CSCI 320
*/

`include "riscv.vh"

module lab03;

// If we need to debug
integer DEBUG; 

integer cycle; 

reg clock;                  				// testbench clock

// Wire declarations for pc, add4, mem, and decoder
wire [31:0] memout;         				// Currently addressed word.
wire [31:0] base; 
wire [31:0] pc_in; 
wire [31:0] pcplus4; 
wire [31:0] pcout;
wire [255:0] decout; 					// String representation of the current op  

// Wire declarations for control 
wire [3:0] AluFun; 
wire [2:0] pc_sel;
wire [1:0] Op2Sel, Wb_sel;
wire Op1Sel, Rf_wen, mem_rw, mem_val; 

// Wire declarations for target generators 
wire [31:0] targgen_jr_out; 
wire [31:0] targgen_j_out;
wire [31:0] targgen_b_out;
wire [19:0] uj_immoffset; 
wire [11:0] b_immoffset; 
assign uj_immoffset = {memout[31], memout[19:12], memout[20], memout[30:21]};
assign b_immoffset = {memout[31], memout[7], memout[30:25], memout[11:8]};

// Declarations for ALU
wire [`WIDTH - 1:0] op1, op2; 
wire [`WIDTH - 1:0] ALUout; 

// Declarations for regfile
wire [31:0] rs2; 
wire [31:0] rs1; 
wire [31:0] wd; 

// Declarations for datamem
wire [31:0] rdata; 

// Declarations for branch condition generator
wire br_eq; 
wire br_lt; 
wire br_ltu; 

// Handle i-type sign extend
wire signed [31:0] i_sign_ext; 
assign i_sign_ext = {{20{memout[31]}}, memout[31:20]}; 

// Handle s-type sign extend
wire signed [31:0] s_sign_ext; 
assign s_sign_ext = {{20{memout[31]}}, memout[31:25], memout[11:7]}; 

PC pc(clock, pc_in, pcout);
ADD4 add4 (pcout, pcplus4); 
MEM mem(pcout, memout);
DECODER decoder(memout, decout);
ALU alu (AluFun, op2, op1, ALUout); 
CONTROL control(memout, br_eq, pc_sel, AluFun, Op2Sel, Wb_sel, Op1Sel, Rf_wen, mem_rw, mem_val);

// Target generator for jumpreg, branch, and jump
TARGGEN_JR targgen_jr(rs1, i_sign_ext, targgen_jr_out);
TARGGEN_J targgen_j(uj_immoffset, pcout, targgen_j_out);
TARGGEN_B targgen_b(b_immoffset, pcout, targgen_b_out); 

// Muxes to control ALU Inputs op2 and op1
// note the weird concatenation thing needed because inputs to muxes 
// need to be 32 bits (to avoid making special muxes)
MUX4 mux4(Op2Sel, pcout, i_sign_ext, s_sign_ext, rs2, op2);
MUX mux(Op1Sel, rs1, {memout[31:12], 12'b0}, op1); 

// Mux to control write output
// Note that the connection to CSR regs is set to all zeros currently
MUX4 mux_wd(Wb_sel, 32'b0, pcplus4, ALUout, rdata, wd);
 
// Register file (stores register contents)
REGFILE regfile(clock, Rf_wen, memout[`rs1], memout[`rs2], memout[`rd], wd, rs1, rs2);

// Mux to select input to PC
MUX5 mux_pc(pc_sel, pcplus4, targgen_jr_out, targgen_b_out, targgen_j_out, 32'b0, pc_in); 

// Data memory
DATAMEM datamem(clock, rs2, ALUout, mem_rw, mem_val, rdata);

// Branch condition generator
BRANCHCONDGEN branchcondgen(rs1, rs2, br_eq, br_lt, br_ltu);

///////////////////////// TESTBENCH CODE //////////////////////////////
initial
begin
	// Make GTKWave output data
    	$dumpfile("test.vcd");
    	$dumpvars(0, lab03);

	// Turn debug off 
	DEBUG = 0;

	// Set the clock to zero
	clock = 0;
	
	// set cycle to zero 
	cycle = 0; 

	// Set the top of the stack
	regfile.registers[`STACK_POINTER] = `STACK_TOP; 

	// testbench
	$display("\n%t: Loading file %s", $time, `PROGRAM_FILE);
	$display("%t: boot.", $time);
	$display("%t: PC: 0x%h, IR: 0x%h, %-s", $time, pcout, memout, decout);
	$display("%t: pc_sel: %b, AluFun: %b, Op2Sel: %b, Wb_sel: %b, Op1Sel %b, Rf_wen %b, Mem_rw: %b, Mem_val: %b", $time, 
		pc_sel, AluFun, Op2Sel, Wb_sel, Op1Sel, Rf_wen, mem_rw, mem_val); 

	#50000; $finish;
end

always @(posedge clock) begin
	$display($time, ": +++++++++++++++++++++++++++++++");
	if (memout == 0) begin
		$display("%t: Simulation finished. IR: 0x%h, PC: 0x%h \n", $time, memout, pcout);	
		regfile.disp();	
		$finish;
	end

	$display("[%d]", cycle); 
	cycle = cycle + 1; 

	$display("%t: PC: 0x%h, IR: 0x%h, %-s", $time, pcout, memout, decout);

	if (DEBUG) begin 
		$display("%t: pc_sel: %b, AluFun: %b, Op2Sel: %b, Wb_sel: %b, Op1Sel %b, Rf_wen %b, Mem_rw: %b, Mem_val: %b, br_eq: %b", $time, 
			pc_sel, AluFun, Op2Sel, Wb_sel, Op1Sel, Rf_wen, mem_rw, mem_val, br_eq); 
		$display("%t: ALU INFO: op1 = %h, op2 = %h, AluFun = %b, ALUOut = %h", $time, op1, op2, AluFun, ALUout);
		$display("%t: targgen_j: %h", $time, targgen_j_out);
		$display("%t: wa: %b", $time, memout[11:7]); 
  	end 

	regfile.disp();

	// Handle ECALL
	if (memout == `ECALL) begin
		if (regfile.registers[`ECALL_REG] == 1)
			// Print integer from a1 - ecall(1)
			$display($time, ": ***** STDOUT: (print integer from ecall): %d", $signed(regfile.registers[11]));

		else begin

			$display("%t: Simulation finished. IR: 0x%h, PC: 0x%h \n", $time, memout, pcout);	
			regfile.disp();	
			$finish;
		end

	end
	


end


always @(negedge clock) begin
	$display($time, ": ---------------------------------");

end
///////////////////////// CLOCK GENERATOR //////////////////////////////
always 
begin                     
	#10; 
	clock = ~clock;
end

endmodule
