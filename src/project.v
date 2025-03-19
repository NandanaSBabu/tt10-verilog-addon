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
    reg [7:0] r;
    reg signed [7:0] theta;
    reg [4:0] iter;
    reg signed [15:0] X, Y, Z;
    reg flip;
    reg done;

    // CORDIC atan table (precomputed values, scaled)
    reg signed [7:0] atan_table [0:7];
    initial begin
        atan_table[0] = 8'd45;
        atan_table[1] = 8'd27;
        atan_table[2] = 8'd14;
        atan_table[3] = 8'd7;
        atan_table[4] = 8'd4;
        atan_table[5] = 8'd2;
        atan_table[6] = 8'd1;
        atan_table[7] = 8'd0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r <= 8'b0;
            theta <= 8'b0;
            x <= 8'b0;
            y <= 8'b0;
            z <= 8'b0;
            done <= 0;
            iter <= 0;
        end else begin
            if (!done) begin
                X <= x;
                Y <= y;
                Z <= 0;
                iter <= 0;
                flip <= (x < 0);
                done <= 1;
            end else if (iter < 8) begin
                reg signed [15:0] X_new, Y_new, Z_new;
                if (Y >= 0) begin
                    X_new = X + (Y >>> iter);
                    Y_new = Y - (X >>> iter);
                    Z_new = Z + atan_table[iter];
                end else begin
                    X_new = X - (Y >>> iter);
                    Y_new = Y + (X >>> iter);
                    Z_new = Z - atan_table[iter];
                end
                X <= X_new;
                Y <= Y_new;
                Z <= Z_new;
                iter <= iter + 1;
                if (iter == 7) begin
                    r <= X_new[7:0];
                    theta <= flip ? -Z_new[7:0] : Z_new[7:0];
                end
            end
        end
    end

    assign uo_out = {r[7:4], theta[3:0]};  // Pack r and theta into output
    assign uio_out = 0;
    assign uio_oe  = 0;
    wire _unused = &{ena, uio_in};

endmodule
