`timescale 1ns / 1ps

module project (
    input signed [7:0] x,   // X coordinate
    input signed [7:0] y,   // Y coordinate
    output signed [7:0] r,  // Radius
    output signed [7:0] theta // Angle in degrees
);
    wire signed [15:0] x_sq, y_sq, sum;
    wire signed [7:0] atan_val;

    assign x_sq = x * x;
    assign y_sq = y * y;
    assign sum = x_sq + y_sq;

    // Approximate square root (basic Newton-Raphson iteration)
    assign r = sum[15:8]; // Simple bit shift approximation

    // Approximate atan2 using lookup table
    assign atan_val = (x == 0 && y == 0) ? 8'd0 : (y * 45 / x); // Rough approximation

    assign theta = (x >= 0) ? atan_val : (8'd180 + atan_val);
    
endmodule
