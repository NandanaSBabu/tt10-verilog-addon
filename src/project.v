`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square root output
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [7:0] sqrt_lut [0:65535]; // Lookup table for sqrt(x^2 + y^2)
    
    // LUT Initialization
    integer x, y, index;
    function [7:0] sqrt_approx;
        input [15:0] value;
        integer n;
        begin
            sqrt_approx = 0;
            for (n = 15; n >= 0; n = n - 1) begin
                if ((sqrt_approx | (1 << n)) * (sqrt_approx | (1 << n)) <= value)
                    sqrt_approx = sqrt_approx | (1 << n);
            end
        end
    endfunction

    initial begin
        for (x = 0; x < 256; x = x + 1) begin
            for (y = 0; y < 256; y = y + 1) begin
                index = (x << 8) | y;  // Proper LUT indexing
                sqrt_lut[index] = sqrt_approx((x*x) + (y*y)); // Approximate sqrt
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            uo_out <= sqrt_lut[(ui_in << 8) | uio_in]; // Fetch from LUT
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
