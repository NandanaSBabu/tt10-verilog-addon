import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    """Test the integer square root computation for (x^2+y^2)."""

    # Create and start the clock (10ns period => 100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut.rst_n.value = 0
    dut.ena.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Define test vectors: (ui_in, uio_in, expected sqrt)
    test_vectors = [
        (3, 4, 5),    # 9+16 = 25, sqrt=5
        (7, 24, 25),  # 49+576 = 625, sqrt=25
        (10,15,18),   # 100+225 = 325, sqrt=18 (integer part)
        (8, 6, 10),   # 64+36 = 100, sqrt=10
        (12,16,20)    # 144+256 = 400, sqrt=20
    ]

    for a, b, expected in test_vectors:
        dut.ui_in.value = a
        dut.uio_in.value = b
        # Wait enough clock cycles for the state machine to finish computation
        for _ in range(100):
            await RisingEdge(dut.clk)
        output = int(dut.uo_out.value)
        cocotb.log.info(f"For inputs x={a}, y={b}, computed sqrt={output}, expected={expected}")
        assert output == expected, f"Test failed for ({a}, {b}): Expected {expected}, got {output}"
        # Wait a bit before next test vector
        await Timer(50, units="ns")
