`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg [15:0] sum_squares;
    reg [15:0] square_x, square_y;
    reg [7:0] result;
    reg [15:0] temp, temp_square;
    integer i, j;

    // Function to compute square without multiplication
    function [15:0] square(input [7:0] num);
        reg [15:0] acc;
        begin
            acc = 0;
            for (j = 0; j < num; j = j + 1)
                acc = acc + num;  // Square using repeated addition
            square = acc;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 0;
            square_y <= 0;
            sum_squares <= 0;
            result <= 0;
            $display("RESET: square_x=%d, square_y=%d, sum_squares=%d, result=%d", square_x, square_y, sum_squares, result);
        end else begin
            square_x = square(ui_in);   // Compute square
            square_y = square(uio_in);  // Compute square
            sum_squares = square_x + square_y;

            // Compute square root using repeated addition
            result = 0;
            temp = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                temp = result | (1 << i);  // Try setting the next bit

                // Compute square of temp without *
                temp_square = 0;
                for (j = 0; j < temp; j = j + 1)
                    temp_square = temp_square + temp;

                if (temp_square <= sum_squares)
                    result = temp;
            end
            
            $display("COMPUTE: square_x=%d, square_y=%d, sum_squares=%d, result=%d", square_x, square_y, sum_squares, result);
        end
    end

    assign uo_out = result;
    assign uio_out = 8'b00000000;  // Default output
    assign uio_oe  = 8'b00000000;  // Default output enable

    // Unused inputs
    wire _unused = &{ena, 1'b0};

endmodule
