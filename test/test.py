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

    # Test case 3: 0^2 + 0^2 = 0, sqrt(0) = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 0, f"Test failed! Expected 0, got {dut.uo_out.value}"

    # Test case 4: 1^2 + 0^2 = 1, sqrt(1) = 1
    dut.ui_in.value = 1
    dut.uio_in.value = 0
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 1, f"Test failed! Expected 1, got {dut.uo_out.value}"

    # Test case 5: 0^2 + 1^2 = 1, sqrt(1) = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 1
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 1, f"Test failed! Expected 1, got {dut.uo_out.value}"

    # Test case 6: 5^2 + 12^2 = 169, sqrt(169) = 13
    dut.ui_in.value = 5
    dut.uio_in.value = 12
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 13, f"Test failed! Expected 13, got {dut.uo_out.value}"

    # Test case 7: max value of 7 bit input, should not overflow.
    dut.ui_in.value = 127
    dut.uio_in.value = 127
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)
    dut.ena.value = 0

    assert dut.uo_out.value == 179, f"Test failed! Expected 179, got {dut.uo_out.value}"

    # Test Case 8: boundary case
    dut.ui_in.value = 1
    dut.uio_in.value = 1
    dut.ena.value = 1

    for _ in range(40):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    assert dut.uo_out.value == 1, f"Test failed! Expected 1, got {dut.uo_out.value}"
