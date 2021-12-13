`include "riscv.vh"
module MUXMASTER (
	input wire [`BITS32] instruction,
	input wire [`BITS32] instruction2,
	input wire [`BITS32] rs1,
	input wire [`BITS32] rs2,
	input wire [`BITS5] wb_addr,
	input wire [`BITS3] pc_sel,
	input wire BE_rdy2,
	output reg [`BITS2] m1, 
	output reg [`BITS2] m2,
	output reg m3,
	output reg m4,
	output reg m5,
	output reg [`BITS2] m6,
	output reg BE_rdy
	);

// Branch Condition Generator Module
wire br_eq;
wire br_lt;
wire  br_ltu;
BRANCHCONDGEN branchcondgen(rs1, rs2, br_eq, br_lt, br_ltu);

always@(*)
	begin
	case(instruction2[`op])
			`LOAD   : //0x03
			begin
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			end
			`FENCE  : //0x0f
			begin // ERROR FOR NOW
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			 end 
			`ITYPE  : //0x13
			begin
			m1 <= 2'b00;
			m3 <= 1'b0;
			if (instruction2[`func3] == 3'b001 || instruction2[`func3] == 3'b101)
				m6 <= 2'b10;
			else 
			m6 <= 2'b01;
			end
			`AUIPC  : //0x17
			begin // ERROR FOR NOW
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			end 
			`IWTYPE : //0x1b
			begin //ERROR FOR NOW
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			 end 
			`STORE  : //0x23
			begin
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			end  	
			`RTYPE  : //0x33
			begin
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			 end 
			`LUI    : //0x37
			begin
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b00;
			end  	
			`RWTYPE : //0x3b
			begin // ERROR FOR NOW
			m1 <= 2'b00;
			m3 <= 1'b0;
			m6 <= 2'b01;
			 end 
			`BRANCH : //0x63
			begin
			m1 <= 2'b00;
			if ((br_eq === 1'b1 && instruction2[`func3] === 3'b000) || (br_eq === 1'b0 && instruction2[`func3] === 3'b001))
				m3 <= 1'b1;
			else if ((br_lt === 1'b1 && instruction2[`func3] === 3'b100) || (br_lt === 1'b0 && instruction2[`func3] === 3'b101))
				m3 <= 1'b1;
			else if ((br_ltu === 1'b1 && instruction2[`func3] === 3'b110) || (br_ltu === 1'b0 && instruction2[`func3] === 3'b111))
				m3 <= 1'b1;
			else
				m3<=1'b0;
			m6 <= 2'b01;
			end
			`JALR   : //0x67
			begin // ERROR FOR NOW
			m1 <= 2'b01;
			m3<=1'b0;
			m6 <= 2'b01;
			 end 
			`JAL    : //0x6f
			begin
			m1 <= 2'b00;
			m3<=1'b0;
			m6 <= 2'b01;
			 end  	
			`SYSTEM : //0x73
			begin
			m1 <= 2'b00;
			m3<=1'b0;
			m6 <= 2'b01;
			 end 
			default: //ERROR
			begin
			m1 <= 2'bxx;
			m3<=1'b0;
			m6 <= 2'b01;
			end  	
			endcase

	

	//*************************************************************************************
	// removed forwarding in an attempt to get branch to work
	//*************************************************************************************
	if (instruction2[24:20] == wb_addr)
		m4 <= 1'b1;
	else begin
		m4 <= 1'b1;
	end
	


	if(instruction2[19:15] == wb_addr)
		m5 <= 1'b0;
	else begin
		m5 <= 1'b1;
	end

	if ( ((instruction[`op] == `LOAD && (instruction2[24:20] == instruction[11:7] || instruction2[19:15] == instruction[11:7])) || (instruction[`op] == `BRANCH) || (instruction[`op] == `JAL) || (instruction[`op] == `JALR))) 
	begin

		BE_rdy = 1'b0;
		$display("BE_RDY = 0");
		$display("load: %d, r1:%d, rs:%d",(instruction[`op] == `LOAD), (instruction2[24:20] == instruction[11:7]), (instruction2[19:15] == instruction[11:7]) );
		$display("branch: %d, jal: %d, jalr: %d", (instruction[`op] == `BRANCH), (instruction[`op] == `JAL), (instruction[`op] == `JALR));
	end
	else begin
		BE_rdy = 1'b1;
		$display("BE_RDY = 1");
	end

	if (pc_sel == 3'b001 || pc_sel == 3'b010 ||  pc_sel == 3'b011)
		m2 <= 2'b10; 
	//else if ((BE_rdy == 1'b0 && BE_rdy2 == 1'b1))
	//	m2 <= 2'b00; 
	else 
		m2 <= 2'b01; 




	// always block	
	end


 

endmodule // end CONTROL