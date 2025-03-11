module tt_um_project (
    input  wire [7:0] ui_in,     // 8-bit input x
    inout  wire [7:0] uio_inout, // 8-bit bidirectional y
    output wire [7:0] uo_out,    // 8-bit output (r)
    input  wire clk,             // Clock signal
    input  wire rst_n,           // Active-low reset
    input  wire ena              // Enable signal
);

    wire [7:0] x = ui_in;   // x is taken from input
    wire [7:0] y = uio_inout; // y is bidirectional

    reg [7:0] r_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            r_reg <= 8'd0;
        else if (ena) begin
            // Compute r = sqrt(x^2 + y^2) (approximate)
            r_reg <= (x * x + y * y) >> 8; 
        end
    end

    assign uo_out = r_reg; // Output assignment

endmodule
