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
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Test different input values
    test_cases = [(10, 20), (30, 40), (50, 60), (70, 80)]
    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 2)
        dut._log.info(f"Inputs: x={x}, y={y} -> Outputs: r={dut.uo_out.value}, theta={dut.uio_out.value}")

    # Final test case to check stability
    dut.ui_in.value = 100
    dut.uio_in.value = 200
    await ClockCycles(dut.clk, 5)
    dut._log.info(f"Final Inputs: x=100, y=200 -> Outputs: r={dut.uo_out.value}, theta={dut.uio_out.value}")
