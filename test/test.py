import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.binary import BinaryValue

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1

    for _ in range(100):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    await Timer(100, units="ns")

    print(f"uo_out: {dut.uo_out.value}")
    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
