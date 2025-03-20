# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Test case 1: Check sqrt(0^2 + 0^2) = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, f"Expected 0, got {dut.uo_out.value}"

    # Test case 2: Check sqrt(3^2 + 4^2) = 5
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, f"Expected 5, got {dut.uo_out.value}"

    # Test case 3: Check sqrt(6^2 + 8^2) = 10
    dut.ui_in.value = 6
    dut.uio_in.value = 8
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 10, f"Expected 10, got {dut.uo_out.value}"

    # Test case 4: Check sqrt(5^2 + 12^2) = 13
    dut.ui_in.value = 5
    dut.uio_in.value = 12
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 13, f"Expected 13, got {dut.uo_out.value}"

    dut._log.info("All test cases passed!")
