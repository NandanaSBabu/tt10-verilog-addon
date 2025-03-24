`default_nettype none
`timescale 1ns/1ps

module tt_um_addon (
    input  wire [7:0] ui_in,     // x input
    input  wire [7:0] uio_in,    // y input
    output reg  [7:0] uo_out,    // Integer square root output
    output wire [7:0] uio_out,   // Unused IO output (tied to 0)
    output wire [7:0] uio_oe,    // Unused IO enable (0 = input)
    input  wire       ena,       // Enable signal
    input  wire       clk,       // Clock
    input  wire       rst_n      // Active-low reset
);

    // Registers for squared values and sum
    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;
    reg [7:0] sqrt_temp;
    integer n;

    // Synchronous process for computation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x    <= 16'd0;
            square_y    <= 16'd0;
            sum_squares <= 16'd0;
            uo_out      <= 8'd0;
        end else if (ena) begin
            // Compute squares
            square_x    <= ui_in * ui_in;
            square_y    <= uio_in * uio_in;
            sum_squares <= square_x + square_y;

            // Integer square root calculation (AFTER sum_squares is updated)
            sqrt_temp = 8'd0;
            for (n = 7; n >= 0; n = n - 1) begin
                if (((sqrt_temp | (1 << n)) * (sqrt_temp | (1 << n))) <= sum_squares)
                    sqrt_temp = sqrt_temp | (1 << n);
            end
            uo_out <= sqrt_temp;
        end
    end

    // Tie unused IO outputs to 0
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

endmodule
