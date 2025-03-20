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
    reg [7:0] sqrt_result;
    reg [15:0] remainder;
    reg [7:0] bit, root;

    // Function to compute square using repeated addition
    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            count = a;
            while (count > 0) begin
                s = s + a;  // Repeated addition (avoiding multiplication)
                count = count - 1;
            end
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares
            sum_squares = square(ui_in) + square(uio_in);

            // Compute square root using bitwise method
            remainder = sum_squares;
            root = 0;
            bit = 1 << 14; // Start with the highest power of 4 below 16 bits

            while (bit > 0) begin
                if (root + bit <= remainder) begin
                    remainder = remainder - (root + bit);
                    root = (root >> 1) + bit;
                end else begin
                    root = root >> 1;
                end
                bit = bit >> 2;
            end

            sqrt_result = root;

            // Assign output in the same cycle
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
