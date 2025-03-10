import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_cartesian_to_cylindrical(dut):
    """Test Cartesian to Cylindrical conversion"""
    
    # Create a clock on the clk signal
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Initialize inputs
    dut.ena.value = 1  # Enable the module
    dut.x.value = 0
    dut.y.value = 0

    # Apply test cases with rising edge synchronization
    for x, y in [(1, 0), (1, 1), (2, 1), (4, 2), (8, 8)]:
        dut.x.value = x
        dut.y.value = y
        await RisingEdge(dut.clk)  # Wait for the clock edge
        await RisingEdge(dut.clk)  # Allow time for the computation

        r_val = dut.r.value.integer
        theta_val = dut.theta.value.integer
        print(f"x={x}, y={y} -> r={r_val}, theta={theta_val}")
