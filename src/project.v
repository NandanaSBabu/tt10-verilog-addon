/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square root output
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] approx_sqrt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            approx_sqrt <= 8'd0;
        end else begin // ena signal is ignored as requested.
            sum_squares <= ui_in * ui_in + uio_in * uio_in;

            // Simple approximation: take the upper 8 bits.
            approx_sqrt <= sum_squares[15:8];

            // Optional refinement (example - tune for accuracy/area):
            if (sum_squares[7:0] > 8'h80) begin
                approx_sqrt <= approx_sqrt + 1;
            end

            uo_out <= approx_sqrt;
        end
    end

    // Prevent warnings for unused signals
    wire _unused = &{ena, 1'b0};

endmodule
