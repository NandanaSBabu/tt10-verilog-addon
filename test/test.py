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

    # Test cases
    test_cases = [
        (3, 4, 5),     # sqrt(3^2 + 4^2) = 5
        (7, 24, 25),   # sqrt(7^2 + 24^2) = 25
        (10, 15, 18),  # sqrt(10^2 + 15^2) = ~18
        (8, 6, 10)     # sqrt(8^2 + 6^2) = 10
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        
        output = int(dut.uo_out.value)
        print(f"x = {x}, y = {y} -> Expected sqrt = {expected}, Got = {output}")
        assert output == expected, f"Test failed! Expected {expected}, got {output}"

    cocotb.log.info("All test cases passed!")
