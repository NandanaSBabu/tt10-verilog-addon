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

    reg [15:0] sum_squares;
    reg [15:0] square_x, square_y;
    reg [7:0] result;
    reg [15:0] temp, temp_square;
    integer i, j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 0;
            square_y <= 0;
            sum_squares <= 0;
            result <= 0;
        end else begin
            // Compute ui_in^2 using repeated addition
            square_x = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (ui_in[j]) square_x = square_x + (ui_in << j);
            end

            // Compute uio_in^2 using repeated addition
            square_y = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (uio_in[j]) square_y = square_y + (uio_in << j);
            end

            sum_squares = square_x + square_y;

            // Compute square root using bitwise method (no multiplication)
            result = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                temp = result + (1 << i);

                // Compute temp^2 using repeated addition
                temp_square = 0;
                for (j = 0; j < 8; j = j + 1) begin
                    if (temp[j]) temp_square = temp_square + (temp << j);
                end

                if (temp_square <= sum_squares)
                    result = temp;
            end
        end
    end

    assign uo_out = result;
    assign uio_out = 0;
    assign uio_oe  = 0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, 1'b0};

endmodule
