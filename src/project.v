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
    reg [7:0] result; // Should be 8-bit since sqrt(255^2) < 256

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute squares
            square_x <= ui_in * ui_in;
            square_y <= uio_in * uio_in;

            // Compute sum of squares
            sum_squares <= square_x + square_y;

            // Reset result for each calculation
            result <= 8'b0;

            // Approximate square root using shift method
            if (sum_squares >= 255*255) result <= 255;
            else if (sum_squares >= 225*225) result <= 225;
            else if (sum_squares >= 196*196) result <= 196;
            else if (sum_squares >= 169*169) result <= 169;
            else if (sum_squares >= 144*144) result <= 144;
            else if (sum_squares >= 121*121) result <= 121;
            else if (sum_squares >= 100*100) result <= 100;
            else if (sum_squares >= 81*81) result <= 81;
            else if (sum_squares >= 64*64) result <= 64;
            else if (sum_squares >= 49*49) result <= 49;
            else if (sum_squares >= 36*36) result <= 36;
            else if (sum_squares >= 25*25) result <= 25;
            else if (sum_squares >= 16*16) result <= 16;
            else if (sum_squares >= 9*9) result <= 9;
            else if (sum_squares >= 4*4) result <= 4;
            else if (sum_squares >= 1*1) result <= 1;
            else result <= 0;

            // Assign output
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
