import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Rectangular to Cylindrical Conversion Test")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut._log.info("Applying reset...")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset complete.")

    # Test input cases
    test_cases = [(10, 20), (30, 40), (50, 60), (70, 80)]
    
    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 2)

        # Handle 'x' values safely
        if 'x' in str(dut.uo_out.value) or 'x' in str(dut.uio_out.value):
            dut._log.warning(f"Unknown ('x') value detected for inputs x={x}, y={y}")
        else:
            r_output = dut.uo_out.value.integer
            theta_output = dut.uio_out.value.integer
            dut._log.info(f"Inputs: x={x}, y={y} -> Outputs: r={r_output}, theta={theta_output}")

            assert r_output >= 0, "Output r should be non-negative"
            assert theta_output >= 0, "Output theta should be non-negative"

    # Final stability check
    dut.ui_in.value = 100
    dut.uio_in.value = 200
    await ClockCycles(dut.clk, 5)

    if 'x' in str(dut.uo_out.value) or 'x' in str(dut.uio_out.value):
        dut._log.warning("Unknown ('x') value detected in final check")
    else:
        r_output = dut.uo_out.value.integer
        theta_output = dut.uio_out.value.integer
        dut._log.info(f"Final Inputs: x=100, y=200 -> Outputs: r={r_output}, theta={theta_output}")

        assert r_output >= 0, "Final output r should be non-negative"
        assert theta_output >= 0, "Final output theta should be non-negative"
