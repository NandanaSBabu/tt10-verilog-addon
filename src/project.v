`default_nettype none
module tt_um_addon (
    input wire clk,          // Clock signal
    input wire rst_n,        // Active-low reset
    input wire ena,          // Enable signal
    input wire [7:0] ui_in,  // Input x
    input wire [7:0] uio_in, // Input y
    output reg [7:0] uo_out, // Output sqrt(x^2 + y^2)
    output wire [7:0] uio_out, // Extra output (set to 0)
    output wire [7:0] uio_oe   // Output enable (set to 0)
);

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [7:0] temp;
    reg [3:0] i;

    assign uio_out = 8'b0; // Default output to prevent errors
    assign uio_oe = 8'b0;  // Default output enable to prevent errors

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            sqrt_result <= 0;
            temp <= 0;
            i <= 0;
            uo_out <= 0;
        end else if (ena) begin
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
            temp <= 0;
            sqrt_result <= 0;
            i <= 7;
        end else if (i > 0) begin
            temp <= (sqrt_result << 1) | (1 << (i - 1));
            if (temp * temp <= sum_squares)
                sqrt_result <= temp;
            i <= i - 1;
        end else begin
            uo_out <= sqrt_result;
        end
    end
endmodule
