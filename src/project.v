`default_nettype none

module sqrt_pythagoras (
    input wire [7:0] x, 
    input wire [7:0] y, 
    input wire clk, 
    input wire rst_n, 
    output reg [7:0] sqrt_out
);

    reg [15:0] sum_squares;
    reg [7:0] result;
    reg [15:0] square_x, square_y;
    reg [15:0] temp_square;
    reg [7:0] temp;
    integer b;
    integer count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            sqrt_out <= 8'b0;
        end else begin
            // Compute square of x using a constant limit
            square_x = 0;
            for (count = 0; count < 256; count = count + 1) begin
                if (count < x) 
                    square_x = square_x + x;
            end

            // Compute square of y using a constant limit
            square_y = 0;
            for (count = 0; count < 256; count = count + 1) begin
                if (count < y) 
                    square_y = square_y + y;
            end

            // Compute sum of squares
            sum_squares = square_x + square_y;

            // Compute square root using bitwise approach
            result = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                temp = result + (1 << b);
                temp_square = 0;
                
                // Compute square of temp using a constant limit
                for (count = 0; count < 256; count = count + 1) begin
                    if (count < temp)
                        temp_square = temp_square + temp;
                end

                if (temp_square <= sum_squares)
                    result = temp;
            end

            sqrt_out <= result;
        end
    end

endmodule
