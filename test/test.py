import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    test_vectors = [
        (3, 4, 5),
        (7, 24, 25),
        (10, 15, 25),
        (8, 6, 10),
        (1, 1, 1),
        (20,21,29),
        (2,2,2)
    ]

    for x, y, expected_sqrt in test_vectors:
        dut.ui_in.value = x
        dut.uio_in.value = y
        dut.ena.value = 1

        for _ in range(500):  # Increase simulation cycles
            await RisingEdge(dut.clk)

        dut.ena.value = 0
        await Timer(200, units="ns")

        actual_sqrt = dut.uo_out.value
        print(f"x={x}, y={y}, expected={expected_sqrt}, actual={actual_sqrt}")
        print(f"num={dut.num.value}, result={dut.result.value}, b={dut.b.value}, state={dut.state.value}")
        assert actual_sqrt == expected_sqrt, f"Test failed for x={x}, y={y}. Expected {expected_sqrt}, got {actual_sqrt}"
