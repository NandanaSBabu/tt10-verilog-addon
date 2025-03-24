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
            sum_squares <= 16'd0; // Initialize sum_squares
            sqrt_temp   <= 8'd0;  // Initialize sqrt_temp
        end else if (ena) begin
            sum_squares = mul_shift_add(ui_in, ui_in) + mul_shift_add(uio_in, uio_in);

            // Square root approximation
            sqrt_temp = 8'd0;
            begin
                reg [15:0] r;
                integer n;
                r = 0;
                for (n = 7; n >= 0; n = n - 1) begin
                    if ((r | (1 << n)) * (r | (1 << n)) <= sum_squares)
                        r = r | (1 << n);
                end
                sqrt_temp = r[7:0];  // Take only lower 8 bits
            end

            uo_out <= sqrt_temp;
        end else begin
            uo_out <= uo_out; // Hold the last value when `ena` is low
        end
    end

endmodule
