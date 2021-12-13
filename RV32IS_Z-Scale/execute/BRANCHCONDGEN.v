`include "riscv.vh"
module BRANCHCONDGEN (
	input wire [`BITS32] rs1,
	input wire [`BITS32] rs2,
	output reg br_eq,
	output reg br_lt,
	output reg br_ltu
	);

// This could be made more efficiently but we aren't doing that

initial
begin
	$display("init BRANCHCONDGEN");
end


always@(*)
	begin
		if (rs1 === rs2)
		begin
			br_eq = `TRUE;
		end
		else 
		begin
			br_eq = `FALSE;
		end

		if (rs1 < rs2)
		begin
			br_ltu = `TRUE;

		end
		else 
		begin
			br_ltu = `FALSE;	
		end

		if ($signed(rs1) < $signed(rs2))
		begin
			br_lt = `TRUE;
		end
		else 
		begin
			br_lt = `FALSE;	
		end
	end

endmodule // end BRANCHCONDGEN
