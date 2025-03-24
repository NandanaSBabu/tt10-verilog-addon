`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square Root output
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [7:0] b;
    integer n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            sqrt_result <= 8'd0;
        end else begin
            // Compute sum of squares
            sum_squares <= ui_in * ui_in + uio_in * uio_in;

            // Start binary search for square root
            sqrt_result = 0;
            b = 8'h80; // Start with highest bit

            // Manually unrolling the loop (8-bit precision)
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;
            b = b >> 1;
            if ((sqrt_result | b) * (sqrt_result | b) <= sum_squares) sqrt_result = sqrt_result | b;

            uo_out <= sqrt_result; // Output the square root
        end
    end

    // Prevent warnings for unused signals
    wire _unused = &{ena, 1'b0};

endmodule
