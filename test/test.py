# test_project.py (cocotb testbench)
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="ns")  # Create a 10ns period clock
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0  # Reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1  # Release reset

    # Test case 1: 3^2 + 4^2 = 25, sqrt(25) = 5
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1  # Enable calculation

    # Wait for the calculation to complete (adjust time as needed)
    for _ in range(20): # increased the number of clock cycles.
        await RisingEdge(dut.clk)

    dut.ena.value = 0 # disable calculation.

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"

    # Test case 2: 7^2 + 24^2 = 625, sqrt(625) = 25, output = 25[7:0]=25.
    dut.ui_in.value = 7
    dut.uio_in.value = 24
    dut.ena.value = 1
    for _ in range(20):
        await RisingEdge(dut.clk)
    dut.ena.value = 0

    assert dut.uo_out.value == 25, f"Test failed! Expected 25, got {dut.uo_out.value}"
