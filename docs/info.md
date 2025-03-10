<!---
This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The module converts **Cartesian coordinates (x, y, z)** into **Cylindrical coordinates (r, θ, z)**.  
It calculates:
- **r = sqrt(x² + y²)**
- **θ = atan2(y, x)**
- **z remains unchanged**  

This is done using Verilog arithmetic operations.

## How to test

1. Run **Icarus Verilog (iverilog)** to compile the design.
2. Use **Cocotb** for simulation.
3. Verify outputs for given Cartesian inputs using test cases.
4. Expected results:
   - r should be correctly calculated using `sqrt(x² + y²)`.
   - θ should match `atan2(y, x)`.
   - z output should be equal to the input z.

## External hardware

This module is designed to be used in FPGA implementations.  
Potential use cases:
- **Robotics** (converting sensor data from Cartesian to Cylindrical)
- **3D Graphics** (coordinate transformations)
- **Control Systems** (for motors operating in polar coordinates)

