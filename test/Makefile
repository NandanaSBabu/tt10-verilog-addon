SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src

# Verilog source files
VERILOG_SOURCES = $(SRC_DIR)/project.v

# Simulation settings
TOPLEVEL = tt_um_cartesian_to_cylindrical
MODULE = test
SIM_BUILD = sim_build

include $(shell cocotb-config --makefiles)/Makefile.sim
