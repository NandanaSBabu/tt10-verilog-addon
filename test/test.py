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
    dut.ui_in.value = 0  # x input
    dut.uio_in.value = 0  # y input
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Test different values of x and y
    test_cases = [
        (3, 4, 5),  # sqrt(3^2 + 4^2) = sqrt(9 + 16) = 5
        (6, 8, 10),  # sqrt(6^2 + 8^2) = sqrt(36 + 64) = 10
        (5, 12, 13),  # sqrt(5^2 + 12^2) = sqrt(25 + 144) = 13
        (0, 0, 0),  # sqrt(0^2 + 0^2) = 0
        (7, 24, 25),  # sqrt(7^2 + 24^2) = sqrt(49 + 576) = 25
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 1)
        
        assert dut.uo_out.value == expected, f"Failed for x={x}, y={y}, expected {expected}, got {dut.uo_out.value}"

    dut._log.info("All tests passed!")
