`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    
    input  wire [7:0] uio_in,   
    output reg  [7:0] uo_out,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire        ena,      
    input  wire        clk,      
    input  wire        rst_n     
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [15:0] estimate;
    reg [15:0] b;
    reg [15:0] temp_sum;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            estimate    <= 16'd0;
            b           <= 16'd0;
        end else begin
            sum_squares = (ui_in * ui_in) + (uio_in * uio_in);
            estimate = 0;
            b = 1 << 14; // Start from the highest power of 4

            // Use a `for` loop instead of `while`
            for (i = 0; i < 8; i = i + 1) begin
                if (b > sum_squares)
                    b = b >> 2;
            end

            // Square root approximation using shift operations
            for (i = 0; i < 8; i = i + 1) begin
                if (b != 0) begin
                    if (sum_squares >= (estimate + b)) begin
                        sum_squares = sum_squares - (estimate + b);
                        estimate = estimate + (b << 1);
                    end 
                    estimate = estimate >> 1;
                    b = b >> 2;
                end
            end
            
            uo_out <= estimate[7:0]; // Final output
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
