default_nettype none

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
    reg [15:0] result;  // Change to 16-bit to handle larger numbers
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 16'b0;  // Change to 16-bit for proper width
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute square of x (ui_in) and y (uio_in)
            square_x <= ui_in * ui_in;
            square_y <= uio_in * uio_in;

            // Compute sum of squares
            sum_squares <= square_x + square_y;

            // Compute square root using bitwise approximation
            result <= 0;
            for (integer b = 7; b >= 0; b = b - 1) begin
                if ((result + (1 << b)) * (result + (1 << b)) <= sum_squares) begin
                    result <= result + (1 << b);
                end
            end

            // Assign output (cast result to 8 bits)
            uo_out <= result[7:0];  // Only take the lower 8 bits for output
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
