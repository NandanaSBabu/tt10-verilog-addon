`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs (x and y)
    output wire [7:0] uo_out,   // Dedicated outputs (sqrt_out)
    input  wire [7:0] uio_in,   // IOs: Input path (unused)
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg [15:0] sum_squares;
    reg [7:0] result;
    integer b;

    function [15:0] square;
        input [7:0] a;
        reg [15:0] s;
        integer i;
        begin
            s = 0;
            for (i = 0; i < 8; i = i + 1)
                if (a[i]) s = s + (a << i);  // Shift-add squaring
            square = s;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
        end else begin
            // Compute sum of squares without *
            sum_squares = square(ui_in[3:0]) + square(ui_in[7:4]);

            // Compute square root using bitwise approach
            result = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end
        end
    end

    assign uo_out = result;  // Output sqrt result
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena};

endmodule
