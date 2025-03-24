`default_nettype none
/* verilator lint_off TIMESCALEMOD */
`timescale 1ns / 1ps
/* verilator lint_on TIMESCALEMOD */

module tt_um_addon (
    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output reg  [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] sqrt_temp;

    // Multiplication using shift-and-add
    function [15:0] mul_shift_add(input [7:0] a, input [7:0] b);
        reg [15:0] result;
        integer k;
        begin
            result = 0;
            for (k = 0; k < 8; k = k + 1)
                if (b[k])
                    result = result + (a << k);
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

            // Simplified Square root approximation with dynamic correction
            begin
                reg [15:0] guess;
                reg [15:0] next_guess;
                integer shift_amount;
                integer correction;

                guess = sum_squares >> 1; // Initial guess

                if (guess == 0) begin
                    sqrt_temp <= 8'd0;
                end else begin
                    // Determine shift_amount
                    if (guess >= 32768) shift_amount = 15;
                    else if (guess >= 16384) shift_amount = 14;
                    else if (guess >= 8192) shift_amount = 13;
                    else if (guess >= 4096) shift_amount = 12;
                    else if (guess >= 2048) shift_amount = 11;
                    else if (guess >= 1024) shift_amount = 10;
                    else if (guess >= 512) shift_amount = 9;
                    else if (guess >= 256) shift_amount = 8;
                    else if (guess >= 128) shift_amount = 7;
                    else if (guess >= 64) shift_amount = 6;
                    else if (guess >= 32) shift_amount = 5;
                    else if (guess >= 16) shift_amount = 4;
                    else if (guess >= 8) shift_amount = 3;
                    else if (guess >= 4) shift_amount = 2;
                    else if (guess >= 2) shift_amount = 1;
                    else shift_amount = 0;

                    next_guess = (guess + (sum_squares >> shift_amount)) >> 1;

                    // Dynamic correction based on input range (example)
                    if (sum_squares > 100) correction = 2;
                    else if (sum_squares > 25) correction = 1;
                    else correction = 0;

                    sqrt_temp <= next_guess[7:0] - correction; // Dynamic correction
                end
            end

            uo_out <= sqrt_temp;
        end else begin
            uo_out <= uo_out;
        end
    end

endmodule
