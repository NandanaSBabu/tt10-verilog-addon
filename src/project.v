`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output reg  [7:0] uo_out,   // sqrt_out output
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       clk,      // clock
    input  wire       rst_n,    // active-low reset
    input  wire       ena       // Enable signal
);

    reg [15:0] sum_squares;
    reg [15:0] square_x, square_y;
    reg [15:0] result; // Changed to 16 bits to avoid width issues

    // Squaring function using repeated addition
    function [15:0] square;
        input [7:0] value;
        integer i;
        begin
            square = 16'b0;
            for (i = 0; i < value; i = i + 1) begin
                square = square + value;
            end
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 16'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute square of x (ui_in) and y (uio_in) using the square function
            square_x = square(ui_in);
            square_y = square(uio_in);

            // Compute sum of squares
            sum_squares = square_x + square_y;

            // Compute square root using bitwise approximation without procedural loops
            result = 16'b0; // Reset the result before approximation
            
            // Unroll the loop manually (each line simulates one loop iteration)
            if ((result + 16'b1000000000000000) * (result + 16'b1000000000000000) <= sum_squares) result = result + 16'b1000000000000000;
            if ((result + 16'b0100000000000000) * (result + 16'b0100000000000000) <= sum_squares) result = result + 16'b0100000000000000;
            if ((result + 16'b0010000000000000) * (result + 16'b0010000000000000) <= sum_squares) result = result + 16'b0010000000000000;
            if ((result + 16'b0001000000000000) * (result + 16'b0001000000000000) <= sum_squares) result = result + 16'b0001000000000000;
            if ((result + 16'b0000100000000000) * (result + 16'b0000100000000000) <= sum_squares) result = result + 16'b0000100000000000;
            if ((result + 16'b0000010000000000) * (result + 16'b0000010000000000) <= sum_squares) result = result + 16'b0000010000000000;
            if ((result + 16'b0000001000000000) * (result + 16'b0000001000000000) <= sum_squares) result = result + 16'b0000001000000000;
            if ((result + 16'b0000000100000000) * (result + 16'b0000000100000000) <= sum_squares) result = result + 16'b0000000100000000;
            if ((result + 16'b0000000010000000) * (result + 16'b0000000010000000) <= sum_squares) result = result + 16'b0000000010000000;
            if ((result + 16'b0000000001000000) * (result + 16'b0000000001000000) <= sum_squares) result = result + 16'b0000000001000000;
            if ((result + 16'b0000000000100000) * (result + 16'b0000000000100000) <= sum_squares) result = result + 16'b0000000000100000;
            if ((result + 16'b0000000000010000) * (result + 16'b0000000000010000) <= sum_squares) result = result + 16'b0000000000010000;
            if ((result + 16'b0000000000001000) * (result + 16'b0000000000001000) <= sum_squares) result = result + 16'b0000000000001000;
            if ((result + 16'b0000000000000100) * (result + 16'b0000000000000100) <= sum_squares) result = result + 16'b0000000000000100;
            if ((result + 16'b0000000000000010) * (result + 16'b0000000000000010) <= sum_squares) result = result + 16'b0000000000000010;
            if ((result + 16'b0000000000000001) * (result + 16'b0000000000000001) <= sum_squares) result = result + 16'b0000000000000001;

            // Assign the output (only 8 bits of the result)
            uo_out <= result[7:0];
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
