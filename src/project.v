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
    reg [7:0] r, odd;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Squaring using shifts & adds
            sum_squares = (ui_in << 3) + (ui_in << 1) + (uio_in << 3) + (uio_in << 1); 

            // Square root using sum of odd numbers
            r = 0;
            odd = 1;
            sqrt_result = 0;

            while (r + odd <= sum_squares) begin
                r = r + odd;
                odd = odd + 2;
                sqrt_result = sqrt_result + 1;
            end
            
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
