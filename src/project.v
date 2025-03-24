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
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
            estimate    <= 16'd0;
            b           <= 16'h4000; // Start from highest power of 4 within 16-bit range
            temp_sum    <= sum_squares;

            // Fixed iteration loop instead of while to avoid GDS issues
            for (i = 0; i < 8; i = i + 1) begin
                if (b > temp_sum)
                    b <= b >> 2; // Non-blocking assignment to avoid GDS issue
            end

            // Approximate square root calculation
            for (i = 0; i < 15; i = i + 1) begin
                if (b != 0) begin
                    if (temp_sum >= (estimate + b)) begin
                        temp_sum  <= temp_sum - (estimate + b); 
                        estimate  <= estimate + (b << 1);
                    end 
                    estimate <= estimate >> 1; // Correct shift
                    b <= b >> 2;
                end
            end
            
            uo_out <= estimate[7:0]; // Non-blocking assignment for final output
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
