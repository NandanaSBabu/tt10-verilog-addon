module tt_um_cartesian_to_cylindrical (
    input clk,
    input reset,
    input [3:0] x,
    input [3:0] y,
    output reg [3:0] r,
    output reg [3:0] theta
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r <= 4'd0;
            theta <= 4'd0;
        end else begin
            // Approximate r = sqrt(x^2 + y^2) using bit-shifting
            r <= (x > y) ? x + (y >> 1) : y + (x >> 1);
            
            // Approximate theta = atan(y/x) using a lookup table
            case ({x, y})
                8'b00010000: theta <= 4'd0;   // 0°
                8'b00010001: theta <= 4'd7;   // ~7°
                8'b00010010: theta <= 4'd14;  // ~14°
                8'b00010100: theta <= 4'd27;  // ~27°
                8'b00011000: theta <= 4'd45;  // ~45°
                8'b00011100: theta <= 4'd63;  // ~63°
                8'b00100000: theta <= 4'd90;  // 90°
                default: theta <= 4'd0;
            endcase
        end
    end

endmodule
