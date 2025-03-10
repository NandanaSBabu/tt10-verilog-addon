## How it works

This project performs a conversion from Cartesian coordinates (x, y) to Cylindrical coordinates (r, θ). It takes in the x and y values as inputs and computes:
- **r**: The radial distance using the formula \( r = \sqrt{x^2 + y^2} \)
- **θ (theta)**: The angle using \( \theta = \tan^{-1}(y / x) \) converted to degrees.

The conversion allows easy representation of 2D positions in polar form.

## How to test

1. **Simulation using Cocotb:**
   - Run the testbench with `make test`.
   - The test will apply random values of `x` and `y` and check whether the computed `r` and `θ` match expected values.
   - If the results match within a small margin, the test passes.

2. **Hardware verification:**
   - Load the synthesized design onto the FPGA or ASIC.
   - Provide binary inputs representing `x` and `y` values.
   - Verify the output `r` and `θ` using an oscilloscope or logic analyzer.

## External hardware

- This project does not require additional external hardware apart from a suitable FPGA or ASIC testing environment.

## Constraints

- The inputs `x` and `y` are 4-bit values, limiting the coordinate range.
- Integer-based calculations introduce small errors due to rounding.
- The angle output is in degrees but represented in a limited 4-bit format.

## Applications

- Robotics: Position tracking using polar coordinates.
- Signal processing: Coordinate transformations in image processing.
- Navigation systems: Converting GPS Cartesian data to polar form for pathfinding.

## Future improvements

- Increase bit-width to support higher precision.
- Implement floating-point calculations for improved accuracy.
- Extend to full 3D conversion (Cartesian to Spherical).

