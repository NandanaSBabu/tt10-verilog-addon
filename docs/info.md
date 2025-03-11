# Tiny Tapeout Project: Rectangular to Cylindrical Conversion

## Overview
This project performs coordinate transformation from **Rectangular (Cartesian) to Cylindrical coordinates** using **Verilog**. It takes 8-bit inputs `x`, `y`, and `z`, and computes:
- **r (radius)**: Using \( r = \sqrt{x^2 + y^2} \)
- **θ (theta)**: Using \( 	heta = 	an^{-1}(y / x) \), represented in degrees
- **z_out**: Passes `z` unchanged

This conversion helps in robotics, navigation, and signal processing applications.

## Hardware Implementation
### **Modules**
- `tt_um_project`: Top module integrating all operations.
- `SquareRoot`: Computes \( \sqrt{x^2 + y^2} \) using a lookup table and approximation.
- `ArctanLUT`: Uses a lookup table for **arctan(y/x)** calculation.

### **Pin Mapping**
| Pin Name | Description |
|----------|-------------|
| `ui[7:0]` | 8-bit `x` input |
| `ui[15:8]` | 8-bit `y` input |
| `ui[23:16]` | 8-bit `z` input |
| `uo[7:0]` | 8-bit `r` output |
| `uo[15:8]` | 8-bit `θ` output |
| `uo[23:16]` | 8-bit `z_out` output |

## Simulation & Testing
### **Software Simulation (Cocotb)**
1. Run `make test` to execute the testbench.
2. The test applies different `x`, `y`, and `z` values.
3. Passes if computed values match expected results within a margin.

### **Hardware Testing**
1. Load the synthesized design onto an FPGA or TinyTapeout ASIC.
2. Provide binary inputs for `x`, `y`, `z`.
3. Verify `r`, `θ`, `z_out` outputs using an oscilloscope or logic analyzer.

## Constraints & Limitations
- **8-bit integer precision** may cause small rounding errors.
- **θ (angle) limited to 8-bit representation.**
- **Fixed lookup table for square root and arctan calculations.**

## Applications
- **Robotics**: Position tracking in cylindrical coordinates.
- **Navigation**: GPS coordinate transformations.
- **Signal Processing**: Geometric transformations in image processing.

## Future Improvements
- Increase bit-width for higher precision.
- Implement floating-point calculations for better accuracy.
- Extend the design for **Cartesian to Spherical** conversion.

### Author: **Nandana**

