`default_nettype none

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output wire [7:0] uio_out,  // theta output
    output wire [7:0] uo_out,   // r output
    output wire [7:0] uio_oe,   // IO enable (all set to 0 for input mode)
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
            r_reg <= sum[15:8];  // Approximate sqrt(x² + y²)
            theta_reg <= (uio_in == 0) ? 8'd90 : (ui_in / uio_in); // Approximate atan(y/x)
        end
    end

    assign uo_out = r_reg;      // r output
    assign uio_out = theta_reg; // theta output
    assign uio_oe = 8'b00000000; // Set all IOs to input mode

endmodule
