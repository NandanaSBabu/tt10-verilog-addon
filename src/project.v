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

    reg [15:0] sum_squares, sum_squares_reg;
    reg [7:0] result_reg;
    integer b;

    // Function to compute square using repeated addition
    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            count = a;
            while (count > 0) begin
                s = s + a;  // Repeated addition (avoiding multiplication)
                count = count - 1;
            end
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sum_squares_reg <= 16'b0;
            result_reg <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            sum_squares <= square(ui_in) + square(uio_in);
            sum_squares_reg <= sum_squares;  // Pipeline to ensure correct update

            // Compute square root using bitwise method
            result_reg = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result_reg + (1 << b)) <= sum_squares_reg) 
                    result_reg = result_reg + (1 << b);
            end

            uo_out <= result_reg;  // Output result
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
