module atan2_lut (
    input signed [7:0] x, y,
    output reg [7:0] theta
);
    always @(*) begin
        if (x == 0)
            theta = (y >= 0) ? 8'h40 : 8'hC0;  // 90° or -90°
        else if (y == 0)
            theta = (x > 0) ? 8'h00 : 8'h80;   // 0° or 180°
        else
            theta = (y > 0) ? 8'h20 : 8'hE0;   // Approximate
    end
endmodule
