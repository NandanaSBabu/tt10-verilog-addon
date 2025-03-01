`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // X input
    output wire [7:0] uo_out,   // R output
    input  wire [7:0] uio_in,   // Y input
    output wire [7:0] uio_out,  // Theta output
    output wire [7:0] uio_oe,   // IO Enable path
    input  wire       ena,      // Always 1 when powered
    input  wire       clk,      // Clock (unused)
    input  wire       rst_n     // Active-low reset (unused)
);

    wire [15:0] x_sq, y_sq, sum_xy;
    wire [7:0] sqrt_r;
    wire [7:0] atan_theta;

    // Compute x^2 and y^2
    assign x_sq = ui_in * ui_in;
    assign y_sq = uio_in * uio_in;
    assign sum_xy = x_sq + y_sq;

    // Compute r = sqrt(x^2 + y^2)
    sqrt_approx sqrt_inst (.in(sum_xy), .out(sqrt_r));

    // Compute theta = atan2(y, x)
    atan2_lut atan_inst (.x(ui_in), .y(uio_in), .theta(atan_theta));

    // Assign outputs
    assign uo_out  = sqrt_r;       // r output
    assign uio_out = atan_theta;   // theta output
    assign uio_oe  = 8'b11111111;  // Enable all outputs

    // Prevent warnings for unused signals
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
