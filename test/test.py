# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import math


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Cartesian to Cylindrical Conversion Test")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0  # X input
    dut.uio_in.value = 0  # Y input
    dut.z_in.value = 0  # Z input
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Test with different values of (x, y, z)
    test_cases = [
        (3, 4, 5),   # Expected: r = 5, θ ≈ 53.13° (0.93 rad), z_out = 5
        (6, 8, 10),  # Expected: r = 10, θ ≈ 53.13° (0.93 rad), z_out = 10
        (0, 5, 7),   # Expected: r = 5, θ = 90° (1.57 rad), z_out = 7
        (-3, -4, -2), # Expected: r = 5, θ ≈ -126.87° (-2.21 rad), z_out = -2
        (7, 0, 3)    # Expected: r = 7, θ = 0° (0 rad), z_out = 3
    ]

    for x, y, z in test_cases:
        # Apply test inputs
        dut.ui_in.value = x
        dut.uio_in.value = y
        dut.z_in.value = z

        # Wait for output to settle
        await ClockCycles(dut.clk, 1)

        # Compute expected results
        expected_r = int(math.sqrt(x**2 + y**2))  # Round if needed
        expected_theta = int(math.degrees(math.atan2(y, x)))  # Convert radians to degrees
        expected_z_out = z  # Z remains unchanged

        # Read actual output
        actual_r = int(dut.uo_out.value)
        actual_theta = int(dut.uio_out.value)
        actual_z_out = int(dut.z_out.value)

        # Log and check values
        dut._log.info(f"Input (x, y, z) = ({x}, {y}, {z}) -> Output (r, θ, z_out) = ({actual_r}, {actual_theta}, {actual_z_out})")

        assert actual_r == expected_r, f"Mismatch in r: expected {expected_r}, got {actual_r}"
        assert actual_theta == expected_theta, f"Mismatch in θ: expected {expected_theta}, got {actual_theta}"
        assert actual_z_out == expected_z_out, f"Mismatch in z_out: expected {expected_z_out}, got {actual_z_out}"

    dut._log.info("All test cases passed!")
