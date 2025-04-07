`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,     // X input
    output wire [7:0] uo_out,    // Output: sqrt(x² + y²)
    input  wire [7:0] uio_in,    // Y input
    output wire [7:0] uio_out,   // Not used
    output wire [7:0] uio_oe,    // Not used
    input  wire       ena,       // Always 1 when powered
    input  wire       clk,       // Clock
    input  wire       rst_n      // Active low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    reg [15:0] value;     // x² + y²
    reg [7:0]  result;    // sqrt(x² + y²)
    reg [7:0]  b;
    reg [7:0]  temp;
    reg [7:0]  out_reg;
    reg [3:0]  step;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            value   <= 0;
            result  <= 0;
            b     <= 0;
            temp    <= 0;
            out_reg <= 0;
            step    <= 0;
            busy    <= 0;
        end else if (ena && !busy) begin
            value   <= ui_in * ui_in + uio_in * uio_in;
            result  <= 0;
            b    <= 8'h40;  // Start from MSB (64)
            step    <= 0;
            busy    <= 1;
        end else if (busy) begin
            if (step < 8) begin
                temp = result | b;
                if (temp * temp <= value)
                    result <= temp;
                step <= step + 1;
                b  <= b >> 1;
            end else begin
                out_reg <= result;
                busy <= 0;
            end
        end
    end

    assign uo_out = out_reg;
    wire _unused = &{ena, 1'b0};

endmodule
