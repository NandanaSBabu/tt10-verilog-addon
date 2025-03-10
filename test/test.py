import cocotb
from cocotb.triggers import Timer
import math

@cocotb.test()
async def test_cartesian_to_cylindrical(dut):
    """Test the Cartesian to Cylindrical Coordinate Conversion."""
    
    for x, y in [(1, 0), (1, 1), (2, 1), (3, 2), (4, 3), (0, 4)]:
        dut.x.value = x
        dut.y.value = y
        dut.reset.value = 1
        await Timer(5, units='ns')
        dut.reset.value = 0
        await Timer(10, units='ns')

        # Expected values
        r_expected = (x + (y >> 1)) if x > y else (y + (x >> 1))
        theta_expected = int(math.atan2(y, x) * (180 / math.pi))  # Convert to degrees
        
        # Read outputs
        r_actual = dut.r.value.integer
        theta_actual = dut.theta.value.integer
        
        assert r_actual == r_expected, f"Mismatch in r: expected {r_expected}, got {r_actual}"
        assert abs(theta_actual - theta_expected) <= 1, f"Mismatch in theta: expected {theta_expected}, got {theta_actual}"
        
        cocotb.log.info(f"Test passed for x={x}, y={y}, r={r_actual}, theta={theta_actual}")
