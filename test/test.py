import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test the tt_um_addon module"""
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    await Timer(20, units="ns")

    result = int(dut.uo_out.value)
    expected = 5  # sqrt(3^2 + 4^2) = 5
    assert result == expected, f"Test failed! Expected {expected}, got {result}"

    dut.ui_in.value = 7
    dut.uio_in.value = 24
    await Timer(20, units="ns")

    result = int(dut.uo_out.value)
    expected = 25  # sqrt(7^2 + 24^2) = 25
    assert result == expected, f"Test failed! Expected {expected}, got {result}"
