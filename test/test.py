import cocotb
from cocotb.triggers import Timer
import math
import random

@cocotb.test()
async def test_cartesian_to_cylindrical(dut):
    """Test Cartesian to Cylindrical coordinate conversion"""

    for _ in range(20):  # Run multiple test cases
        # Generate random 8-bit values for x, y, z
        x = random.randint(0, 255)
        y = random.randint(0, 255)
        z = random.randint(0, 255)

        # Apply inputs
        dut.ui.value = (z << 16) | (y << 8) | x  # Combine x, y, z into the input bus

        await Timer(2, units="ns")  # Wait for processing

        # Extract outputs
        r = dut.uo.value & 0xFF  # Lower 8 bits for r
        theta = (dut.uo.value >> 8) & 0xFF  # Next 8 bits for theta
        z_out = (dut.uo.value >> 16) & 0xFF  # Extract z_out from upper bits

        # Expected values
        expected_r = min(int(math.sqrt(x**2 + y**2)), 255)  # Clamp to 8-bit range
        expected_theta = min(int(math.degrees(math.atan2(y, x))), 255)  # Convert atan2 result
        expected_z = z

        # Check results
        assert r == expected_r, f"Failed: x={x}, y={y}, expected r={expected_r}, got {r}"
        assert theta == expected_theta, f"Failed: x={x}, y={y}, expected θ={expected_theta}, got {theta}"
        assert z_out == expected_z, f"Failed: z={z}, expected z={expected_z}, got {z_out}"

        cocotb.log.info(f"PASS: x={x}, y={y}, z={z} -> r={r}, θ={theta}, z={z_out}")
