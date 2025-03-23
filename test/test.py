import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the square root computation."""

    # Reset logic
    dut.rst_n.value = 0
    dut.ena.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Test case 1: x = 3, y = 4
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    
    cocotb.log.info(f"x = {dut.ui_in.value}, y = {dut.uio_in.value}, sqrt_out = {dut.uo_out.value}")

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
