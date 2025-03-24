`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square root output
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] sum_squares;
    reg [7:0] estimate;
    reg [7:0] step;
    reg [15:0] temp_sum;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out      <= 8'd0;
            sum_squares <= 16'd0;
            estimate    <= 8'd0;
            step        <= 8'd0;
        end else begin
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
            estimate    <= 8'd0;
            step        <= 8'd64;  // Start with highest bit for binary search
            temp_sum    <= sum_squares;

            // Binary search for square root approximation
            for (i = 0; i < 7; i = i + 1) begin
                if ((estimate + step) * (estimate + step) <= sum_squares)
                    estimate <= estimate + step;
                step <= step >> 1;
            end
            
            uo_out <= estimate;  // Non-blocking assignment for final output
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
