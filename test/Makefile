SIM ?= icarus

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell find ./ -name "*.v")

TOPLEVEL = tt_um_cartesian_to_cylindrical
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim
