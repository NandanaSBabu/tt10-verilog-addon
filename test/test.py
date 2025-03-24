import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    """Test the integer square root computation for (x^2 + y^2)."""

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ena.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1

    test_vectors = [
        (3, 4, 5),
        (7, 24, 25),
        (10, 15, 18),
        (8, 6, 10),
        (12, 16, 20)
    ]

    for a, b, expected in test_vectors:
        dut.ui_in.value = a
        dut.uio_in.value = b

        # Increase the delay before the assert statement.
        for _ in range(10000): #wait for 100,000ns.
            await RisingEdge(dut.clk)
        
        output = int(dut.uo_out.value)
        cocotb.log.info(f"Time: {cocotb.utils.get_sim_time('ns')}ns, For inputs x={a}, y={b}, computed sqrt={output}, expected={expected}")
        assert output == expected, f"Test failed for (x={a}, y={b}): Expected {expected}, got {output}"

    await Timer(500, units="ns")
