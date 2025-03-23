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

    reg [15:0] x, y;
    reg [15:0] sum_squares;
    reg [7:0] result;
    reg [15:0] r, d;
    integer n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x <= 16'b0;
            y <= 16'b0;
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Approximate squaring (avoiding multiplication)
            x = {ui_in, 8'b0}; // Shift left for fixed point
            y = {uio_in, 8'b0};

            // Sum of squares approximation
            sum_squares = (x >> 1) + (y >> 1); 

            // CORDIC-style square root approximation
            r = 0;
            d = sum_squares;
            for (n = 7; n >= 0; n = n - 1) begin
                if ((r + (1 << n)) * (r + (1 << n)) <= d) begin
                    r = r + (1 << n);
                end
            end
            result = r[7:0];

            // Assign output
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
