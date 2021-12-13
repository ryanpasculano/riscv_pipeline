CC = iverilog

EXECS = lab04

DEPS = pc.v add4.v mem.v decoder.v reghelper.v control.v alu.v muxes.v regfile.v datamem.v targgen_jr.v targgen_j.v targgen_b.v branchcondgen.v

all: $(EXECS)

lab04: lab04.v
	$(CC) lab04.v $(DEPS)
clean:
	/bin/rm -rf a.out
