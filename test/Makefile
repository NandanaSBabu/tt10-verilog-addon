# Makefile for Cocotb test

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

ifneq ($(GATES),yes)

# RTL simulation
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate-level simulation
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Gate-level netlist
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include the testbench sources
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# Python test module
MODULE = test

# Include cocotb's make rules
include $(shell cocotb-config --makefiles)/Makefile.sim

# Clean rule (Fixed duplicate issue)
.PHONY: clean
clean:
	rm -rf sim_build
