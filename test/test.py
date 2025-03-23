# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import math

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

    # Test cases (a, b, expected sqrt(a^2 + b^2))
    test_cases = [
        (20, 99, int(math.sqrt(20**2 + 99**2))),
        (6, 8, int(math.sqrt(6**2 + 8**2))),
        (15, 112, int(math.sqrt(15**2 + 112**2))),
        (8, 15, int(math.sqrt(8**2 + 15**2))),
        (20, 21, int(math.sqrt(20**2 + 21**2)))
    ]

    for ui_val, uio_val, expected in test_cases:
        dut.ui_in.value = ui_val
        dut.uio_in.value = uio_val
        await ClockCycles(dut.clk, 1)

        actual = int(dut.uo_out.value)
        dut._log.info(f"Input: {ui_val}, {uio_val} | Output: {actual} | Expected: {expected}")

        assert actual == expected, f"Test failed: sqrt({ui_val}² + {uio_val}²) = {actual}, expected {expected}"
