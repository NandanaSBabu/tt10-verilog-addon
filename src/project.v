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
    reg [15:0] r;
    reg [7:0] sqrt_result;
    reg [15:0] odd;
    reg calc_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'b0;
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            r <= 16'b0;
            sqrt_result <= 8'b0;
            odd <= 16'b1;
            calc_done <= 1'b0;
        end else if (ena && !calc_done) begin
            // Compute squares
            square_x <= ui_in * ui_in;
            square_y <= uio_in * uio_in;
            sum_squares <= square_x + square_y;
            r <= 0;
            odd <= 1;
            sqrt_result <= 0;
            calc_done <= 1'b0;
        end else if (ena && !calc_done) begin
            // Integer square root calculation
            if (r + odd <= sum_squares) begin
                r <= r + odd;
                odd <= odd + 2;
                sqrt_result <= sqrt_result + 1;
            end else begin
                calc_done <= 1'b1;
            end
        end
        if (calc_done) begin
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
