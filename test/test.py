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

    # Test case 1: x = 3, y = 4 (Expected sqrt(3^2 + 4^2) = 5)
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
    
    # Test case 2: x = 7, y = 24 (Expected sqrt(7^2 + 24^2) = 25)
    dut.ui_in.value = 7
    dut.uio_in.value = 24
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 25, f"Test failed! Expected 25, got {dut.uo_out.value}"

    # Test case 3: x = 10, y = 15 (Expected sqrt(10^2 + 15^2) = 18)
    dut.ui_in.value = 10
    dut.uio_in.value = 15
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 18, f"Test failed! Expected 18, got {dut.uo_out.value}"

    # Test case 4: x = 8, y = 6 (Expected sqrt(8^2 + 6^2) = 10)
    dut.ui_in.value = 8
    dut.uio_in.value = 6
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 10, f"Test failed! Expected 10, got {dut.uo_out.value}"

    cocotb.log.info("All test cases passed!")
