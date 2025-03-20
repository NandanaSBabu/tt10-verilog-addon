import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the square root computation"""
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    dut.ena.value = 1
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"

    dut.ui_in.value = 6
    dut.uio_in.value = 8
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 10, f"Test failed! Expected 10, got {dut.uo_out.value}"
