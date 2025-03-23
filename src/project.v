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
    reg [15:0] result;
    reg computing;  // Flag to track computation

    // Squaring function using multiplication
    function [15:0] square;
        input [7:0] value;
        begin
            square = value * value;  
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 16'b0;
            uo_out <= 8'b0;
            computing <= 0;
        end else if (ena && !computing) begin
            computing <= 1;  // Start computation
            square_x <= square(ui_in);
            square_y <= square(uio_in);
            sum_squares <= square_x + square_y;
            result <= 16'b0;
        end else if (computing) begin
            if ((result + (1 << 7)) * (result + (1 << 7)) <= sum_squares) result = result + (1 << 7);
            if ((result + (1 << 6)) * (result + (1 << 6)) <= sum_squares) result = result + (1 << 6);
            if ((result + (1 << 5)) * (result + (1 << 5)) <= sum_squares) result = result + (1 << 5);
            if ((result + (1 << 4)) * (result + (1 << 4)) <= sum_squares) result = result + (1 << 4);
            if ((result + (1 << 3)) * (result + (1 << 3)) <= sum_squares) result = result + (1 << 3);
            if ((result + (1 << 2)) * (result + (1 << 2)) <= sum_squares) result = result + (1 << 2);
            if ((result + (1 << 1)) * (result + (1 << 1)) <= sum_squares) result = result + (1 << 1);
            if ((result + (1 << 0)) * (result + (1 << 0)) <= sum_squares) result = result + (1 << 0);

            uo_out <= result[7:0];
            computing <= 0;  // Stop computation
        end
    end

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
