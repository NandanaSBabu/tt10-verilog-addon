# Tiny Tapeout Project Information

## How it Works
This project converts Cartesian coordinates (x, y, z) to Cylindrical coordinates (r, θ, z). It takes x, y, and z as inputs and computes:
- **r**: The radial distance using \( r = \sqrt{x^2 + y^2} \)
- **θ (theta)**: The angle using \( \theta = \tan^{-1}(y / x) \), converted to degrees.
- **z**: The height remains unchanged.

This conversion helps in representing 3D positions in a cylindrical form.

## How to Test

### Simulation using Cocotb:
1. Run `make test` to execute the testbench.
2. The test applies random `x`, `y`, and `z` values and verifies if the computed `r`, `θ`, and `z` are correct.
3. The test passes if results match expected values within a small margin.

### Hardware Verification:
1. Load the synthesized design onto an FPGA or ASIC.
2. Provide binary inputs for `x`, `y`, and `z` values.
3. Verify `r`, `θ`, and `z` outputs using an oscilloscope or logic analyzer.

## External Hardware
- No additional external hardware is required apart from an FPGA or ASIC testing setup.

## Constraints
- **8-bit input limitation:** The `x`, `y`, and `z` values are limited to an 8-bit range.
- **Integer-based calculations:** Small errors may occur due to rounding.
- **Limited θ representation:** The angle is in degrees but restricted to an 8-bit format.

## Applications
- **Robotics:** Position tracking using cylindrical coordinates.
- **Signal Processing:** Coordinate transformations in image processing.
- **Navigation Systems:** Converting GPS Cartesian data to cylindrical form for pathfinding.

## Future Improvements
- Increase bit-width for higher precision.
- Implement floating-point calculations for better accuracy.
- Extend functionality to support full 3D conversion (Cartesian to Spherical).
