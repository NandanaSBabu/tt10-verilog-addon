/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;
    reg [15:0] result;
    reg [15:0] temp_sqrt;

    // Squaring function
    function [15:0] square;
        input [7:0] value;
        begin
            square = value * value;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 16'b0;
            square_y <= 16'b0;
            sum_squares <= 16'b0;
            temp_sqrt <= 16'b0;
            result <= 16'b0;
        end else if (ena) begin
            square_x <= square(ui_in);
            square_y <= square(uio_in);
            sum_squares <= square_x + square_y;
        end
    end

    // Square root approximation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_sqrt <= 16'b0;
            result <= 16'b0;
        end else if (ena) begin
            temp_sqrt = 0;
            for (integer n = 15; n >= 0; n = n - 1) begin
                if ((temp_sqrt | (1 << n)) * (temp_sqrt | (1 << n)) <= sum_squares)
                    temp_sqrt = temp_sqrt | (1 << n);
            end
            result <= temp_sqrt;
        end
    end

    assign uo_out = result[7:0]; // Output the computed sqrt value
    assign uio_out = 8'b0; // No output on uio_out
    assign uio_oe = 8'b0;  // All uio pins are set as inputs

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, 1'b0};

endmodule
