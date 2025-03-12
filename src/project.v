/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
module tt_um_rect_to_cyl (
    input  wire [7:0] ui_in,    // Dedicated inputs (x in [3:0], y in [7:4])
    output wire [7:0] uo_out,   // Dedicated outputs (r in [3:0], theta in [7:4])
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered, can be ignored
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    wire [3:0] x = ui_in[3:0];  // Lower 4 bits as x-coordinate
    wire [3:0] y = ui_in[7:4];  // Upper 4 bits as y-coordinate

    wire [5:0] r_approx = x + y;  // Approximation for r (replace with better calculation)
    wire [3:0] theta = (y > x) ? 4'b1001 : 4'b0101;  // Simple theta approximation

    assign uo_out[3:0] = r_approx[3:0]; // Assign r
    assign uo_out[7:4] = theta;         // Assign theta

    assign uio_out = 0;
    assign uio_oe  = 0;

    // List unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
