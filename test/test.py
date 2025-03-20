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
    dut.rst_n.value = 1  # Release reset
    dut.ena.value = 1

    # Test case: x=3, y=4 (expect sqrt(9+16) = 5)
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"

    # Test case: x=6, y=8 (expect sqrt(36+64) = 10)
    dut.ui_in.value = 6
    dut.uio_in.value = 8
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 10, f"Test failed! Expected 10, got {dut.uo_out.value}"

    # Test case: x=0, y=0 (expect sqrt(0) = 0)
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 0, f"Test failed! Expected 0, got {dut.uo_out.value}"
