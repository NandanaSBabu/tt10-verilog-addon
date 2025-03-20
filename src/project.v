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
    reg [15:0] sqrt_result;
    reg [7:0] low, high, mid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 16'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares without multiplication
            sum_squares = 0;

            for (integer i = 0; i < ui_in; i = i + 1)
                sum_squares = sum_squares + ui_in;

            for (integer i = 0; i < uio_in; i = i + 1)
                sum_squares = sum_squares + uio_in;

            // Compute integer square root using binary search
            low = 0;
            high = 255;
            sqrt_result = 0;

            while (low <= high) begin
                mid = (low + high) >> 1;  // mid = (low + high) / 2 (safe shift division)

                // Check mid * mid without using *
                reg [15:0] mid_squared = 0;
                for (integer i = 0; i < mid; i = i + 1)
                    mid_squared = mid_squared + mid;

                if (mid_squared <= sum_squares) begin
                    sqrt_result = mid;
                    low = mid + 1;
                end else begin
                    high = mid - 1;
                end
            end

            // Assign final square root result
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
