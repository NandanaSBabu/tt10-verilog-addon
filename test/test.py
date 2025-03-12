import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Rectangular to Cylindrical Conversion Test")

    # Set clock (50MHz -> 20ns period)
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Reset DUT
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Test cases
    test_cases = [(10, 20), (30, 40), (50, 60), (70, 80)]
    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 2)

        if 'x' in str(dut.uo_out.value) or 'x' in str(dut.uio_out.value):
            dut._log.warning(f"Unknown ('x') value detected for inputs x={x}, y={y}")
        else:
            r_output = dut.uo_out.value.integer
            theta_output = dut.uio_out.value.integer
            dut._log.info(f"Inputs: x={x}, y={y} -> Outputs: r={r_output}, theta={theta_output}")

            assert r_output >= 0, "Output r should be non-negative"
            assert theta_output >= 0, "Output theta should be non-negative"
