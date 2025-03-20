import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test square root calculation"""
    
    # Reset the DUT
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1  # Release reset
    await RisingEdge(dut.clk)

    # Enable processing
    dut.ena.value = 1

    # Define test cases (x, y, expected sqrt(x^2 + y^2))
    test_cases = [
        (3, 4, 5),    # sqrt(3² + 4²) = 5
        (7, 24, 25),  # sqrt(7² + 24²) = 25
        (10, 15, 18), # sqrt(10² + 15²) ≈ 18
        (8, 6, 10),   # sqrt(8² + 6²) = 10
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)  # Wait for the clock cycle
        await RisingEdge(dut.clk)  # Allow processing time

        result = int(dut.uo_out.value)
        cocotb.log.info(f"x={x}, y={y}, expected={expected}, got={result}")

        assert result == expected, f"Test failed! Expected {expected}, got {result}"
