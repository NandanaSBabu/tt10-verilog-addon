import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the tt_um_addon module"""
    
    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    
    # Release reset
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Enable module
    dut.ena.value = 1
    await RisingEdge(dut.clk)

    # Test case 1: 3,4 -> sqrt(3^2 + 4^2) = 5
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    expected = 5
    result = int(dut.uo_out.value)
    assert result == expected, f"Test failed! Expected {expected}, got {result}"

    # Test case 2: 7,24 -> sqrt(7^2 + 24^2) = 25
    dut.ui_in.value = 7
    dut.uio_in.value = 24
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    expected = 25
    result = int(dut.uo_out.value)
    assert result == expected, f"Test failed! Expected {expected}, got {result}"

    # Test case 3: 8,6 -> sqrt(8^2 + 6^2) = 10
    dut.ui_in.value = 8
    dut.uio_in.value = 6
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    expected = 10
    result = int(dut.uo_out.value)
    assert result == expected, f"Test failed! Expected {expected}, got {result}"

    cocotb.log.info("All test cases passed!")
