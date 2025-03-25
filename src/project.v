`default_nettype none

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output reg  [7:0] uio_out,  // theta output
    output reg  [7:0] uo_out,   // r output
    output wire [7:0] uio_oe,   // IO enable (set to output mode)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    wire [15:0] x2, y2, sum;
    reg  [7:0] r_reg, theta_reg;
    reg  [7:0] sqrt_approx;

    assign x2 = ui_in * ui_in;
    assign y2 = uio_in * uio_in;
    assign sum = x2 + y2;

    // Square root approximation using bit shifting (Newton's Method)
    always @(*) begin
        sqrt_approx = 8'd0;
        if (sum > 0) begin
            sqrt_approx = sum[15:8] + (sum[14:7] >> 1);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
        end else if (ena) begin
            r_reg <= sqrt_approx;

            // Compute atan(y/x) approximation
            if (ui_in == 0) begin
                theta_reg <= (uio_in == 0) ? 8'd0 : 8'd90;  // Handle (0,0) separately
            end else begin
                theta_reg <= (uio_in * 45) / ui_in; // Scale factor adjusted for better precision
            end
        end
    end

    assign uo_out = r_reg;      // r output (magnitude)
    assign uio_out = theta_reg; // theta output (angle)
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
