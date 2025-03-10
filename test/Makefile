# Makefile for running tests with Icarus Verilog and Cocotb

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src

# Verilog source files
VERILOG_SOURCES = $(SRC_DIR)/project.v

# Simulation settings
TOPLEVEL = project
MODULE = test_project
SIM_BUILD = sim_build

include $(shell cocotb-config --makefiles)/Makefile.sim
