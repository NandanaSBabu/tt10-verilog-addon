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

    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1

    for _ in range(50):
        await RisingEdge(dut.clk)

    dut.ena.value = 0

    print(f"uo_out: {dut.uo_out.value}")
    print(f"num: {dut.debug_num.value}")
    print(f"result: {dut.debug_result.value}")
    print(f"b: {dut.debug_b.value}")
    print(f"state: {dut.debug_state.value}")
    print(f"ena: {dut.debug_ena.value}")
    print(f"rst_n: {dut.debug_rst_n.value}")

    assert dut.uo_out.value == 5, f"Test failed! Expected 5, got {dut.uo_out.value}"
