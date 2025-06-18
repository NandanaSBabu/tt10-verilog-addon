# Magnitude Calculator

## How it works

This project implements an approximate magnitude calculator for 2D vectors. Given inputs x and y (the vector components), it approximates the magnitude (length) of the vector using the formula:

```
magnitude ≈ max(x, y) + (min(x, y) >> 1) - 1
```

This approximation is faster than computing the exact magnitude (√(x² + y²)) and provides a good approximation for many applications. The algorithm avoids the need for multiplication, division, or square root operations, making it suitable for simple hardware implementation.

The design uses an 8-bit datapath for each component, with the following pipeline stages:
1. Register input values
2. Compute max and min values
3. Calculate the approximation formula
4. Output the result

## How to test

To test the magnitude calculator:
1. Apply 8-bit values to the inputs:
   - x-component goes to ui_in[7:0]
   - y-component goes to uio_in[7:0]
2. The approximated magnitude will appear on uo_out[7:0]

You can compare the output with the true magnitude calculated as sqrt(x² + y²). The approximation works best for vectors where one component is significantly larger than the other.

### Test vectors for verification:
| x | y | Approx. Magnitude | True Magnitude | Error |
|---|---|-------------------|----------------|-------|
| 3 | 4 | 5                 | 5              | 0%    |
| 5 | 12| 18                | 13             | 38%   |
| 100|100| 149              | 141            | 6%    |
| 0 | 0 | 0                 | 0              | 0%    |

## External hardware

No external hardware is required to use this module. It's a purely digital implementation that performs calculations based on the input signals. The design has been optimized for minimal area usage while still providing reasonable accuracy for magnitude approximation.

## Applications

This type of fast magnitude approximation is useful in:
- Digital signal processing
- Computer graphics
- Game development
- Simple collision detection
- Signal strength estimation
