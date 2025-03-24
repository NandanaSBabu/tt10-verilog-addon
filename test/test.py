import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test the square root module without assertions"""

    test_cases = [
        (3, 4),
        (7, 24),
        (10, 15),
        (8, 6)
    ]

    # Reset
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1
    dut.ena.value = 1

    for a, b in test_cases:
        dut.ui_in.value = a
        dut.uio_in.value = b
        await Timer(50, units="ns")  # Wait for calculation

        output = dut.uo_out.value.integer
        cocotb.log.info(f"Time: {cocotb.utils.get_sim_time('ns')}ns | x={a}, y={b}, sqrt_out={output}")
