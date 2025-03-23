`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,   // x input
    input  wire [7:0] uio_in,  // y input
    output reg  [7:0] uo_out,  // sqrt_out output
    output wire [7:0] uio_out, // Unused
    output wire [7:0] uio_oe,  // Unused
    input  wire       clk,     // Clock
    input  wire       rst_n,   // Reset (active-low)
    input  wire       ena      // Enable
);

    reg signed [15:0] x, y, z;
    reg [3:0] i;  // Iteration counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x <= 0;
            y <= 0;
            z <= 0;
            uo_out <= 0;
            i <= 0;
        end 
        else if (ena) begin
            if (i == 0) begin
                // Load inputs into x and y (scaled)
                x <= {ui_in, 8'b0};  // Left shift to increase precision
                y <= {uio_in, 8'b0};
                z <= 0;
                i <= i + 1;
            end 
            else if (i < 8) begin
                if (y > 0) begin
                    x <= x + (y >>> i);
                    y <= y - (x >>> i);
                end else begin
                    x <= x - (y >>> i);
                    y <= y + (x >>> i);
                end
                i <= i + 1;
            end 
            else begin
                // After 8 iterations, store the result
                uo_out <= x[15:8]; // Extract magnitude from scaled result
                i <= 0;
            end
        end
    end

    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

endmodule
