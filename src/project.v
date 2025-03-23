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
    reg [7:0] result; // 8-bit output result

    // Function to compute square using shift-and-add method
    function [15:0] square;
        input [7:0] value;
        reg [15:0] sum;
        integer i;
        begin
            sum = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (value[i])
                    sum = sum + (value << i);
            end
            square = sum;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute squares using shift-and-add
            square_x <= square(ui_in);
            square_y <= square(uio_in);
            sum_squares <= square_x + square_y;

            // Bitwise square root approximation
            result = 0;
            for (integer i = 7; i >= 0; i = i - 1) begin
                if ((result | (1 << i)) * (result | (1 << i)) <= sum_squares) begin
                    result = result | (1 << i);
                end
            end

            // Assign the output (only 8 bits of the result)
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
