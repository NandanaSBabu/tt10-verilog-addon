SHELL := /bin/bash

# Project variables
TOP_MODULE = tt_um_rect_cyl
VERILOG_FILES = ../src/project.v

# Simulation files
TB_FILE = tb.v
VCD_FILE = tb.vcd

# Simulation command
SIM_CMD = iverilog -o sim.out $(VERILOG_FILES) $(TB_FILE) && vvp sim.out

# Default target
all: sim

# Run simulation
sim:
	$(SIM_CMD)
	gtkwave $(VCD_FILE) &

# Clean simulation files
clean:
	rm -f sim.out $(VCD_FILE)

.PHONY: all sim clean
