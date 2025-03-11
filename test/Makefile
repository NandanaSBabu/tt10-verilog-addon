# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate level simulation:
SIM_BUILD = sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via include:
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tt_um_rect_cyl

# MODULE is the basename of the Python test file
MODULE = test

# Generate the VCD dump file for waveform analysis
VCD_DUMP = test/tb.vcd

# GTKWave configuration
GTKW_FILE = test/tb.gtkw

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Additional GTKWave setup
.PHONY: view_waveform
view_waveform:
	gtkwave $(VCD_DUMP) $(GTKW_FILE)

# Ensure the required source file exists
.PHONY: check_sources
check_sources:
	@if [ ! -f $(SRC_DIR)/$(PROJECT_SOURCES) ]; then \
		echo "Error: Source file $(SRC_DIR)/$(PROJECT_SOURCES) not found!"; \
		exit 1; \
	fi

# Modify simulation rule to check sources first
sim: check_sources
