# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_sqrt_pythagoras(dut):
    dut._log.info("Starting test for sqrt(x^2 + y^2)")

    # Set up the clock (10 ns period = 100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the design
    dut._log.info("Applying reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # Test cases: (x, y) → expected sqrt_out
    test_cases = [
        (3, 4, 5),   # sqrt(3² + 4²) = 5
        (6, 8, 10),  # sqrt(6² + 8²) = 10
        (5, 12, 13), # sqrt(5² + 12²) = 13
        (7, 24, 25), # sqrt(7² + 24²) = 25
        (0, 0, 0),   # sqrt(0² + 0²) = 0
    ]

    for x_val, y_val, expected in test_cases:
        dut.x.value = x_val
        dut.y.value = y_val

        # Wait for the output to stabilize
        await ClockCycles(dut.clk, 10)

        # Check if the output matches expected value
        assert dut.sqrt_out.value == expected, f"Failed for x={x_val}, y={y_val}, got {dut.sqrt_out.value}, expected {expected}"
        dut._log.info(f"PASS: sqrt({x_val}² + {y_val}²) = {dut.sqrt_out.value}")

    dut._log.info("All test cases passed!")
