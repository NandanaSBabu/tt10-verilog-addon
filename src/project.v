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
    reg [15:0] x_square;
    reg [15:0] y_square;
    reg [7:0] result;
    integer b;

    always @(*) begin
        // Compute squares using repeated addition (avoiding multiplication)
        x_square = 0;
        y_square = 0;

        for (b = 0; b < ui_in; b = b + 1) begin
            x_square = x_square + ui_in;
        end

        for (b = 0; b < uio_in; b = b + 1) begin
            y_square = y_square + uio_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares
            sum_squares <= x_square + y_square;

            // Compute square root using bitwise method (avoiding multiplication)
            result = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                if ((result + (1 << b)) <= sum_squares / (result + (1 << b)))
                    result = result + (1 << b);
            end

            // Assign output in the same cycle
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
