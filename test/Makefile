# Makefile for running Cocotb tests with Icarus Verilog

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src

# Verilog source file
VERILOG_SOURCES = $(SRC_DIR)/project.v

# Simulation setup
SIM_BUILD = sim_build
TOPLEVEL = project
MODULE = test_project

include $(shell cocotb-config --makefiles)/Makefile.sim
