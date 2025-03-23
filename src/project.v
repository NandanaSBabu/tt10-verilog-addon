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
    reg [7:0] result;
    reg [7:0] approx_sqrt;
    reg [15:0] temp;
    reg [3:0] shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            approx_sqrt <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Calculate sum of squares
            sum_squares <= (ui_in * ui_in) + (uio_in * uio_in);

            // Approximate square root using bitwise method
            approx_sqrt = 0;
            temp = 0;
            shift = 15; // Highest bit position
            
            while (shift >= 0) begin
                temp = (approx_sqrt | (1 << shift));
                if (temp * temp <= sum_squares) begin
                    approx_sqrt = temp;
                end
                shift = shift - 1;
            end

            // Assign final square root output
            result <= approx_sqrt;
            uo_out <= result;
        end
    end

    // Assign unused outputs to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
