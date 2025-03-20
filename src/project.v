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
    reg [7:0] mid, low, high;
    reg [15:0] mid_squared;
    reg [15:0] x_sq, y_sq;
    reg [3:0] iter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 16'b0;
            uo_out <= 8'b0;
            iter <= 4'd0;
        end 
        else if (ena) begin
            if (iter == 0) begin
                // Compute x^2 and y^2 without using *
                x_sq = 0;
                repeat (ui_in) x_sq = x_sq + ui_in;
                y_sq = 0;
                repeat (uio_in) y_sq = y_sq + uio_in;
                sum_squares = x_sq + y_sq;

                // Initialize binary search
                low = 0;
                high = 255;
                sqrt_result = 0;
                iter = 4'd8; // 8 iterations of binary search
            end 
            else if (iter > 0) begin
                // Binary search for sqrt(sum_squares)
                mid = (low + high) >> 1; // (low + high) / 2
                
                // Compute mid^2 without *
                mid_squared = 0;
                repeat (mid) mid_squared = mid_squared + mid;

                if (mid_squared <= sum_squares) begin
                    sqrt_result = mid;
                    low = mid + 1;
                end 
                else begin
                    high = mid - 1;
                end

                iter = iter - 1;
            end 
            else begin
                uo_out <= sqrt_result[7:0]; // Assign sqrt result
            end
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
