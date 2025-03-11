module tt_um_project (
    input [7:0] ui,     // 8-bit input x
    inout [7:0] uio,    // 8-bit bidirectional y
    output [7:0] uo     // 8-bit output r
);

    wire [7:0] x = ui;    // Assign input x
    wire [7:0] y = uio;   // Use bidirectional pins for y
    wire [7:0] z = uio;   // Reuse bidirectional pins for z

    wire [15:0] x2, y2, sum; // Squaring wires

    assign x2 = x * x;
    assign y2 = y * y;
    assign sum = x2 + y2;

    // Approximate sqrt(x² + y²)
    assign uo = sum[15:8]; // Rough sqrt approximation assigned to r

    // Approximate atan(y/x) using a lookup table
    reg [7:0] atan_lut [0:15];
    initial begin
        atan_lut[0] = 8'd0;  
        atan_lut[1] = 8'd14;  
        atan_lut[2] = 8'd28;  
        atan_lut[3] = 8'd38;
        atan_lut[4] = 8'd45;  
        atan_lut[5] = 8'd52;
        atan_lut[6] = 8'd58;
        atan_lut[7] = 8'd63;
        atan_lut[8] = 8'd67;
        atan_lut[9] = 8'd71;
        atan_lut[10] = 8'd75;
        atan_lut[11] = 8'd78;
        atan_lut[12] = 8'd81;
        atan_lut[13] = 8'd84;
        atan_lut[14] = 8'd87;
        atan_lut[15] = 8'd90; 
    end

    always @(*) begin
        if (x == 0)
            uio = 8'd90;  // If x = 0, theta = 90°
        else
            uio = atan_lut[(y >> 4) / (x >> 4)];  // Approximate using 4-bit shifts
    end

endmodule
