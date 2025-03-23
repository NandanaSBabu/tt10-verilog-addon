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

    // Debug signals
    wire [15:0] debug_square_x;
    wire [15:0] debug_square_y;
    wire [15:0] debug_sum_squares;

    // Squaring function using multiplication
    function [15:0] square;
        input [7:0] value;
        begin
            square = value * value;  // Direct multiplication
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
            square_x <= square(ui_in);
            square_y <= square(uio_in);

            // Compute sum of squares
            sum_squares <= square_x + square_y;

            // Debug output
            $display("square_x: %h, square_y: %h, sum_squares: %h", square_x, square_y, sum_squares);

            // Compute square root using bitwise approximation (manual unrolling)
            result <= 16'b0; // Reset the result before approximation
            if ((result + (1 << 15)) * (result + (1 << 15)) <= sum_squares) begin
                result <= result + (1 << 15);
            end
            if ((result + (1 << 14)) * (result + (1 << 14)) <= sum_squares) begin
                result <= result + (1 << 14);
            end
            // Continue for the other bits...
            uo_out <= result[7:0];
        end
    end

    // Assign debug outputs
    assign debug_square_x = square_x;
    assign debug_square_y = square_y;
    assign debug_sum_squares = sum_squares;

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
