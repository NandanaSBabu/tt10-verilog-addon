import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test the square root computation"""
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1
    dut.rst_n.value = 0  # Reset
    await Timer(5, units="ns")
    dut.rst_n.value = 1  # Release reset
    await Timer(50, units="ns")  # Wait for computation

    # Debug prints
    print(f"x = {dut.ui_in.value}, y = {dut.uio_in.value}, sqrt_out = {dut.uo_out.value}")

    # Expect sqrt(3^2 + 4^2) = sqrt(9 + 16) = sqrt(25) = 5
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
