`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,     // X input
    input  wire [7:0] uio_in,    // Y input
    output reg  [7:0] uo_out,    // Approximate magnitude output
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Declare variables here (outside the always block)
    reg [7:0] x, y;
    reg [7:0] max_val, min_val;
    reg [7:0] approx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end 
        else begin
            x = ui_in;
            y = uio_in;

            if (x > y) begin
                max_val = x;
                min_val = y;
            end else begin
                max_val = y;
                min_val = x;
            end

            approx = max_val + (min_val >> 1) - 1;
            uo_out <= approx;
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
