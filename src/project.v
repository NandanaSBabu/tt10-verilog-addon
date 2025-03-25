`timescale 1ns / 1ps

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output reg [7:0] uio_out,   // theta output (integer part only)
    output reg [7:0] uo_out,    // r output
    output wire [7:0] uio_oe,   // IO enable (set to output mode)
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    reg [15:0] sum;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
            uio_out <= 8'd0;
        end else if (ena) begin
            // Compute sum = x^2 + y^2
            sum = (ui_in * ui_in) + (uio_in * uio_in);
            
            // Compute sqrt(sum) using bitwise method
            uo_out = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                if ((uo_out + (1 << i)) * (uo_out + (1 << i)) <= sum)
                    uo_out = uo_out + (1 << i);
            end
            
            // Compute atan(y/x) using LUT-based approximation (integer degrees only)
            if (ui_in == 0)
                uio_out = (uio_in > 0) ? 8'd90 : 8'd270; // 90° or 270°
            else
                uio_out = (uio_in * 45) / ui_in; // Approximate atan(y/x) in degrees
        end
    end

    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
