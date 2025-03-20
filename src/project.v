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
    reg [7:0] result;
    integer i;
    reg [15:0] square_check;

    // Function to compute square using repeated addition
    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            count = a;
            while (count > 0) begin
                s = s + a;
                count = count - 1;
            end
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares
            sum_squares = square(ui_in) + square(uio_in);

            // Compute square root using subtraction method
            result = 0;
            square_check = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                if ((square_check + ((result | (1 << i)) * (result | (1 << i)))) <= sum_squares) begin
                    result = result | (1 << i);
                    square_check = square_check + (result * result);
                end
            end

            // Assign output
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
