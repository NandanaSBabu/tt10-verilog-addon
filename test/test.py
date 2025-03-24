import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_project(dut):
    """Test sqrt calculation logic"""
    
    test_cases = [
        (3, 4),   # Expected sqrt = 5
        (7, 24),  # Expected sqrt = 25
        (10, 15), # Expected sqrt = 18
        (8, 6)    # Expected sqrt = 10
    ]

    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(20, units="ns")  # ✅ Wait for reset
    dut.rst_n.value = 1
    await Timer(10, units="ns")

    dut.ena.value = 1  # ✅ Enable calculations

    for x, y in test_cases:
        dut.ui_in.value = x
        dut.uio_in.value = y
        await Timer(50, units="ns")  # ✅ Wait before reading `uo_out`
        
        output = dut.uo_out.value.integer
        print(f"Time = {cocotb.utils.get_sim_time()} ns | x = {x} | y = {y} | sqrt_out = {output}")

