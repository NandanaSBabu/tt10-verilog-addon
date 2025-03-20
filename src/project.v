`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output reg  [7:0] uo_out,   // sqrt_out output
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       clk,      // clock
    input  wire       rst_n,    // active-low reset
    input  wire       ena       // ✅ Added ena control
);

    reg [15:0] sum_squares;
    reg [7:0] result;
    integer b;

    // Function to compute square using repeated addition
    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        reg [7:0] count;
        begin
            s = 0;
            if (a > 0) begin
                count = a;
                while (count > 0) begin
                    s = s + a;  // Repeated addition (avoiding multiplication)
                    count = count - 1;
                end
            end
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin  // ✅ Only update when ena = 1
            // Compute sum of squares
            sum_squares <= square(ui_in) + square(uio_in);

            // Compute square root using bitwise method
            result = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end

            // Ensure output updates immediately
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
