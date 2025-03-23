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
    reg [15:0] result;  // Increased width to 16 bits for intermediate calculations
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x <= 16'b0;
            square_y <= 16'b0;
            result <= 16'b0;  // Use 16 bits for result
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute square of x (ui_in) and y (uio_in) using repeated addition
            square_x <= ui_in * ui_in; // Use non-blocking assignment
            square_y <= uio_in * uio_in; // Use non-blocking assignment

            // Compute sum of squares
            sum_squares <= square_x + square_y; // Use non-blocking assignment

            // Compute square root using bitwise approximation
            result <= 16'b0; // Initialize result to 0
            
            for (integer b = 7; b >= 0; b = b - 1) begin
                if ((result + (1 << b)) * (result + (1 << b)) <= sum_squares) begin
                    result <= result + (1 << b); // Use non-blocking assignment
                end
            end

            // Assign output
            uo_out <= result[7:0];  // Only output 8 bits of the result
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
