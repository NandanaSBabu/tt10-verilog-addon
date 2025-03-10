module tt_um_cartesian_to_cylindrical (
    input  wire        clk,       // Clock
    input  wire        rst_n,     // Active-low reset
    input  wire [7:0]  ui_in,     // 8-bit input (x, y, ena)
    output wire [7:0]  uo_out     // 8-bit output (r, theta)
);

    wire ena;
    wire [3:0] x, y;
    reg [3:0] r, theta;

    // Assign inputs
    assign ena = ui_in[7];  // MSB as enable
    assign x = ui_in[3:0];  // Lower 4 bits as X
    assign y = ui_in[6:4];  // Middle 3 bits as Y (adjust width as needed)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r <= 0;
            theta <= 0;
        end else if (ena) begin
            r <= (x > y) ? (x - y) : (y - x);  // Approximate magnitude
            theta <= (x + y) >> 1;             // Approximate angle
        end
    end

    // Assign outputs
    assign uo_out = {theta, r};  // Combine r and theta as 8-bit output

endmodule
