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

    // Square of inputs
    assign x2 = ui_in * ui_in;
    assign y2 = uio_in * uio_in;
    assign sum = x2 + y2;  // x² + y²

    // Approximate square root using bitwise shift
    function [7:0] sqrt_approx;
        input [15:0] val;
        begin
            sqrt_approx = val[15:8] + val[14:7]; // Rough sqrt estimation
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
        end else if (ena) begin
            // Compute radius r = sqrt(x² + y²)
            r_reg <= sqrt_approx(sum);

            // Compute theta using a simple atan approximation
            if (ui_in == 0 && uio_in == 0)
                theta_reg <= 8'd0;  // Undefined case, set to 0
            else if (ui_in == 0)
                theta_reg <= 8'd90; // Vertical line
            else
                theta_reg <= (uio_in * 45) / ui_in; // Approximate atan(y/x)
        end
    end

    assign uo_out = r_reg;      // Output r (magnitude)
    assign uio_out = theta_reg; // Output theta (angle)
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
