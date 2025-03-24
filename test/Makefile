# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

ifneq ($(GATES),yes)

# RTL Simulation
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/, $(PROJECT_SOURCES))

else

# Gate-Level Simulation
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

# Verify PDK_ROOT is set
ifndef PDK_ROOT
$(error "PDK_ROOT is not set. Please set it to the path of the Sky130 PDK.")
endif

# Add Sky130 Libraries
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Add gate-level netlist (ensure it exists)
ifeq ($(wildcard $(PWD)/gate_level_netlist.v),)
$(error "gate_level_netlist.v is missing. Run synthesis before GDS simulation.")
endif

VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include the design sources
COMPILE_ARGS += -I$(SRC_DIR)

# Testbench
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# Include Cocotb's make rules
include $(shell cocotb-config --makefiles)/Makefile.sim

# Clean target (only one definition)
.PHONY: clean
clean:
	rm -rf sim_build *.vcd *.log *.out *.vvp
