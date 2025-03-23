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

    // Internal signals
    wire [15:0] square_x, square_y, sum_squares;
    reg  [7:0] sqrt_result;
    reg  [15:0] temp, bit;
    reg  [3:0] step;  // Step counter for FSM

    // Compute squares without multiplication (Shift-and-Add Approximation)
    assign square_x = {ui_in, 1'b0} + {ui_in, 2'b00}; // Approximate x^2
    assign square_y = {uio_in, 1'b0} + {uio_in, 2'b00}; // Approximate y^2
    assign sum_squares = square_x + square_y;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
            step <= 4'b0;
            temp <= 16'b0;
            bit <= 16'b0100000000000000; // Initialize bit properly
        end else if (ena) begin
            case (step)
                0: begin
                    temp <= sum_squares;
                    bit <= 16'b0100000000000000; // Initialize to 1 << 14
                    sqrt_result <= 0;
                    step <= 1;
                end
                1: begin
                    if (temp >= (sqrt_result | bit)) begin
                        temp <= temp - (sqrt_result | bit);
                        sqrt_result <= (sqrt_result >> 1) | bit;
                    end else begin
                        sqrt_result <= sqrt_result >> 1;
                    end
                    bit <= bit >> 2;

                    if (bit == 0) // Stop when bit is completely shifted out
                        step <= 2;
                end
                2: begin
                    uo_out <= sqrt_result;
                    step <= 0; // Ready for next cycle
                end
            endcase
        end
    end

    // Assign unused outputs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
