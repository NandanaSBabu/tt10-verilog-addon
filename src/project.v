/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated input X
    output wire [7:0] uo_out,   // Output (sqrt result)
    input  wire [7:0] uio_in,   // Dedicated input Y
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       ena,      // Always 1 when design is powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);

    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;
    reg [15:0] sqrt_result;

    // Squaring logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 16'b0;
            square_y <= 16'b0;
            sum_squares <= 16'b0;
        end else if (ena) begin
            square_x <= ui_in * ui_in;   // X^2
            square_y <= uio_in * uio_in; // Y^2
            sum_squares <= square_x + square_y; // Sum of squares
        end
    end

    // Iterative square root calculation using bitwise method
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sqrt_result <= 16'b0;
        end else if (ena) begin
            sqrt_result = 0;
            for (integer n = 15; n >= 0; n = n - 1) begin
                if ((sqrt_result | (1 << n)) * (sqrt_result | (1 << n)) <= sum_squares)
                    sqrt_result = sqrt_result | (1 << n);
            end
        end
    end

    // Assigning output (lower 8 bits of sqrt_result)
    assign uo_out = sqrt_result[7:0];
    assign uio_out = 8'b0; // Not used
    assign uio_oe = 8'b0;  // Not used

    // Prevent unused signal warnings
    wire _unused = &{ena, 1'b0};

endmodule
