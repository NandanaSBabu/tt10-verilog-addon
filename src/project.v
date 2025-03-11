module tt_um_project(
    input  [7:0] x, y, z,  // 8-bit inputs for x, y, z
    output [7:0] r, theta, z_out // 8-bit outputs for r, theta, z_out
);

    wire [15:0] x_sq, y_sq, sum_sq;
    wire [7:0] sqrt_r;
    wire [7:0] atan_theta;

    // Compute x^2 and y^2 (using 8-bit multiplication, result is 16-bit)
    assign x_sq = x * x;
    assign y_sq = y * y;
    assign sum_sq = x_sq + y_sq;

    // Compute square root using improved approximation
    SquareRoot sqrt_unit(
        .in(sum_sq[15:8]), // Use upper 8 bits for approximation
        .out(sqrt_r)
    );
    
    // Compute arctan(y/x) using lookup table
    ArctanLUT atan_unit(
        .x(x), .y(y),
        .theta(atan_theta)
    );
    
    assign r = sqrt_r;
    assign theta = atan_theta;
    assign z_out = z; // Pass z unchanged

endmodule

// Improved Square Root Approximation
module SquareRoot(
    input  [7:0] in,
    output reg [7:0] out
);
    always @(*) begin
        case (in)
            8'd0: out = 8'd0;
            8'd1: out = 8'd1;
            8'd4: out = 8'd2;
            8'd9: out = 8'd3;
            8'd16: out = 8'd4;
            8'd25: out = 8'd5;
            8'd36: out = 8'd6;
            8'd49: out = 8'd7;
            8'd64: out = 8'd8;
            default: out = (in >> 4) + 1; // Basic interpolation for unknown values
        endcase
    end
endmodule

// Improved Arctan Approximation with Safe Division Handling
module ArctanLUT(
    input  [7:0] x, y,
    output reg [7:0] theta
);
    reg [7:0] ratio;
    always @(*) begin
        if (x == 0) begin
            theta = (y == 0) ? 8'd0 : 8'd90; // Handle (0,0) safely
        end else begin
            ratio = (y << 8) / x; // Compute y/x scaled to 8-bit
            case (ratio)
                8'd0:   theta = 8'd0;
                8'd26:  theta = 8'd15;
                8'd46:  theta = 8'd26;
                8'd77:  theta = 8'd45;
                8'd129: theta = 8'd63;
                8'd198: theta = 8'd75;
                8'd255: theta = 8'd85;
                default: theta = (ratio < 8'd26) ? 8'd10 : 8'd90; // Improved fallback
            endcase
        end
    end
endmodule
