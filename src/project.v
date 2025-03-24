/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

module tt_um_addon (
    input  wire [7:0] ui_in,     // x input
    input  wire [7:0] uio_in,    // y input
    output reg  [7:0] uo_out,    // sqrt output (integer)
    output wire [7:0] uio_out,   // Unused IO output
    output wire [7:0] uio_oe,    // Unused IO enable (0 = input)
    input  wire       ena,       // Enable signal
    input  wire       clk,       // Clock
    input  wire       rst_n      // Active-low reset
);

    // Internal registers for binary search
    reg [15:0] sum_squares;  // Sum = ui_in^2 + uio_in^2
    reg [7:0]  low, high, mid, result;
    reg [2:0]  state;        // State machine variable

    // State encoding:
    // 0: Compute sum_squares.
    // 1: Initialize binary search (set low and high).
    // 2: Compute mid = (low+high)>>1.
    // 3: Compare mid^2 with sum_squares and update low/high/result.
    // 4: Check termination (low > high); if done, output result.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'd0;
            low         <= 8'd0;
            high        <= 8'd0;
            mid         <= 8'd0;
            result      <= 8'd0;
            uo_out      <= 8'd0;
            state       <= 3'd0;
        end else if (ena) begin
            case (state)
                3'd0: begin
                    // Compute sum of squares
                    sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
                    state <= 3'd1;
                end
                3'd1: begin
                    // Initialize binary search
                    low    <= 8'd0;
                    high   <= 8'd255;
                    result <= 8'd0;
                    state  <= 3'd2;
                end
                3'd2: begin
                    // Compute mid
                    mid <= (low + high) >> 1;
                    state <= 3'd3;
                end
                3'd3: begin
                    // Compare mid^2 with sum_squares
                    if (mid * mid <= sum_squares) begin
                        result <= mid;      // Record candidate
                        low    <= mid + 1;    // Search in upper half
                    end else begin
                        high <= mid - 1;    // Search in lower half
                    end
                    state <= 3'd4;
                end
                3'd4: begin
                    // Check termination: if low <= high, continue search
                    if (low <= high)
                        state <= 3'd2;
                    else begin
                        // Finished search; output the result
                        uo_out <= result;
                        state <= 3'd0;  // Ready for next computation cycle
                    end
                end
                default: state <= 3'd0;
            endcase
        end
    end

    // Unused outputs
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

endmodule
