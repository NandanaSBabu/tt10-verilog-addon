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
    reg [7:0] approx_sqrt;
    reg [7:0] bitmask;
    reg [15:0] temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            approx_sqrt <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
            
            // Approximate square root using shift-subtract method (no loops)
            approx_sqrt = 0;
            bitmask = 8'b10000000;  // Start with the highest bit
            
            temp = 0;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;
            bitmask = bitmask >> 1;
            
            if ((temp | bitmask) * (temp | bitmask) <= sum_squares) temp = temp | bitmask;

            // Assign final output
            approx_sqrt = temp[7:0];
            uo_out <= approx_sqrt;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
