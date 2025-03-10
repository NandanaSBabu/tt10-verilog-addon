import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure
import random
import math

@cocotb.test()
async def test_cartesian_to_cylindrical(dut):
    """Test the Cartesian to Cylindrical Coordinate Conversion."""
    
    for _ in range(10):  # Run multiple test cases
        x = random.randint(-100, 100)
        y = random.randint(-100, 100)
        z = random.randint(-100, 100)
        
        # Expected outputs
        r_expected = int(math.sqrt(x**2 + y**2))
        theta_expected = int(math.atan2(y, x) * (180 / math.pi))  # Convert to degrees
        z_expected = z  # Z remains the same
        
        # Apply inputs
        dut.x.value = x
        dut.y.value = y
        dut.z.value = z
        
        await Timer(2, units='ns')  # Wait for processing
        
        # Check outputs
        r_actual = int(dut.r.value)
        theta_actual = int(dut.theta.value)
        z_actual = int(dut.z_out.value)
        
        # Allow small deviations due to integer rounding
        if not (r_expected - 1 <= r_actual <= r_expected + 1):
            raise TestFailure(f"Mismatch in r: expected {r_expected}, got {r_actual}")
        if not (theta_expected - 1 <= theta_actual <= theta_expected + 1):
            raise TestFailure(f"Mismatch in theta: expected {theta_expected}, got {theta_actual}")
        if z_expected != z_actual:
            raise TestFailure(f"Mismatch in z: expected {z_expected}, got {z_actual}")
        
        cocotb.log.info(f"Test passed for x={x}, y={y}, z={z}")
