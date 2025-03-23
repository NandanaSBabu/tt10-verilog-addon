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
    reg [15:0] temp, bit;
    integer n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute x^2 + y^2 using shift-add method (avoiding multiplication)
            sum_squares = (ui_in << 2) + ui_in + (uio_in << 2) + uio_in;

            // Bitwise square root calculation
            temp = sum_squares;
            bit = 1 << 14; // Start at highest bit position
            sqrt_result = 0;

            for (n = 0; n < 8; n = n + 1) begin
                if (temp >= (sqrt_result | bit)) begin
                    temp = temp - (sqrt_result | bit);
                    sqrt_result = (sqrt_result >> 1) | bit;
                end else begin
                    sqrt_result = sqrt_result >> 1;
                end
                bit = bit >> 2;
            end

            // Assign computed square root to output
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
