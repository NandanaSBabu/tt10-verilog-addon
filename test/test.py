import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure
import math

@cocotb.test()
async def test_cartesian_to_cylindrical(dut):
    """Test Rectangular to Cylindrical Conversion"""
    
    # Set initial values
    dut.x.value = 0
    dut.y.value = 0
    dut.z.value = 0
    
    # Wait for some time
    await Timer(10, units="ns")

    # Define test cases (x, y, z) -> Expected (r, theta, z)
    test_cases = [
        (3, 4, 5, 5, math.atan2(4, 3), 5),  # (3,4,5) -> (5, 0.927, 5)
        (1, 1, 2, math.sqrt(2), math.atan2(1, 1), 2),
        (0, 5, -3, 5, math.atan2(5, 0), -3),
        (-4, -4, 1, math.sqrt(32), math.atan2(-4, -4), 1),
    ]

    for x, y, z, expected_r, expected_theta, expected_z in test_cases:
        dut.x.value = x
        dut.y.value = y
        dut.z.value = z

        await Timer(10, units="ns")  # Wait for response

        # Read outputs
        r = dut.r.value.signed_integer
        theta = dut.theta.value.signed_integer
        z_out = dut.z_out.value.signed_integer  # Assuming your output signal for z

        # Verify results (theta scaled by a factor if fixed-point representation is used)
        theta_scaled = expected_theta if abs(expected_theta) < 3.14 else expected_theta - 6.28  # Adjust for 2π wrapping

        # Allow small tolerance for rounding errors
        r_tolerance = 1
        theta_tolerance = 0.1

        if abs(r - expected_r) > r_tolerance or abs(theta - theta_scaled) > theta_tolerance or z_out != expected_z:
            raise TestFailure(
                f"Test failed for x={x}, y={y}, z={z} -> r={r}, theta={theta}, z_out={z_out}, expected: ({expected_r}, {expected_theta}, {expected_z})"
            )
        else:
            cocotb.log.info(f"Passed: x={x}, y={y}, z={z} -> r={r}, theta={theta}, z_out={z_out}")

    cocotb.log.info("All test cases passed!")
