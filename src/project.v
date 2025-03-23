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
    reg [7:0] result, bit;
    reg [2:0] state; // State machine for sequential operations

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x    <= 16'b0;
            square_y    <= 16'b0;
            result      <= 8'b0;
            uo_out      <= 8'b0;
            bit         <= 8'b10000000; // Start with the highest bit
            state       <= 0;
        end else if (ena) begin
            case (state)
                0: begin
                    square_x <= ui_in * ui_in;
                    square_y <= uio_in * uio_in;
                    state <= 1;
                end
                1: begin
                    sum_squares <= square_x + square_y;
                    result <= 0;
                    bit <= 8'b10000000; // Start checking from the highest bit
                    state <= 2;
                end
                2: begin
                    if (bit > 0) begin
                        if ((result | bit) * (result | bit) <= sum_squares) begin
                            result <= result | bit;
                        end
                        bit <= bit >> 1; // Move to the next lower bit
                    end else begin
                        state <= 3;
                    end
                end
                3: begin
                    uo_out <= result; // Store the final result
                    state <= 0;
                end
            endcase
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
