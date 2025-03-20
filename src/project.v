default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    
    input  wire [7:0] uio_in,   
    output reg  [7:0] uo_out,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       clk,      
    input  wire       rst_n,    
    input  wire       ena       
);

    reg [15:0] sum_squares;
    reg [15:0] sqrt_result = 0;
    reg [15:0] low = 0, high = 255;
    reg [15:0] mid, mid_squared;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            sqrt_result <= 16'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares without *
            sum_squares <= (ui_in << 3) + (ui_in << 1) + (uio_in << 3) + (uio_in << 1);  

            // Integer square root using binary search
            low <= 0;
            high <= 255;
            sqrt_result <= 0;

            mid = (low + high) >> 1;  
            mid_squared = (mid << 3) + (mid << 1);  

            if (mid_squared <= sum_squares) begin
                sqrt_result <= mid;
                low <= mid + 1;
            end else begin
                high <= mid - 1;
            end

            // Assign final sqrt result
            uo_out <= sqrt_result;
        end
    end

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
