`default_nettype none

module tt_um_addon (
    input wire [7:0] ui_in,    // x input
    input wire [7:0] uio_in,   // y input
    output wire [7:0] uo_out,  // sqrt_out output
    output wire [7:0] uio_out, // IOs: Output path (unused)
    output wire [7:0] uio_oe,  // IOs: Enable path (unused)
    input wire clk,            // clock
    input wire rst_n,          // active-low reset
    input wire ena             // enable signal
);

    reg [15:0] sum_squares;  // To store sum of squares
    reg [7:0] result;        // To store the result (sqrt approximation)
    integer b;               // Loop variable

    // Square function using repeated addition
    function [15:0] square;
        input [7:0] a;
        integer i;
        begin
            square = 0;
            for (i = 0; i < a; i = i + 1) begin
                square = square + a;  // Repeated addition to compute square
            end
        end
    endfunction

    // Always block triggered on clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;  // Keep result as 0 on reset
        end else if (ena) begin
            // Compute sum of squares only when ena is high
            sum_squares = square(ui_in) + square(uio_in);
            
            // Debug: Display intermediate values (optional)
            $display("x = %d, y = %d, sum_squares = %d, result = %d", ui_in, uio_in, sum_squares, result);
            
            // Compute square root using bitwise approach
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end
        end
    end

    // Assign the output (result will hold the square root approximation)
    assign uo_out = result;  // Output the result
    assign uio_out = 8'b0;    // Unused IO
    assign uio_oe  = 8'b0;    // Unused IO enable

endmodule
