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
    reg [15:0] temp, bit;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute x^2 + y^2 using multiplication
            sum_squares = (ui_in * ui_in) + (uio_in * uio_in);

            // Square root calculation using bitwise method
            temp = sum_squares;
            bit = 1 << 14; // Start at highest bit position
            sqrt_result = 0;

            repeat (8) begin
                if (temp >= (sqrt_result | bit)) begin
                    temp = temp - (sqrt_result | bit);
                    sqrt_result = (sqrt_result >> 1) | bit;
                end else begin
                    sqrt_result = sqrt_result >> 1;
                end
                bit = bit >> 2;
            end

            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
