`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square root output
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock signal
    input  wire        rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [7:0] sqrt_lut [0:65535]; // LUT storage

    // Read LUT from external memory file
    initial begin
        $readmemh("sqrt_lut.mem", sqrt_lut);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            uo_out <= sqrt_lut[{ui_in, uio_in}];  // Fixed LUT index usage
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
