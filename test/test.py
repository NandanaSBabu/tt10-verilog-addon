import cocotb
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_project(dut):
    """Test the tt_um_addon module"""

    test_cases = [
        (3, 4, 5),   # sqrt(3^2 + 4^2) = 5
        (7, 24, 25), # sqrt(7^2 + 24^2) = 25
    ]

    dut.rst_n.value = 0  # Apply reset
    await Timer(10, units="ns")
    dut.rst_n.value = 1  # Release reset

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await RisingEdge(dut.clk)  # Wait for a clock edge
        await Timer(10, units="ns")  # Allow time for output to settle

        result = int(dut.uo_out.value)
        print(f"DEBUG: x={x}, y={y}, expected={expected}, got={result}")

        assert result == expected, f"Test failed! Expected {expected}, got {result}"
