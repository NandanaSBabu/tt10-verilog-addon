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
    reg [3:0] state; // State machine for sequential operations

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x    <= 16'b0;
            square_y    <= 16'b0;
            result      <= 8'b0;
            uo_out      <= 8'b0;
            state       <= 0;
        end else if (ena) begin
            case (state)
                begin
                    square_x <= ui_in * ui_in;
                    square_y <= uio_in * uio_in;
                    state <= 1;
                end
                begin
                    sum_squares <= square_x + square_y;
                    state <= 2;
                end
                begin
                    result <= 0;
                    state <= 3;
                end
                begin
                    if ((result + (1 << 7)) * (result + (1 << 7)) <= sum_squares)
                        result <= result + (1 << 7);
                    if ((result + (1 << 6)) * (result + (1 << 6)) <= sum_squares)
                        result <= result + (1 << 6);
                    if ((result + (1 << 5)) * (result + (1 << 5)) <= sum_squares)
                        result <= result + (1 << 5);
                    if ((result + (1 << 4)) * (result + (1 << 4)) <= sum_squares)
                        result <= result + (1 << 4);
                    if ((result + (1 << 3)) * (result + (1 << 3)) <= sum_squares)
                        result <= result + (1 << 3);
                    if ((result + (1 << 2)) * (result + (1 << 2)) <= sum_squares)
                        result <= result + (1 << 2);
                    if ((result + (1 << 1)) * (result + (1 << 1)) <= sum_squares)
                        result <= result + (1 << 1);
                    if ((result + (1 << 0)) * (result + (1 << 0)) <= sum_squares)
                        result <= result + (1 << 0);
                    state <= 4;
                end
                begin
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
