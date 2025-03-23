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
    reg [2:0] state; // State machine for sequential operations
    reg [7:0] b;
    reg calc_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            square_x    <= 16'b0;
            square_y    <= 16'b0;
            result      <= 8'b0;
            uo_out      <= 8'b0;
            b         <= 8'b10000000; // Highest bit for approximation
            state       <= 3'b000;
            calc_done   <= 1'b0;
        end else if (ena) begin
            case (state)
                3'b000: begin
                    square_x <= ui_in * ui_in;
                    square_y <= uio_in * uio_in;
                    state <= 3'b001;
                end
                3'b001: begin
                    sum_squares <= square_x + square_y;
                    result <= 8'b0;
                    b <= 8'b10000000; // Start at highest bit
                    state <= 3'b010;
                end
                3'b010: begin
                    if (b > 0) begin
                        if ((result | b) * (result | b) <= sum_squares) begin
                            result <= result | b;
                        end
                        b <= b >> 1; // Shift bit right
                    end else begin
                        calc_done <= 1'b1;
                        state <= 3'b011;
                    end
                end
                3'b011: begin
                    if (calc_done) begin
                        uo_out <= result; // Store the final result
                        state <= 3'b100;
                    end
                end
                3'b100: begin
                    // Hold output and wait for next enable
                    state <= 3'b000;
                end
            endcase
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
