/*
 * Copyright (c) 2024
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_rect_to_cyl (
    input  wire [7:0] ui_in,    // Input: Encoded x, y, z values
    output wire [7:0] uo_out,   // Output: Encoded r, theta, z_out
    input  wire [7:0] uio_in,   // IOs (Not used in this design)
    output wire [7:0] uio_out,  // IOs Output (Not used in this design)
    output wire [7:0] uio_oe,   // IOs Enable (Not used in this design)
    input  wire       ena,      // Enable
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active low reset
);

    reg signed [7:0] x, y, z;
    wire [7:0] r;
    wire signed [7:0] theta;
    wire [7:0] z_out;
    reg start;
    wire done;

    rect_to_cyl core (
        .clk(clk),
        .rst(~rst_n),
        .start(start),
        .x(x),
        .y(y),
        .z(z),
        .r(r),
        .theta(theta),
        .z_out(z_out),
        .done(done)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x <= 8'b0;
            y <= 8'b0;
            z <= 8'b0;
            start <= 1'b0;
        end else if (ena) begin
            x <= ui_in[7:0]; // Extract x from input
            y <= uio_in[7:0]; // Extract y from input
            z <= uio_in[7:0]; // Extract z from input
            start <= 1'b1;
        end else begin
            start <= 1'b0;
        end
    end

    assign uo_out = {r[7:4], theta[3:0]};  // Pack r and theta into output
    assign uio_out = z_out;
    assign uio_oe  = 8'b11111111;
    wire _unused = &{ena, uio_in};

endmodule

