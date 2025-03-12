# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

# Check if Gate-Level (GL) simulation is enabled
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

# Add Skywater 130nm PDK standard cell libraries for gate-level simulation
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Include synthesized netlist (copied by GDS action workflow)
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via include
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources
VERILOG_SOURCES += $(PWD)/tb.v

# Set the top-level module for simulation
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# Include Cocotb's make rules to handle simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
