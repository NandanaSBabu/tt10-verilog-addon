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

    dut._log.info("Testing project behavior")

    # Test cases: (x, y, expected_hypotenuse)
    test_cases = [
        (3, 4, 5),
        (6, 8, 10),
        (5, 12, 13),
        (8, 15, 17),
        (7, 24, 25),
        (20, 21, 29)
    ]

    for ui_val, uio_val, expected in test_cases:
        dut.ui_in.value = ui_val
        dut.uio_in.value = uio_val
        await ClockCycles(dut.clk, 5)  # Wait for computation
        assert dut.uo_out.value == expected, f"Test failed: {ui_val}, {uio_val} -> {dut.uo_out.value}, expected {expected}"
        dut._log.info(f"Test passed: {ui_val}, {uio_val} -> {dut.uo_out.value}")
