`default_nettype none

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,     // x input
    input  wire [7:0] uio_in,    // y input
    input  wire [7:0] uio_extra, // z input (NEW)
    output wire [7:0] uio_out,   // theta output
    output wire [7:0] uo_out,    // r output
    output wire [7:0] uo_extra_out, // phi output (NEW)
    output wire [7:0] uio_oe,    // IO enable (set to output mode)
    input  wire       ena,       // Enable signal
    input  wire       clk,       // Clock signal
    input  wire       rst_n      // Active-low reset
);

    wire [15:0] x2, y2, z2, sum_xy, sum_xyz;
    reg  [7:0] r_reg, theta_reg, phi_reg;

    assign x2 = ui_in * ui_in;
    assign y2 = uio_in * uio_in;
    assign z2 = uio_extra * uio_extra;  // Include z²
    assign sum_xy = x2 + y2;
    assign sum_xyz = sum_xy + z2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
            phi_reg <= 8'd0;
        end else if (ena) begin
            // Approximate sqrt using bit shift method
            r_reg <= (sum_xyz[15:8] + sum_xyz[14:7]) >> 1;  

            // Approximate atan(y/x)
            if (uio_in == 0)
                theta_reg <= 8'd90;
            else
                theta_reg <= (ui_in << 4) / uio_in;  // Scale by 16 for better precision

            // Approximate atan(z / sqrt(x² + y²)) for phi
            phi_reg <= (uio_extra << 4) / (sum_xy >> 8);
        end
    end

    assign uo_out = r_reg;         // r output (magnitude)
    assign uio_out = theta_reg;    // theta output (angle)
    assign uo_extra_out = phi_reg; // phi output (NEW)
    assign uio_oe = 8'b11111111;   // Set all IOs to output mode

endmodule
