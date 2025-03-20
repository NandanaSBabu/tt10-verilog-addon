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
    integer b;

    function [15:0] square;
    	input [7:0] a;
    	reg [15:0] s;
    	reg [7:0] count;
    	begin
        	s = 0;
        	count = a;
        	while (count > 0) begin
            	s = s + a;  // Repeated addition
            	count = count - 1;
        	end
        	square = s;
    	end
	endfunction


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            sqrt_out <= 8'b0;
        end else begin
            // Compute sum of squares without using multiplication
            sum_squares = square(x) + square(y);

            // Initialize result to 0 before starting square root calculation
            result = 0;

            // Bitwise approach to calculate square root
            for (b = 7; b >= 0; b = b - 1) begin
                // Check if adding the bitwise shift to result yields a value whose square is <= sum_squares
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end

            // Assign the result to sqrt_out (output)
            sqrt_out <= result;
        end
    end

endmodule
