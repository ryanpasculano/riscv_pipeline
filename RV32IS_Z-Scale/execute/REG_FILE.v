`include "riscv.vh"
module REG_FILE (
	input wire [`BITS5] rs1_addr, 
	input wire [`BITS5] rs2_addr,
	input wire [`BITS5] wr_addr,
	input wire [`BITS32] wd,
	input wire rf_wen,  
	input wire clk,  
	output reg [`BITS32] rs1, 
	output reg [`BITS32] rs2
	);

///////////////////////// internal memory storage //////////////////////////////
reg [`BITS32] mem [`BITS32];  // store 32 32-bit words.
reg [`BITS12] i;
reg [`BITS32] pos;
reg [`BITS32] neg;
reg signed [`BITS32] ecall_val;
//////////////////////////////// initial ///////////////////////////////////////
initial
	begin
		$display($time, ":reading in reg_file memory");
		$readmemh(`REG_FILE, mem, `START_OF_REGFILE, `END_OF_REGFILE);
		i = 0;
		pos = mem[11][30:0];
		neg = mem[11][31] << 31;
		$display($time, ":done reading in reg_file memory");	
	end

always@(*)
	begin
		rs2 <= mem[rs2_addr];
		rs1 <= mem[rs1_addr];
		pos = mem[11][30:0];
		neg = mem[11][31] << 31;
		ecall_val = pos - neg;
	end

// write back to register
always@(negedge clk)
	begin
		if (rf_wen == `TRUE && wr_addr != 5'b00000) // Added check for non zero address to keep it at zero
			begin
				mem[wr_addr] <= wd;  
			end	
	end

	task print_reg;
		begin
  			$display($time, ": zero: 0x%08x  ra: 0x%08x  sp: 0x%08x  gp: 0x%08x", mem[i     ], mem[i +  1], mem[i + 2 ], mem[i + 3 ]);
  			$display($time, ":   tp: 0x%08x  t0: 0x%08x  t1: 0x%08x  t2: 0x%08x", mem[i + 4 ], mem[i +  5], mem[i + 6 ], mem[i + 7 ]);
  			$display($time, ":   s0: 0x%08x  s1: 0x%08x  a0: 0x%08x  a1: 0x%08x", mem[i + 8 ], mem[i +  9], mem[i + 10], mem[i + 11]);
  			$display($time, ":   a2: 0x%08x  a3: 0x%08x  a4: 0x%08x  a5: 0x%08x", mem[i + 12], mem[i + 13], mem[i + 14], mem[i + 15]);
  			$display($time, ":   a6: 0x%08x  a7: 0x%08x  s2: 0x%08x  s3: 0x%08x", mem[i + 16], mem[i + 17], mem[i + 18], mem[i + 19]);
  			$display($time, ":   s4: 0x%08x  s5: 0x%08x  s6: 0x%08x  s7: 0x%08x", mem[i + 20], mem[i + 21], mem[i + 22], mem[i + 23]);
  			$display($time, ":   s8: 0x%08x  s9: 0x%08x s10: 0x%08x s11: 0x%08x", mem[i + 24], mem[i + 25], mem[i + 26], mem[i + 27]);
  			$display($time, ":   t3: 0x%08x  t4: 0x%08x  t5: 0x%08x  t6: 0x%08x", mem[i + 28], mem[i + 29], mem[i + 30], mem[i + 31]);
  		
		end
	endtask

	task ecall;
		begin
			$display("ECALL: %d",mem[i+10]);
			if (mem[i + 10] == 32'h00000001)
			begin
				$display($time, ":  HAPPY BIRTHDAY a1: %d", ecall_val);
				
			end
			else if (mem[i + 10] == 32'h0000000a || mem[i + 10] == 32'h00000000)
			begin
				$display($time, ": ECALL program terminating");
				$display($time, ": Finished running program: %s", `PROGRAM_FILE);
				$finish;
			end
  			
		end
	endtask

endmodule