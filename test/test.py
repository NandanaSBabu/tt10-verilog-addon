import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    test_cases = [(10, 20), (30, 40), (50, 60), (70, 80)]
    
    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 2)

        r_output = dut.uo_out.value.integer
        theta_output = dut.uio_out.value.integer
        dut._log.info(f"Inputs: x={x}, y={y} -> Outputs: r={r_output}, theta={theta_output}")
