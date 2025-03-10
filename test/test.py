# SPDX-License-Identifier: Apache-2.0

import cocotb
import math
from cocotb.triggers import Timer


@cocotb.test()
async def test_project(dut):
    """Test Cartesian to Cylindrical Conversion"""
    dut._log.info("Starting test")

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

        await Timer(10, units="ns")

        expected_r = int(math.sqrt(x**2 + y**2))
        expected_theta = int(math.degrees(math.atan2(y, x)))

        actual_r = int(dut.r.value.signed_integer)
        actual_theta = int(dut.theta.value.signed_integer)

        dut._log.info(f"Input (x, y) = ({x}, {y}) -> Output (r, θ) = ({actual_r}, {actual_theta})")
        assert actual_r == expected_r, f"Mismatch in r: expected {expected_r}, got {actual_r}"
        assert actual_theta == expected_theta, f"Mismatch in θ: expected {expected_theta}, got {actual_theta}"

    dut._log.info("All tests passed!")
