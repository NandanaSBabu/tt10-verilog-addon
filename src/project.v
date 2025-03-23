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
    reg [3:0] n;

    // **Replaced function with inline shift-and-add squaring**
    always @(*) begin
        square_x = 0;
        square_y = 0;
        for (n = 0; n < 8; n = n + 1) begin
            if (ui_in[n]) square_x = square_x + (ui_in << n);
            if (uio_in[n]) square_y = square_y + (uio_in << n);
        end
    end

    // **Square Root using Bitwise Approximation**
    always @(*) begin
        result = 0;
        sum_squares = square_x + square_y;
        if (sum_squares >= 256) result = 16;
        if (sum_squares >= 1024) result = 32;
        if (sum_squares >= 4096) result = 64;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'b0;
        end else if (ena) begin
            uo_out <= result;
        end
    end

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
