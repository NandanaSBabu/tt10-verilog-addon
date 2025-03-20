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
    reg [7:0] mid, low, high;
    reg [15:0] mid_squared;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
        end 
        else if (ena) begin
            // Debugging print
            $display("Time = %0t | x = %d | y = %d | ena = %b", $time, ui_in, uio_in, ena);

            // Compute sum of squares manually without loops
            sum_squares <= (ui_in << 3) + (ui_in << 1) + (uio_in << 3) + (uio_in << 1);  
            // (x * 10) and (y * 10) approximation for x^2 + y^2
            
            low <= 0;
            high <= 255;
            sqrt_result <= 0;

            // Integer square root using a binary search (8 iterations)
            repeat (8) begin
                mid = (low + high) >> 1; // (low + high) / 2
                
                // Compute mid^2 without using *
                mid_squared = 0;
                repeat (mid) mid_squared = mid_squared + mid;

                if (mid_squared <= sum_squares) begin
                    sqrt_result = mid;
                    low = mid + 1;
                end 
                else begin
                    high = mid - 1;
                end
            end

            // Assign final sqrt result
            uo_out <= sqrt_result;

            // Debugging print
            $display("Time = %0t | sum_squares = %d | sqrt_result = %d", $time, sum_squares, sqrt_result);
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
