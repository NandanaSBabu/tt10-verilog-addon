`default_nettype none

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output wire [7:0] uio_out,  // theta output
    output wire [7:0] uo_out,   // r output
    output wire [7:0] uio_oe,   // IO enable (set to output mode)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    wire [15:0] x2, y2, sum;
    reg  [7:0] r_reg, theta_reg;

    assign x2 = ui_in * ui_in;
    assign y2 = uio_in * uio_in;
    assign sum = x2 + y2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
        end else if (ena) begin
            // Approximate square root using bit shift method
            r_reg <= (sum[15:8] + sum[14:7]) >> 1;  

            // Approximate atan(y/x) using scaled division
            if (uio_in == 0)
                theta_reg <= 8'd90;  // Vertical line, angle = 90°
            else
                theta_reg <= (ui_in << 4) / uio_in; // Scale by 16 for better precision
        end
    end

    assign uo_out = r_reg;      // r output (magnitude)
    assign uio_out = theta_reg; // theta output (angle)
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
