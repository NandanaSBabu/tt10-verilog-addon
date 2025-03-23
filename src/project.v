module tt_um_addon (
    input wire clk,
    input wire rst_n,
    input wire ena,
    input wire [7:0] ui_in,
    input wire [7:0] uio_in,
    output reg [7:0] uo_out
);

    reg [15:0] square_x, square_y, sum_squares;
    reg [7:0] result;

    function [15:0] square;
        input [7:0] x;
        begin
            square = x * x;  // Squaring function (unchanged)
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 0;  // Reset output properly
        end else if (ena) begin
            square_x <= square(ui_in);       // Use <= (non-blocking)
            square_y <= square(uio_in);
            sum_squares <= square_x + square_y;

            // Approximate sqrt using shift right
            result <= sum_squares >> 4;
            uo_out <= result;  // Use non-blocking assignment
        end
    end
endmodule
