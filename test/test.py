# test.py

import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
import math

@cocotb.test()
async def test_project(dut):
    """Test sqrt calculation logic"""

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    test_cases = [
        (3, 4),
        (7, 24),
        (10, 15),
        (8, 6)
    ]

    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(20, units="ns")
    dut.rst_n.value = 1
    await Timer(30, units="ns")

    dut.ena.value = 1

    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await Timer(100, units="ns")

        output = dut.uo_out.value.integer
        expected = int(math.sqrt(x*x + y*y))
        cocotb.log.info(f"Time = {cocotb.utils.get_sim_time()} ns | x = {x} | y = {y} | sqrt_out = {output} | expected = {expected}")
        assert output == expected, f"sqrt({x}^2 + {y}^2) failed: got {output}, expected {expected}"
