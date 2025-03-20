`default_nettype none

module tt_um_addon (
    input wire [7:0] ui_in,    // x input
    input wire [7:0] uio_in,   // y input
    output wire [7:0] uo_out,  // sqrt_out output
    output wire [7:0] uio_out, // IOs: Output path (unused)
    output wire [7:0] uio_oe,  // IOs: Enable path (unused)
    input wire ena,            // always 1 when the design is powered
    input wire clk,            // clock
    input wire rst_n           // active-low reset
);

    reg [15:0] sum_squares;
    reg [7:0] result;
    integer b;

    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            count = a;
            while (count > 0) begin
                s = s + a;  // Repeated addition
                count = count - 1;
            end
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;  // Initial value, but won't reset on each input
        end else begin
            // Compute sum of squares
            sum_squares = square(ui_in) + square(uio_in);
            
            // Debug: Display intermediate values
            $display("x = %d, y = %d, sum_squares = %d, result = %d", ui_in, uio_in, sum_squares, result);
            
            // Compute square root using bitwise approach
            for (b = 7; b >= 0; b = b - 1) begin
                // Try adding 2^b to the result and check if it's a valid square
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end
        end
    end

    // Correctly assign the output
    assign uo_out = result;  // Ensure this is correctly assigned to uo_out
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena};

endmodule
