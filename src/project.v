`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out,   
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

    reg [7:0] x_reg, y_reg;
    reg [15:0] square_x, square_y, sum_squares;
    reg [7:0] result;
    reg valid_input;
    reg [3:0] state;
    
    // Function to compute square using repeated addition
    function [15:0] square(input [7:0] num);
        reg [15:0] sum;
        reg [7:0] i;
        begin
            sum = 0;
            for (i = 0; i < num; i = i + 1) begin
                sum = sum + num;
            end
            square = sum;
        end
    endfunction

    // Integer square root using bitwise method
    function [7:0] sqrt(input [15:0] num);
        reg [15:0] rem;
        reg [7:0] res;
        reg [7:0] bit;
        begin
            rem = num;
            res = 0;
            bit = 1 << 14;  // Start from the highest power of 4 in a 16-bit number

            while (bit > 0) begin
                if (rem >= (res | bit)) begin
                    rem = rem - (res | bit);
                    res = (res >> 1) | bit;
                end else begin
                    res = res >> 1;
                end
                bit = bit >> 2;
            end
            sqrt = res;
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
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (ui_in != 0 || uio_in != 0) begin
                        x_reg <= ui_in;
                        y_reg <= uio_in;
                        valid_input <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    square_x <= square(x_reg);
                    square_y <= square(y_reg);
                    state <= 2;
                end
                2: begin
                    sum_squares <= square_x + square_y;
                    state <= 3;
                end
                3: begin
                    result <= sqrt(sum_squares);
                    state <= 4;
                end
                4: begin
                    state <= 0;  
                end
            endcase
        end
    end

    assign uo_out = valid_input ? result : 8'b0;  
    assign uio_out = 8'b00000000;  
    assign uio_oe  = 8'b00000000;  

endmodule
