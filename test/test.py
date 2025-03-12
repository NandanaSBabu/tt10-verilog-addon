import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_rect_to_cyl(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    
    dut.rst_n.value = 1
    dut.ena.value = 1
    await RisingEdge(dut.clk)

    # Test cases
    test_cases = [
        (0, 0, 0, 0),   # r=0, theta=0
        (3, 4, 5, 12),  # r≈5, theta=12 (scaled)
        (5, 0, 5, 0),   # r=5, theta=0
        (0, 5, 5, 90),  # r=5, theta=90
        (8, 6, 10, 21)  # r≈10, theta=21 (scaled)
    ]

    for x, y, expected_r, expected_theta in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        actual_r = dut.uo_out.value.integer
        actual_theta = dut.uio_out.value.integer

        print(f"Input (x={x}, y={y}) -> r={actual_r}, theta={actual_theta}")
        assert actual_r == expected_r, f"Error: Expected r={expected_r}, got {actual_r}"
        assert actual_theta == expected_theta, f"Error: Expected theta={expected_theta}, got {actual_theta}"
