`default_nettype none
module tt_um_addon (
    input  wire clk,
    input  wire rst_n,
    input  wire ena,
    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output reg  [7:0] uo_out,
    output wire [7:0] uio_out,  // Added output
    output wire [7:0] uio_oe    // Added output enable
);

    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;
    reg [15:0] result;
    reg [15:0] temp_sqrt;

    // Exact squaring function
    function [15:0] square;
        input [7:0] value;
        begin
            square = value * value;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 16'b0;
            square_y <= 16'b0;
            sum_squares <= 16'b0;
            temp_sqrt <= 16'b0;
            result <= 16'b0;
        end else if (ena) begin
            square_x <= square(ui_in);
            square_y <= square(uio_in);
            sum_squares <= square_x + square_y;
        end
    end

    // More accurate square root calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_sqrt <= 16'b0;
            result <= 16'b0;
        end else if (ena) begin
            temp_sqrt = 0;
            for (integer n = 15; n >= 0; n = n - 1) begin
                if ((temp_sqrt | (1 << n)) * (temp_sqrt | (1 << n)) <= sum_squares)
                    temp_sqrt = temp_sqrt | (1 << n);
            end
            result <= temp_sqrt;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            uo_out <= 8'b0;
        else if (ena)
            uo_out <= result[7:0];
    end

    assign uio_out = 8'b0; // No output on uio_out
    assign uio_oe = 8'b0;  // All uio pins are set as inputs

endmodule
