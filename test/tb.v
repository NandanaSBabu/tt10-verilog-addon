`timescale 1ns/1ps
`default_nettype none

module tb;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    reg clk, rst_n, ena;

    // Instantiate DUT
    tt_um_addon dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .uio_out(),
        .uio_oe()
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        #10 rst_n = 1;
        #10 ena = 1;

        #10 ui_in = 3; uio_in = 4;  // sqrt(3^2 + 4^2) = 5
        #20 $display("x = %d, y = %d, sqrt_out = %d", ui_in, uio_in, uo_out);

        #10 ui_in = 6; uio_in = 8;  // sqrt(6^2 + 8^2) = 10
        #20 $display("x = %d, y = %d, sqrt_out = %d", ui_in, uio_in, uo_out);

        #10 $finish;
    end

endmodule
