module tt_um_project (
    input  [7:0] ui,    // 8-bit input x
    inout  [7:0] uio,   // 8-bit bidirectional y
    output [7:0] uo     // 8-bit output (r)
);

    wire [7:0] x = ui;  // x comes from input
    wire [7:0] y = uio; // y comes from bidirectional pins

    wire [15:0] x2, y2, sum; // Squaring wires
    assign x2 = x * x;
    assign y2 = y * y;
    assign sum = x2 + y2;

    // Approximate sqrt(x² + y²) using bit shift
    assign uo = sum[15:8]; // r output (approximate)

endmodule
