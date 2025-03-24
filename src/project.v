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

            // Square root approximation (Babylonian method - no division)
            begin
                reg [15:0] guess;
                reg [15:0] next_guess;
                integer i;

                guess = sum_squares >> 1; // Initial guess (sum_squares / 2)
                if (guess == 0) begin
                    sqrt_temp <= 8'd0;
                end else begin
                    next_guess = (guess + (sum_squares / guess)) >> 1;
                    next_guess = (guess + (sum_squares >> ($clog2(guess)))) >> 1; // Approximation for division
                    for (i = 0; i < 4; i = i + 1) begin // Iterate for better approximation
                        guess = next_guess;
                        next_guess = (guess + (sum_squares >> ($clog2(guess)))) >> 1; // Approximation for division
                    end
                    sqrt_temp <= next_guess[7:0]; // Take lower 8 bits
                end
            end

            uo_out <= sqrt_temp;
        end else begin
            uo_out <= uo_out;
        end
    end

    function integer clog2 (input integer value);
        integer result;
        begin
            result = 0;
            while (value > 1) begin
                value = value >> 1;
                result = result + 1;
            end
            clog2 = result;
        end
    end

endmodule
