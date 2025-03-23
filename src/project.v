`default_nettype none
module tt_um_addon (
    input wire clk,
    input wire rst_n,
    input wire ena,
    input wire [7:0] x,
    input wire [7:0] y,
    output reg [7:0] uo_out
);

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [7:0] temp;
    reg [3:0] i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            sqrt_result <= 0;
            temp <= 0;
            i <= 0;
            uo_out <= 0;
        end else if (ena) begin
            sum_squares <= (x * x) + (y * y);
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
