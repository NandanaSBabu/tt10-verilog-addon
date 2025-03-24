# Makefile for Cocotb and TinyTapeout

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

# RTL simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

# Allow sharing configuration between design and testbench via include:
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# Verilator linting (Skip if not installed)
lint:
        @if command -v verilator >/dev/null 2>&1; then \
                verilator --lint-only -Wno-TIMESCALEMOD -Wno-UNOPTFLAT $(VERILOG_SOURCES); \
        else \
                echo "Skipping lint: Verilator not found"; \ # Line 25 fixed!
        fi

# Hardened Layout Generation
harden:
        cd openlane && make harden

# Clean temporary files
clean:
        rm -rf sim_build test/results.xml openlane/runs/*

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# TinyTapeout GDS Generation (if needed)
gds: harden
        # Add any post-harden commands if necessary.
        # Example to copy the gds file:
        mkdir -p gds
        cp openlane/runs/tt_um_addon/results/final/tt_um_addon.gds gds/tt_um_addon.gds

# TinyTapeout GDS check (if needed)
gds_check: gds
        # Add GDS checking commands here, if applicable.
        # For example, using a GDS checker tool.
        echo "GDS Check Placeholder"

# Test and GDS pipeline
all: test gds gds_check

# Force cocotb reinstall in case of makefile conflict.
force_cocotb_reinstall:
        pip uninstall cocotb -y
        pip install --no-cache-dir cocotb

# Run all tests and GDS generation in a single command.
ci: force_cocotb_reinstall all
