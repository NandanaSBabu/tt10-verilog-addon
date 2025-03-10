module RectToCylConverter(
    input  signed [15:0] x, // 16-bit signed input for x
    input  signed [15:0] y, // 16-bit signed input for y
    input  signed [15:0] z, // 16-bit signed input for z
    output signed [15:0] r, // 16-bit signed output for r
    output signed [15:0] theta, // 16-bit signed output for theta
    output signed [15:0] z_out // 16-bit signed output for z
);
    
    wire signed [31:0] x_sq, y_sq, sum_sq;
    wire signed [15:0] sqrt_r;
    
    // Squaring x and y (x^2 and y^2)
    assign x_sq = x * x;
    assign y_sq = y * y;
    
    // Sum of squares
    assign sum_sq = x_sq + y_sq;
    
    // Compute r using a simple square root approximation
    function [15:0] sqrt_approx;
        input [31:0] num;
        integer i;
        reg [15:0] result;
        begin
            result = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                if ((result | (1 << i)) * (result | (1 << i)) <= num)
                    result = result | (1 << i);
            end
            sqrt_approx = result;
        end
    endfunction
    
    assign sqrt_r = sqrt_approx(sum_sq);
    assign r = sqrt_r;
    
    // Compute theta using atan2 approximation (CORDIC is recommended for FPGA)
    function [15:0] atan2_approx;
        input signed [15:0] y, x;
        begin
            if (x == 0)
                atan2_approx = (y > 0) ? 16'h4000 : 16'hC000; // Approximate ±π/2
            else
                atan2_approx = (y * 16384) / x; // Basic division-based approximation
        end
    endfunction
    
    assign theta = atan2_approx(y, x);
    assign z_out = z;
    
endmodule
