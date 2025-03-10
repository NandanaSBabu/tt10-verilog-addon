# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import math


@cocotb.test()
async def test_project(dut):
    """Test Cartesian to Cylindrical Conversion"""
    dut._log.info("Starting test")

    # Initialize signals
    dut.x.value = 0
    dut.y.value = 0

    test_cases = [
        (3, 4),
        (-6, -8),
        (0, 5),
        (7, 0),
        (-5, 5)
    ]

    for x, y in test_cases:
        dut.x.value = x
        dut.y.value = y
        await ClockCycles(dut.clk, 1)

        expected_r = int(math.sqrt(x**2 + y**2))
        expected_theta = int(math.degrees(math.atan2(y, x)))

        actual_r = int(dut.r.value)
        actual_theta = int(dut.theta.value)

        dut._log.info(f"Input (x, y) = ({x}, {y}) -> Output (r, θ) = ({actual_r}, {actual_theta})")
        assert actual_r == expected_r, f"Mismatch in r: expected {expected_r}, got {actual_r}"
        assert actual_theta == expected_theta, f"Mismatch in θ: expected {expected_theta}, got {actual_theta}"

    dut._log.info("All tests passed!")
