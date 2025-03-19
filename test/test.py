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

    # Test logic for XOR and AND gate implementation
    dut._log.info("Testing XOR and AND logic")

    # Set inputs
    test_cases = [
        (0, 0, 0, 0),  # (A, B) -> (A^B, A&B)
        (0, 1, 1, 0),
        (1, 0, 1, 0),
        (1, 1, 0, 1),
    ]

    for a, b, expected_xor, expected_and in test_cases:
        dut.ui_in.value = (b << 1) | a  # Assign A to bit 0, B to bit 1
        await ClockCycles(dut.clk, 1)

        assert dut.uo_out.value & 0x01 == expected_xor, f"XOR failed for A={a}, B={b}"
        assert (dut.uo_out.value >> 1) & 0x01 == expected_and, f"AND failed for A={a}, B={b}"

    dut._log.info("All tests passed!")

