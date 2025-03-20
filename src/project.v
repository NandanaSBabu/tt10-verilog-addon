/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg  [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal registers for computation
    reg [15:0] sum_squares;
    reg [7:0] result;
    integer b;

    // Square function using repeated addition
    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            count = a;
            while (count > 0) begin
                s = s + a;  // Repeated addition
                count = count - 1;
            end
            square = s;
        end
    endfunction

    // Process on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else begin
            // Compute sum of squares without using multiplication
            sum_squares = square(ui_in) + square(uio_in);

            // Initialize result to 0 before starting square root calculation
            result = 0;

            // Bitwise approach to calculate square root
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end

            // Assign the result to uo_out
            uo_out <= result;
        end
    end

    // Unused ports assignments
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
