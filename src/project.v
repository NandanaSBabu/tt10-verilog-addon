module tt_um_project (
    input  wire [7:0] ui,    // 8-bit input x
    inout  wire [7:0] uio,   // 8-bit bidirectional y
    output wire [7:0] uo,    // 8-bit output (r)
    input  wire clk,         // Clock signal
    input  wire rst_n,       // Active-low reset
    input  wire ena          // Enable signal
);

    wire [7:0] x = ui;  // x comes from input
    wire [7:0] y = uio; // y comes from bidirectional pins

    reg [7:0] r_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            r_reg <= 8'd0;
        else if (ena) begin
            // Compute r = sqrt(x^2 + y^2) (approximate)
            r_reg <= (x * x + y * y) >> 8; 
        end
    end

    assign uo = r_reg; // Output register

endmodule
