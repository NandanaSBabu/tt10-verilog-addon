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
    reg [7:0] result;

    // Squaring function without multiplication (Shift-and-Add)
    function [15:0] square;
        input [7:0] value;
        reg [15:0] temp;
        reg [3:0] n;
        begin
            temp = 0;
            for (n = 0; n < 8; n = n + 1) begin
                if (value[n])
                    temp = temp + (value << n); // Shift-and-add
            end
            square = temp;
        end
    endfunction

    // Approximate Square Root (Bitwise Method)
    function [7:0] sqrt_approx;
        input [15:0] value;
        reg [7:0] res;
        reg [15:0] bit, temp;
        begin
            res = 0;
            bit = 1 << 14;  // Start at highest bit position (16-bit)
            temp = value;
            while (bit > 0) begin
                if (temp >= (res | bit)) begin
                    temp = temp - (res | bit);
                    res = (res >> 1) | bit;
                end else begin
                    res = res >> 1;
                end
                bit = bit >> 2;
            end
            sqrt_approx = res;
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
            // Compute squares
            square_x <= square(ui_in);
            square_y <= square(uio_in);

            // Compute sum of squares
            sum_squares <= square_x + square_y;

            // Compute square root
            result <= sqrt_approx(sum_squares);

            // Assign to output
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
