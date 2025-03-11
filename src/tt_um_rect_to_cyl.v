module tt_um_rect_to_cyl (
    input [7:0] x, y, // 8-bit Cartesian coordinates
    input [7:0] z,    // 8-bit z-coordinate (unchanged)
    output [7:0] r,   // 8-bit radius r = sqrt(x^2 + y^2)
    output [7:0] theta, // 8-bit angle θ = atan(y/x)
    output [7:0] z_out // Unchanged z-coordinate
);
    
    wire [15:0] x2, y2, sum; // Squaring wires

    assign x2 = x * x;
    assign y2 = y * y;
    assign sum = x2 + y2;

    // Compute sqrt(x² + y²)
    sqrt sqrt_inst (
        .in(sum),
        .out(r)
    );

    // Compute atan(y/x)
    atan atan_inst (
        .x(x),
        .y(y),
        .theta(theta)
    );

    assign z_out = z; // z remains unchanged

endmodule
