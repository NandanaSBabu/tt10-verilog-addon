import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test the tt_um_addon module"""

    test_cases = [
        (3, 4, 5),   # sqrt(3^2 + 4^2) = 5
        (7, 24, 25), # sqrt(7^2 + 24^2) = 25
        (10, 15, 18), # sqrt(10^2 + 15^2) = 18
        (8, 6, 10)   # sqrt(8^2 + 6^2) = 10
    ]

    for x, y, expected in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await Timer(20, units="ns")

        result = int(dut.uo_out.value)
        print(f"DEBUG: x={x}, y={y}, expected={expected}, got={result}")

        assert result == expected, f"Test failed! Expected {expected}, got {result}"
