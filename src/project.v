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
    reg [7:0] temp;
    reg [15:0] square_check;
    reg [7:0] temp_count;

    // Function to compute square using repeated addition (avoiding multiplication)
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

            // Compute square root using bitwise method (avoiding multiplication)
            result = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                temp = result | (1 << i);
                
                // Compute temp * temp using repeated addition
                square_check = 0;
                temp_count = temp;
                while (temp_count > 0) begin
                    square_check = square_check + temp;
                    temp_count = temp_count - 1;
                end
                
                if (square_check <= sum_squares)
                    result = temp;
            end

            // Assign output in the same cycle
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
