# Tiny Tapeout Project: Square Root Pythagoras

## Overview
This project calculates the square root of the sum of squares of two 8-bit inputs, `x` and `y`, using the **Pythagorean theorem**. It computes:
- **sqrt_out**: Using \( \sqrt{x^2 + y^2} \), where `x` and `y` are inputs.
  
This design demonstrates the application of basic arithmetic functions to compute the distance in a 2D space, suitable for applications like sensor data processing and simple distance calculations.

## Hardware Implementation
### **Modules**
- `tt_um_addon`: Top module that handles the square root calculation using the sum of squares.
- `Square`: A custom function that calculates the square of a given input using repeated addition (to avoid multiplication).

### **Pin Mapping**
| Pin Name  | Description         |
|-----------|---------------------|
| `ui[7:0]` | 8-bit `x` input     |
| `uio[7:0]` | 8-bit `y` input     |
| `uo[7:0]` | 8-bit `sqrt_out` output  |

## Simulation & Testing
### **Software Simulation (Cocotb)**
1. Run `make test` to execute the testbench.
2. The test applies different `x` and `y` values.
3. Passes if computed `sqrt_out` matches expected results within a margin.

### **Hardware Testing**
1. Load the synthesized design onto an FPGA or TinyTapeout ASIC.
2. Provide binary inputs for `x` and `y`.
3. Verify `sqrt_out` output using an oscilloscope or logic analyzer.

## Constraints & Limitations
- **8-bit integer precision** may cause small rounding errors.
- **sqrt_out** output is limited to 8-bit representation.
- **No multiplication**: Used alternative methods like repeated addition.

## Applications
- **Sensor Data Processing**: Distance calculation from sensor data.
- **Robotics**: Simple 2D distance measurement.
- **Embedded Systems**: Efficient arithmetic without complex operations.

## Future Improvements
- Increase bit-width for higher precision.
- Implement floating-point calculations for better accuracy.
- Extend the design for 3D distance calculations (Pythagorean theorem in 3D).

### Author: **Joanna**
