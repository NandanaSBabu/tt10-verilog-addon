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

    // Registers for multiplication
    reg [15:0] sum_squares, temp, bit;
    reg [7:0] x_reg, y_reg, sqrt_result;
    reg [7:0] x_mult, y_mult, x_count, y_count;
    reg [15:0] x_acc, y_acc;
    reg [3:0] step;
    reg mul_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_acc <= 16'b0;
            y_acc <= 16'b0;
            x_mult <= 8'b0;
            y_mult <= 8'b0;
            x_count <= 8'b0;
            y_count <= 8'b0;
            mul_done <= 1'b0;
        end else if (ena && !mul_done) begin
            if (x_count < x_mult) begin
                x_acc <= x_acc + x_mult;
                x_count <= x_count + 1;
            end else if (y_count < y_mult) begin
                y_acc <= y_acc + y_mult;
                y_count <= y_count + 1;
            end else begin
                sum_squares <= x_acc + y_acc;
                mul_done <= 1'b1;
            end
        end
    end

    // Square root approximation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sqrt_result <= 8'b0;
            uo_out <= 8'b0;
            step <= 4'b0;
            temp <= 16'b0;
            bit <= 16'b0;
        end else if (ena && mul_done) begin
            case (step)
                0: begin
                    temp <= sum_squares;
                    bit <= 1 << 14; // Highest power of 4
                    sqrt_result <= 0;
                    step <= 1;
                end
                1: begin
                    if (temp >= (sqrt_result | bit)) begin
                        temp <= temp - (sqrt_result | bit);
                        sqrt_result <= (sqrt_result >> 1) | bit;
                    end else begin
                        sqrt_result <= sqrt_result >> 1;
                    end
                    bit <= bit >> 2;
                    if (bit < 4) step <= 2;
                end
                2: begin
                    uo_out <= sqrt_result;
                    step <= 0;
                end
            endcase
        end
    end

    // Assign unused outputs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
