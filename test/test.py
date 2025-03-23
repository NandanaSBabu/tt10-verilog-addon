import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1
    dut.rst_n.value = 0
    await Timer(10, units="ns")
    dut.rst_n.value = 1
    await Timer(100, units="ns")  # Ensure time for computation

    print(f"x = {dut.ui_in.value}, y = {dut.uio_in.value}, sqrt_out = {dut.uo_out.value}")

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
