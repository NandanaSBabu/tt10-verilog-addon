module sqrt_approx (
    input [15:0] in,
    output reg [7:0] out
);
    always @(*) begin
        case (in[15:8])  // Use high bits for LUT
            8'h00: out = 8'h00;
            8'h01: out = 8'h10;
            8'h02: out = 8'h16;
            8'h04: out = 8'h20;
            8'h08: out = 8'h30;
            8'h10: out = 8'h40;
            8'h20: out = 8'h50;
            default: out = 8'h60; // Approximation for larger values
        endcase
    end
endmodule
