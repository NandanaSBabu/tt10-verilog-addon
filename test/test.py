import cocotb
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_tt_um_addon(dut):
    """Test the tt_um_addon module"""
    
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    
    test_cases = [
        (3, 4, 5),
        (6, 8, 10),
        (20, 99, 101),
        (5, 12, 13),
        (7, 24, 25)
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)  
        assert dut.uo_out.value.integer == expected, f"Test failed: ({x}, {y}) -> got {dut.uo_out.value.integer}, expected {expected}"
