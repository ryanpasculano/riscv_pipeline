# https://stackoverflow.com/questions/4036191/sources-from-subdirectories-in-makefile

CC = iverilog

EXEC = testbench

execute_modules = $(wildcard ./execute/*.v)
fetch_modules = $(wildcard ./fetch/*.v)
mux_modules = $(wildcard ./mux_modules/*.v)

DEPS = $(fetch_modules) $(execute_modules) $(mux_modules) MUXMASTER.v FORWARDING.v

all: $(EXEC)

testbench: testbench.v $(DEPS)
	$(CC) -o testbench $(DEPS) testbench.v 
clean:
	/bin/rm -rf $(EXEC)
