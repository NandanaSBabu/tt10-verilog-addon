TOPLEVEL_LANG = verilog
SIM = xsim  # Use the simulator you are working with (ModelSim, VCS, or XSIM)
TOPLEVEL = tb_tt_um_addon
MODULE = test

# Set simulation options
VERILOG_SOURCES = $(shell pwd)/tt_um_addon.v $(shell pwd)/tb.v
MODULE = test_project

# Cocotb make options
COCOTB_INCDIR = $(shell cocotb-config --python-include)
COCOTB_LIBDIR = $(shell cocotb-config --python-libdir)
CXX = g++
PYTHON = python3

# Compiler and simulator
include $(shell cocotb-config --makefiles)/Makefile.sim
