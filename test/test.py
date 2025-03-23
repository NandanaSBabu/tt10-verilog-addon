import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Test case 1: 3^2 + 4^2 = 25, sqrt(25) = 5
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"

    # Test case 2: 7^2 + 24^2 = 625, sqrt(625) = 25
    dut.ui_in.value = 7
    dut.uio_in.value = 24
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 25, f"Test failed! Expected 25, got {dut.uo_out.value}"

    # Test case 3: 10^2 + 15^2 = 325, sqrt(325) = 18.027... Output is 18
    dut.ui_in.value = 10
    dut.uio_in.value = 15
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 18, f"Test failed! Expected 18, got {dut.uo_out.value}"

    # Test case 4: 8^2 + 6^2 = 100, sqrt(100) = 10
    dut.ui_in.value = 8
    dut.uio_in.value = 6
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 10, f"Test failed! Expected 10, got {dut.uo_out.value}"
