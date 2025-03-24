module tt_um_addon (
    input  wire [7:0] ui_in,
    input  wire [7:0] uio_in,
    output reg  [7:0] uo_out,
    output wire [7:0] uio_out,  // Add this line
    output wire [7:0] uio_oe,   // Add this line
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b0; // Default assignment (modify as needed)
    assign uio_oe  = 8'b0; // Default assignment (modify as needed)

    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else if (ena) begin
            square_x    <= ui_in * ui_in;
            square_y    <= uio_in * uio_in;
            sum_squares <= square_x + square_y;

            // Square root calculation
            reg [7:0] sqrt_temp;
            integer n;
            sqrt_temp = 0;
            for (n = 7; n >= 0; n = n - 1) begin
                if (((sqrt_temp | (1 << n)) * (sqrt_temp | (1 << n))) <= sum_squares)
                    sqrt_temp = sqrt_temp | (1 << n);
            end
            uo_out <= sqrt_temp;
        end
    end

endmodule
