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

    reg [15:0] sum_squares;
    reg [7:0] sqrt_result;
    reg [15:0] r;
    reg [15:0] odd;
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out       <= 8'b0;
            sum_squares  <= 16'b0;
            sqrt_result  <= 8'b0;
            r            <= 16'b0;
            odd          <= 16'b1;
            count        <= 4'b0;
        end else if (ena) begin
            if (count == 0) begin
                // Compute squares and initialize registers
                sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);
                r           <= 16'b0;
                odd         <= 16'b1;
                sqrt_result <= 8'b0;
                count       <= 4'd15;  // Iterate 16 times
            end else begin
                // Iterative sqrt calculation using sum of odd numbers
                if (r + odd <= sum_squares) begin
                    r           <= r + odd;
                    odd         <= odd + 2;
                    sqrt_result <= sqrt_result + 1;
                end
                count <= count - 1;
            end
            // Assign output only after completion
            if (count == 1) uo_out <= sqrt_result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
