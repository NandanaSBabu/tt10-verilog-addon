module tt_um_project (
    input [7:0] x, y,  // 8-bit Cartesian coordinates
    input [7:0] z,     // 8-bit z-coordinate (unchanged)
    output [7:0] r,    // 8-bit radius r = sqrt(x^2 + y^2)
    output [7:0] theta, // 8-bit angle θ = atan(y/x)
    output [7:0] z_out // Unchanged z-coordinate
);
    
    wire [15:0] x2, y2, sum; // Squaring wires

    assign x2 = x * x;
    assign y2 = y * y;
    assign sum = x2 + y2;

    // Approximate sqrt(x² + y²) using a simple bit shift (faster for FPGA)
    assign r = sum[15:8]; // Rough sqrt approximation

    // Approximate atan(y/x) using a lookup table
    reg [7:0] atan_lut [0:15];  // Smaller LUT
    initial begin
        atan_lut[0] = 8'd0;  
        atan_lut[1] = 8'd14;  
        atan_lut[2] = 8'd28;  
        atan_lut[3] = 8'd38;
        atan_lut[4] = 8'd45;  
        atan_lut[5] = 8'd52;
        atan_lut[6] = 8'd58;
        atan_lut[7] = 8'd63;
        atan_lut[8] = 8'd67;
        atan_lut[9] = 8'd71;
        atan_lut[10] = 8'd75;
        atan_lut[11] = 8'd78;
        atan_lut[12] = 8'd81;
        atan_lut[13] = 8'd84;
        atan_lut[14] = 8'd87;
        atan_lut[15] = 8'd90; 
    end

    always @(*) begin
        if (x == 0)
            theta = 8'd90;  // If x = 0, theta = 90°
        else
            theta = atan_lut[(y >> 4) / (x >> 4)];  // Approximate using 4-bit shifts
    end

    assign z_out = z; // z remains unchanged

endmodule
