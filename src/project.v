module tt_um_project (
    input  wire [7:0] ui_in,    // 8-bit input (x)
    input  wire [7:0] uio_in,   // 8-bit input (y)
    output wire [7:0] uio_out,  // 8-bit output (theta)
    output wire [7:0] uo_out,   // 8-bit output (r)
    input  wire clk,            // Clock signal
    input  wire rst_n,          // Active-low reset
    input  wire ena             // Enable signal
);

    wire [15:0] x2, y2, sum;
    reg  [7:0] r_reg, theta_reg;

    assign x2 = ui_in * ui_in;
    assign y2 = uio_in * uio_in;
    assign sum = x2 + y2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
        end else if (ena) begin
            r_reg <= sum[15:8];  // Approximate sqrt(x² + y²)
            theta_reg <= (uio_in == 0) ? 8'd90 : (ui_in / uio_in); // Approximate atan(y/x)
        end
    end

    assign uo_out = r_reg;      // r output
    assign uio_out = theta_reg; // θ output

endmodule
