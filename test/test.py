import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the square root computation"""

    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1  # Release reset
    await RisingEdge(dut.clk)
    dut.ena.value = 1  # Enable computation

    # Test case 1: sqrt(3^2 + 4^2) = 5
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"

    # Test case 2: sqrt(6^2 + 8^2) = 10
    dut.ui_in.value = 6
    dut.uio_in.value = 8
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 10, f"Test failed! Expected 10, got {dut.uo_out.value}"

    # Test case 3: sqrt(5^2 + 12^2) = 13
    dut.ui_in.value = 5
    dut.uio_in.value = 12
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 13, f"Test failed! Expected 13, got {dut.uo_out.value}"
