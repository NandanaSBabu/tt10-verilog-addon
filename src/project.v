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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x    <= 16'b0;
            square_y    <= 16'b0;
            result      <= 8'b0;
            uo_out      <= 8'b0;
        end else if (ena) begin
            // Compute squares first
            square_x    <= ui_in * ui_in;
            square_y    <= uio_in * uio_in;
        end
    end

    always @(posedge clk) begin
        if (ena) begin
            // Sum squares (this occurs one cycle after squaring)
            sum_squares <= square_x + square_y;
        end
    end

    always @(posedge clk) begin
        if (ena) begin
            // Compute square root using bitwise method
            result <= 0;
            for (int n = 7; n >= 0; n = n - 1) begin
                if ((result | (1 << n)) * (result | (1 << n)) <= sum_squares) 
                    result <= result | (1 << n);
            end

            // Assign the output
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
