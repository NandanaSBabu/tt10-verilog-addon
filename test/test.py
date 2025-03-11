# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Rectangular to Cylindrical Conversion Test")

    # Set up a 100 MHz clock (10 ns period)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut._log.info("Applying reset...")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)  # Wait for reset cycle
    dut.rst_n.value = 1
    dut._log.info("Reset complete.")

    # Define test cases (x, y) -> Expected approximate values (for reference)
    test_cases = [
        (10, 20),  # Expected r ≈ 22, theta ≈ atan(20/10)
        (30, 40),  # Expected r ≈ 50, theta ≈ atan(40/30)
        (50, 60),  # Expected r ≈ 78, theta ≈ atan(60/50)
        (70, 80),  # Expected r ≈ 106, theta ≈ atan(80/70)
        (90, 100)  # Expected r ≈ 134, theta ≈ atan(100/90)
    ]

    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 2)  # Wait for processing

        r_output = dut.uo_out.value.integer
        theta_output = dut.uio_out.value.integer

        dut._log.info(f"Inputs: x={x}, y={y} -> Outputs: r={r_output}, theta={theta_output}")

        # Ensure outputs are valid and non-negative
        assert r_output >= 0, f"Error: r should be non-negative, got {r_output}"
        assert theta_output >= 0, f"Error: theta should be non-negative, got {theta_output}"

    # Final stability test
    dut.ui_in.value = 100
    dut.uio_in.value = 200
    await ClockCycles(dut.clk, 5)  # Allow time for changes

    r_output = dut.uo_out.value.integer
    theta_output = dut.uio_out.value.integer

    dut._log.info(f"Final Inputs: x=100, y=200 -> Outputs: r={r_output}, theta={theta_output}")

    # Ensure final outputs are valid
    assert r_output >= 0, f"Final error: r should be non-negative, got {r_output}"
    assert theta_output >= 0, f"Final error: theta should be non-negative, got {theta_output}"

    dut._log.info("Test completed successfully.")
