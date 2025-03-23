`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // x input
    output wire [7:0] uo_out,   // output result
    input  wire [7:0] uio_in,   // y input
    output wire [7:0] uio_out,  // unused output
    output wire [7:0] uio_oe,   // unused enable
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // active low reset
);

    reg [7:0] x_reg, y_reg;
    reg [15:0] square_x, square_y, sum_squares;
    reg [7:0] result;
    reg valid_input;

    integer i, j;
    reg [15:0] temp, temp_square;

    // Function to compute square without multiplication
    function [15:0] square(input [7:0] num);
        reg [15:0] acc;
        begin
            acc = 0;
            for (j = 0; j < num; j = j + 1)
                acc = acc + num;  
            square = acc;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_reg <= 0;
            y_reg <= 0;
            square_x <= 0;
            square_y <= 0;
            sum_squares <= 0;
            result <= 0;
            valid_input <= 0;
        end else begin
            if (ui_in != 0 || uio_in != 0) begin  
                valid_input <= 1;  
            end
            
            if (valid_input) begin  
                x_reg <= ui_in;
                y_reg <= uio_in;
                
                // Compute squares
                square_x <= square(x_reg);
                square_y <= square(y_reg);
                
                // Compute sum of squares
                sum_squares <= square_x + square_y;

                // Compute square root using repeated addition
                result = 0;
                temp = 0;
                for (i = 7; i >= 0; i = i - 1) begin
                    temp = result | (1 << i);
                    
                    // Compute square of temp without *
                    temp_square = 0;
                    for (j = 0; j < temp; j = j + 1)
                        temp_square = temp_square + temp;

                    if (temp_square <= sum_squares)
                        result = temp;
                end
            end
        end
    end

    assign uo_out = valid_input ? result : 8'b0;  
    assign uio_out = 8'b00000000;  
    assign uio_oe  = 8'b00000000;  

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            $display("RESET: square_x=%d, square_y=%d, sum_squares=%d, result=%d", square_x, square_y, sum_squares, result);
        end else if (valid_input) begin
            $display("COMPUTE: square_x=%d, square_y=%d, sum_squares=%d, result=%d", square_x, square_y, sum_squares, result);
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
