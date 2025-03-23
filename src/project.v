`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // x input
    input  wire [7:0] uio_in,   // y input
    output reg  [7:0] uo_out,   // sqrt_out output
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       clk,      // clock
    input  wire       rst_n,    // active-low reset
    input  wire       ena       // Enable signal
);

    reg [15:0] sum_squares;
    reg [15:0] square_x, square_y;
    reg [7:0] result, temp_res;
    integer b, i, j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute squares using loops (avoiding multiplication)
            square_x = 0;
            square_y = 0;
            for (i = 0; i < ui_in; i = i + 1) begin
                square_x = square_x + ui_in;
            end
            for (i = 0; i < uio_in; i = i + 1) begin
                square_y = square_y + uio_in;
            end

            // Compute sum of squares
            sum_squares = square_x + square_y;

            // Compute square root using repeated addition
            result = 0;
            temp_res = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                temp_res = result + (1 << b);
                
                // Compute temp_res * temp_res without using `*`
                reg [15:0] temp_sq;
                temp_sq = 0;
                for (j = 0; j < temp_res; j = j + 1) begin
                    temp_sq = temp_sq + temp_res;
                end
                
                if (temp_sq <= sum_squares) begin
                    result = temp_res;
                end
            end

            // Assign output
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
