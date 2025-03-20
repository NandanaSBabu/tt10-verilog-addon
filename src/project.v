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
    reg [15:0] sqrt_result;
    reg [15:0] temp;
    reg [15:0] add_x, add_y;
    reg [7:0] step;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 16'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute x^2 using repeated addition (unrolled)
            add_x = 0;
            if (ui_in[0]) add_x = add_x + ui_in;
            if (ui_in[1]) add_x = add_x + (ui_in << 1);
            if (ui_in[2]) add_x = add_x + (ui_in << 2);
            if (ui_in[3]) add_x = add_x + (ui_in << 3);
            if (ui_in[4]) add_x = add_x + (ui_in << 4);
            if (ui_in[5]) add_x = add_x + (ui_in << 5);
            if (ui_in[6]) add_x = add_x + (ui_in << 6);
            if (ui_in[7]) add_x = add_x + (ui_in << 7);
            square_x = add_x;

            // Compute y^2 using repeated addition (unrolled)
            add_y = 0;
            if (uio_in[0]) add_y = add_y + uio_in;
            if (uio_in[1]) add_y = add_y + (uio_in << 1);
            if (uio_in[2]) add_y = add_y + (uio_in << 2);
            if (uio_in[3]) add_y = add_y + (uio_in << 3);
            if (uio_in[4]) add_y = add_y + (uio_in << 4);
            if (uio_in[5]) add_y = add_y + (uio_in << 5);
            if (uio_in[6]) add_y = add_y + (uio_in << 6);
            if (uio_in[7]) add_y = add_y + (uio_in << 7);
            square_y = add_y;

            // Compute sum of squares
            sum_squares = square_x + square_y;

            // Compute square root using subtractive method (unrolled)
            sqrt_result = 0;
            temp = sum_squares;
            step = 128; // Start with largest bit

            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;
            step = step >> 1;
            if ((sqrt_result + step) <= temp - (sqrt_result + step)) sqrt_result = sqrt_result + step;

            uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
