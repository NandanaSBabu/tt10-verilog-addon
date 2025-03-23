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
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)  # Hold reset for 5 cycles
    dut.rst_n.value = 1

    test_cases = [
        (3, 4, 5),   # sqrt(3^2 + 4^2) = 5
        (6, 8, 10),  # sqrt(6^2 + 8^2) = 10
        (5, 12, 13), # sqrt(5^2 + 12^2) = 13
        (8, 15, 17), # sqrt(8^2 + 15^2) = 17
        (12, 16, 20) # sqrt(12^2 + 16^2) = 20
    ]

    for a, b, expected in test_cases:
        dut.ui_in.value = a
        dut.uio_in.value = b
        await ClockCycles(dut.clk, 10)  # Allow time for computation
        assert dut.uo_out.value == expected, f"Failed for ({a}, {b}): Expected {expected}, got {int(dut.uo_out.value)}"
        dut._log.info(f"Test passed: a={a}, b={b}, sqrt(a^2 + b^2)={int(dut.uo_out.value)}")

    dut._log.info("All tests completed successfully")
