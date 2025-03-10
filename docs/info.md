## How it works

This project converts Cartesian coordinates (x, y) to Cylindrical coordinates (r, θ). It takes x and y as inputs and computes:
- **r**: The radial distance using \( r = \sqrt{x^2 + y^2} \)
- **θ (theta)**: The angle using \( \theta = \tan^{-1}(y / x) \), converted to degrees.

This conversion helps in representing 2D positions in polar form.

## How to test

### Simulation using Cocotb:
1. Run `make test` to execute the testbench.
2. The test applies random `x` and `y` values and verifies if the computed `r` and `θ` are correct.
3. The test passes if results match expected values within a small margin.

### Hardware verification:
1. Load the synthesized design onto an FPGA or ASIC.
2. Provide binary inputs for `x` and `y` values.
3. Verify `r` and `θ` outputs using an oscilloscope or logic analyzer.

## External hardware

- No additional external hardware is required apart from an FPGA or ASIC testing setup.

## Constraints

- **4-bit input limitation:** The `x` and `y` values are limited to a 4-bit range.
- **Integer-based calculations:** Small errors may occur due to rounding.
- **Limited θ representation:** The angle is in degrees but restricted to a 4-bit format.
- **No z-axis conversion:** This version does not account for the z-component.

## Applications

- **Robotics:** Position tracking using polar coordinates.
- **Signal Processing:** Coordinate transformations in image processing.
- **Navigation Systems:** Converting GPS Cartesian data to polar form for pathfinding.

## Future improvements

- Increase bit-width for higher precision.
- Implement floating-point calculations for better accuracy.
- Extend functionality to support full 3D conversion (Cartesian to Spherical).

