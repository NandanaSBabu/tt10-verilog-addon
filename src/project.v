`timescale 1ns / 1ps

module project (
    input signed [7:0] x,   // X coordinate
    input signed [7:0] y,   // Y coordinate
    output reg signed [7:0] r,  // Radius
    output reg signed [7:0] theta // Angle in degrees
);

    always @(*) begin
        // Compute r using an approximation
        r = $sqrt(x * x + y * y);

        // Compute theta using simple lookup method
        if (x == 0 && y == 0) begin
            theta = 0;
        end else if (x >= 0) begin
            theta = $rtoi($atan2(y, x) * 180.0 / 3.14159);
        end else begin
            theta = 180 + $rtoi($atan2(y, x) * 180.0 / 3.14159);
        end
    end

endmodule
