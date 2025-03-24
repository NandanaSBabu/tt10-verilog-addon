`default_nettype none
/* verilator lint_off TIMESCALEMOD */
`timescale 1ns / 1ps
/* verilator lint_on TIMESCALEMOD */

module tt_um_addon (
    input  wire [7:0] ui_in,   // X input
    input  wire [7:0] uio_in,  // Y input
    output reg  [7:0] uo_out,  // Square root output
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,     // Enable signal
    input  wire       clk,     // Clock signal
    input  wire       rst_n    // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] sqrt_temp;

    // Multiplication using shift-and-add (No *)
    function [15:0] mul_shift_add(input [7:0] a, input [7:0] b);
        reg [15:0] result;
        integer n;
        begin
            result = 0;
            for (n = 0; n < 8; n = n + 1)
                if (b[n])
                    result = result + (a << n);
            mul_shift_add = result;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            sqrt_temp   <= 8'd0;
        end else if (ena) begin
            sum_squares = mul_shift_add(ui_in, ui_in) + mul_shift_add(uio_in, uio_in);

            // Bitwise Square Root Calculation (No division)
            reg [15:0] num, res, bit;
            num = sum_squares;
            res = 0;
            bit = 1 << 14;  // Start with highest bit (2^14)

            while (bit > num) 
                bit = bit >> 2; // Adjust bit to range

            while (bit != 0) begin
                if (num >= res + bit) begin
                    num = num - (res + bit);
                    res = (res >> 1) + bit;
                end else begin
                    res = res >> 1;
                end
                bit = bit >> 2;
            end

            sqrt_temp <= res[7:0]; // Final sqrt result
            uo_out <= sqrt_temp;
        end
    end

endmodule
