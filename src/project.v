`default_nettype none
module tt_um_addon (
    input wire clk,
    input wire rst_n,
    input wire ena,
    input wire [7:0] ui_in,
    input wire [7:0] uio_in,
    output reg [7:0] uo_out
);

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [7:0] temp;
    reg [3:0] i;
    reg computing;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            sqrt_result <= 0;
            temp <= 0;
            i <= 0;
            computing <= 0;
            uo_out <= 0;
        end else if (ena && !computing) begin
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
            temp <= 0;
            sqrt_result <= 0;
            i <= 7;
            computing <= 1;
        end else if (computing && i > 0) begin
            temp = (sqrt_result | (1 << (i - 1)));
            if (temp * temp <= sum_squares)
                sqrt_result = temp;
            i = i - 1;
        end else if (computing && i == 0) begin
            uo_out <= sqrt_result; // Assign result after computation
            computing <= 0;
        end
    end
endmodule
