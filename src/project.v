`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,     // x input
    input  wire [7:0] uio_in,    // y input
    output reg  [7:0] uo_out,    // sqrt_out output
    output wire [7:0] uio_out,   // Unused IO output path
    output wire [7:0] uio_oe,    // Unused IO enable path (0 = input)
    input  wire       ena,       // Enable signal (when high, compute)
    input  wire       clk,       // Clock
    input  wire       rst_n      // Active-low reset
);

    // Internal registers
    reg [15:0] square_x, square_y, sum_squares;
    reg [15:0] num;         // Working copy of sum_squares for sqrt calculation
    reg [15:0] result;      // Intermediate sqrt result (16 bits)
    reg [15:0] b;          // Current bit value for testing
    reg [2:0]  state;       // State machine (0 to 5)

    // State encoding:
    // 0: Compute squares
    // 1: Compute sum (x^2+y^2)
    // 2: Initialize sqrt: set num, result=0, and bit = highest candidate (start at 1<<14)
    // 3: Reduce bit until bit <= num (if bit > num, shift right by 2)
    // 4: Iterative sqrt calculation: while (bit != 0)
    // 5: Output result and then return to state 0

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x    <= 16'd0;
            square_y    <= 16'd0;
            sum_squares <= 16'd0;
            num         <= 16'd0;
            result      <= 16'd0;
            b           <= 16'd0;
            uo_out      <= 8'd0;
            state       <= 3'd0;
        end else if (ena) begin
            case (state)
                3'd0: begin
                    // Compute squares using multiplication
                    square_x    <= ui_in * ui_in;    // e.g., 3*3 = 9
                    square_y    <= uio_in * uio_in;   // e.g., 4*4 = 16
                    state       <= 3'd1;
                end
                3'd1: begin
                    // Sum the squares: 9+16=25
                    sum_squares <= square_x + square_y;
                    state       <= 3'd2;
                end
                3'd2: begin
                    // Initialize the sqrt algorithm:
                    // Make a copy of the operand and set result = 0.
                    num     <= sum_squares;
                    result  <= 16'd0;
                    // Initialize bit to highest power of 4 by starting at 1<<14
                    b       <= 16'd16384; // 1<<14
                    state   <= 3'd3;
                end
                3'd3: begin
                    // Ensure 'bit' is not greater than the number
                    if (b > num)
                        b <= b >> 2;
                    else
                        state <= 3'd4;
                end
                3'd4: begin
                    // Iterative square root calculation:
                    if (b != 0) begin
                        if (num >= result + b) begin
                            num     <= num - (result + b);
                            result  <= result + b; // Corrected line
                        end
                        b <= b >> 2;
                    end else begin
                        state <= 3'd5;
                    end
                end
                3'd5: begin
                    // Output the computed square root (lower 8 bits)
                    uo_out <= result[7:0];
                    state  <= 3'd0; // Ready for next computation cycle
                end
                default: state <= 3'd0;
            endcase
        end
    end

    // Assign unused outputs to constant values
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

endmodule
