/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,    // X input
    output wire [7:0] uo_out,   // Approximate square root output
    input  wire [7:0] uio_in,   // Y input
    output wire [7:0] uio_out,  // Not used
    output wire [7:0] uio_oe,   // Not used
    input  wire       ena,      // Always 1 when powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active low reset
);

    assign uio_out = 8'b00000000; // No output on bidirectional pins
    assign uio_oe  = 8'b00000000; // IOs are inputs only

    reg [15:0] sum_squares;
    reg [15:0] estimate;
    reg [15:0] b;
    reg [7:0]  sqrt_approx;
    reg [7:0]  out_reg;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            estimate    <= 0;
            b           <= 0;
            sqrt_approx <= 0;
            out_reg     <= 0;
        end else begin
            // Calculate sum of squares
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);

            // Initialize variables
            estimate <= 0;
            b <= 16'h4000;

            // Adjust b to a valid range
            for (i = 0; i < 15; i = i + 1) begin
                if (b > sum_squares)
                    b = b >> 2;
            end

            // Approximate square root
            for (i = 0; i < 15; i = i + 1) begin
                if (b != 0) begin
                    if (sum_squares >= (estimate + b)) begin
                        sum_squares = sum_squares - (estimate + b);
                        estimate = (estimate >> 1) + b;
                    end else begin
                        estimate = estimate >> 1;
                    end
                    b = b >> 2;
                end
            end

            sqrt_approx <= estimate[7:0];
            out_reg <= sqrt_approx;
        end
    end

    assign uo_out = out_reg;

    // Avoid unused signal warnings
    wire _unused = &{ena, 1'b0};

endmodule
