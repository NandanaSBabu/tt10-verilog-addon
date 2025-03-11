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

    // LUT for atan(y/x) approximation (simplified)
    reg [7:0] atan_lut [0:15];
    initial begin
        atan_lut[0]  = 8'd0;  
        atan_lut[1]  = 8'd14;  
        atan_lut[2]  = 8'd28;  
        atan_lut[3]  = 8'd38;
        atan_lut[4]  = 8'd45;  
        atan_lut[5]  = 8'd52;
        atan_lut[6]  = 8'd58;
        atan_lut[7]  = 8'd63;
        atan_lut[8]  = 8'd67;
        atan_lut[9]  = 8'd71;
        atan_lut[10] = 8'd75;
        atan_lut[11] = 8'd78;
        atan_lut[12] = 8'd81;
        atan_lut[13] = 8'd84;
        atan_lut[14] = 8'd87;
        atan_lut[15] = 8'd90; 
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_reg <= 8'd0;
            theta_reg <= 8'd0;
        end else if (ena) begin
            r_reg <= sum[15:8];  // Approximate sqrt(x² + y²)
            theta_reg <= (ui_in == 0) ? 8'd90 : atan_lut[(uio_in >> 4) / (ui_in >> 4)]; 
        end
    end

    assign uo_out = r_reg;      // r output
    assign uio_out = theta_reg; // θ output

endmodule
