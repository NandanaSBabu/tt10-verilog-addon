# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1  # Enable the design
    dut.ui_in.value = 0  # Set ui_in to 0 initially
    dut.uio_in.value = 0  # Set uio_in to 0 initially
    dut.rst_n.value = 0  # Assert reset (active low)
    await ClockCycles(dut.clk, 10)  # Wait for 10 clock cycles
    dut.rst_n.value = 1  # Deassert reset

    # Test case 1: Check with ui_in = 0, uio_in = 0
    dut._log.info("Testing with ui_in = 0, uio_in = 0")
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)  # Wait for 1 clock cycle
    assert dut.uo_out.value == 0, f"Expected 0, got {dut.uo_out.value}"

    # Test case 2: Check with ui_in = 3, uio_in = 4 (Expecting uo_out = 5)
    dut._log.info("Testing with ui_in = 3, uio_in = 4")
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, f"Expected 5, got {dut.uo_out.value}"

    # Test case 3: Check with ui_in = 6, uio_in = 8 (Expecting uo_out = 10)
    dut._log.info("Testing with ui_in = 6, uio_in = 8")
    dut.ui_in.value = 6
    dut.uio_in.value = 8
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 10, f"Expected 10, got {dut.uo_out.value}"

    # Test case 4: Check with ui_in = 5, uio_in = 12 (Expecting uo_out = 13)
    dut._log.info("Testing with ui_in = 5, uio_in = 12")
    dut.ui_in.value = 5
    dut.uio_in.value = 12
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 13, f"Expected 13, got {dut.uo_out.value}"

    dut._log.info("All test cases passed!")
