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

    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1  # Enable calculation

    # Wait for the calculation to complete (adjust time as needed)
    for _ in range(20): # increased the number of clock cycles.
        await RisingEdge(dut.clk)

    dut.ena.value = 0 # disable calculation.

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
