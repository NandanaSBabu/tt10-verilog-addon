import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test the square root computation."""
    
    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await Timer(10, units="ns")
    
    dut.rst_n.value = 1
    await Timer(10, units="ns")
    
    # Input x = 3, y = 4
    dut.ui_in.value = 3
    dut.uio_in.value = 4
    dut.ena.value = 1
    await Timer(10, units="ns")  # Give time for ena to register
    dut.ena.value = 0  # Clear enable

    # Wait for computation
    for _ in range(20):  # Wait sufficient clock cycles
        await Timer(10, units="ns")

    output = int(dut.uo_out.value)
    print(f"Debug: uo_out = {dut.uo_out.value.binstr}")  # Debugging
    expected = 5
    
    assert output == expected, f"Test failed! Expected {expected}, got {output}"
