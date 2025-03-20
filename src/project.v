`default_nettype none

module tt_um_project (
	input wire [7:0] ui_in, 
	input wire [7:0] uio_in, 
    input wire clk, 
    input wire rst_n, 
	output reg [7:0] uo_out
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
            uo_out <= 8'b0;
        end else begin
            // Compute sum of squares without *
            sum_squares = square(x) + square(y);

            // Compute square root using bitwise approach
            result = 0;
            for (b = 7; b >= 0; b = b - 1) begin
                if (square(result + (1 << b)) <= sum_squares)
                    result = result + (1 << b);
            end

            uo_out <= result;
        end
    end

endmodule
