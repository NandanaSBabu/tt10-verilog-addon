# Set the simulator and language
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Project paths
SRC_DIR = $(PWD)
TEST_DIR = $(PWD)/test
BUILD_DIR = $(PWD)/sim_build

# Verilog source files
VERILOG_SOURCES = $(SRC_DIR)/project.v $(SRC_DIR)/tb.v

# Top-level module (testbench)
TOPLEVEL = tb

# Python test module (without .py extension)
MODULE = test

# Include Cocotb makefile rules
include $(shell cocotb-config --makefiles)/Makefile.sim

# Cleanup build and simulation files
clean:
	rm -rf $(BUILD_DIR) *.vcd __pycache__

# Run simulation
sim:
	make clean
	make SIM=$(SIM) TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE)
