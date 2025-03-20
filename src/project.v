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
    reg [15:0] temp;  // Temporary register for checking squares
    reg [7:0] result;
    integer b, i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
            result <= 8'b0;
            uo_out <= 8'b0;
        end else if (ena) begin
            // Compute sum of squares using repeated addition
            sum_squares = 0;

            for (i = 0; i < ui_in; i = i + 1)
                sum_squares = sum_squares + ui_in;

            for (i = 0; i < uio_in; i = i + 1)
                sum_squares = sum_squares + uio_in;

            // Compute square root without multiplication
            result = 0;
            temp = 0;

            for (b = 7; b >= 0; b = b - 1) begin
                reg [15:0] new_temp;
                new_temp = temp;  // Copy current temp value
                
                // Add (result + (1 << b)) many times
                for (i = 0; i < (result + (1 << b)); i = i + 1)
                    new_temp = new_temp + (result + (1 << b));

                if (new_temp <= sum_squares) begin
                    temp = new_temp;
                    result = result + (1 << b);
                end
            end

            // Assign output in the same cycle
            uo_out <= result;
        end
    end

    // Assign unused outputs to 0 to avoid warnings
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
