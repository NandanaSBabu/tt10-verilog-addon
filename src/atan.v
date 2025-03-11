module atan (
    input [7:0] x, y,  // 8-bit Cartesian coordinates
    output reg [7:0] theta  // 8-bit angle output
);
    reg [7:0] atan_lut [0:255];  // LUT for atan(y/x)

    initial begin
        // Precomputed atan(y/x) values (scaled to 8-bit range 0-90°)
        atan_lut[0] = 8'd0;   // atan(0/1) = 0°
        atan_lut[1] = 8'd14;  // atan(1/8) ≈ 7.1°
        atan_lut[2] = 8'd28;  // atan(2/8) ≈ 14.0°
        atan_lut[4] = 8'd45;  // atan(4/8) ≈ 26.6°
        atan_lut[8] = 8'd63;  // atan(8/8) = 45°
        atan_lut[16] = 8'd76; // atan(16/8) ≈ 63.4°
        atan_lut[32] = 8'd85; // atan(32/8) ≈ 78.7°
        atan_lut[64] = 8'd90; // atan(64/8) ≈ 89°
        atan_lut[255] = 8'd90; // Cap at 90°
    end

    always @(*) begin
        if (x == 0)
            theta = 8'd90;  // If x = 0, theta = 90°
        else
            theta = atan_lut[y / (x + 1)];  // Safe lookup from LUT
    end
endmodule
