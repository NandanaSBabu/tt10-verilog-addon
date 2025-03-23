import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the square root computation."""

    # Reset logic
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)  
    await RisingEdge(dut.clk)  #Extra cycle to ensure reset is applied
    dut.rst_n.value = 1
    dut.ena.value = 1
    await RisingEdge(dut.clk)  # Allow hardware to settle

    # Helper function to test a case
    async def run_test(x, y, expected):
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)  # Extra cycle for computation

        # Log values for debugging
        cocotb.log.info(f"Test case: x={x}, y={y}, Expected sqrt={expected}, Got={dut.uo_out.value}")

        assert dut.uo_out.value == expected, f"Test failed! Expected {expected}, got {dut.uo_out.value}"

    # Test cases
    await run_test(3, 4, 5)    # sqrt(3² + 4²) = 5
    await run_test(7, 24, 25)  # sqrt(7² + 24²) = 25
    await run_test(10, 15, 18) # sqrt(10² + 15²) = 18
    await run_test(8, 6, 10)   # sqrt(8² + 6²) = 10

    cocotb.log.info("All test cases passed successfully!")
