`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,     // X input
    input  wire [7:0] uio_in,    // Y input
    output reg  [7:0] uo_out,    // Approximate Square root output
    output wire [7:0] uio_out,   // IOs: Output path
    output wire [7:0] uio_oe,    // IOs: Enable path
    input  wire       ena,       // Enable (ignored)
    input  wire       clk,       // Clock signal
    input  wire       rst_n      // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Internal wires and registers
    wire [15:0] sum_squares_wire;
    reg  [15:0] estimate_comb;
    reg  [15:0] temp;
    reg  [15:0] b;
    integer i;

    assign sum_squares_wire = (ui_in * ui_in) + (uio_in * uio_in);

    // Combinational square root approximation logic
    always @(*) begin
        temp     = sum_squares_wire;
        estimate_comb = 0;
        b        = 16'h4000;

        // Scale down b if it's too big
        for (i = 0; i < 15; i = i + 1) begin
            if (b > temp)
                b = b >> 2;
        end

        // Approximate square root using bit-wise estimation
        for (i = 0; i < 15; i = i + 1) begin
            if (b != 0) begin
                if (temp >= (estimate_comb + b)) begin
                    temp        = temp - (estimate_comb + b);
                    estimate_comb = (estimate_comb >> 1) + b;
                end else begin
                    estimate_comb = estimate_comb >> 1;
                end
                b = b >> 2;
            end
        end
    end

    // Sequential output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            uo_out <= estimate_comb[7:0];
        end
    end

    // Tie off unused signals
    wire _unused = &{ena, 1'b0};

endmodule
