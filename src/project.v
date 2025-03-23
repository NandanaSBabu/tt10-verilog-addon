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

    wire [15:0] square_x, square_y, sum_squares;
    reg [7:0] sqrt_result;
    reg [15:0] temp, bit;
    
    // Combinational multiplication (avoids registers)
    assign square_x = ui_in * ui_in;
    assign square_y = uio_in * uio_in;
    assign sum_squares = square_x + square_y;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Approximate Square Root Calculation (CORDIC or LUT-based if needed)
            temp = sum_squares;
            bit = 1 << 14;
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

            // Assign output
            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
