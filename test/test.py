import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset phase
    dut._log.info("Reset")
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0  # Assert reset (active low)
    await ClockCycles(dut.clk, 10)  # Wait for 10 clock cycles
    dut.rst_n.value = 1  # Deassert reset

    # Test cases
    test_cases = [
        (0, 0, 0),
        (3, 4, 5),
        (6, 8, 10),
        (5, 12, 13),
        (8, 6, 10),
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 5)
        assert dut.uo_out.value == expected, f"Expected {expected}, got {dut.uo_out.value}"
        dut._log.info(f"Test passed for x={x}, y={y}, sqrt_out={dut.uo_out.value}")

    dut._log.info("All test cases passed!")
