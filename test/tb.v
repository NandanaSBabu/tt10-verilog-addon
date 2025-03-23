`timescale 1ns / 1ps
`default_nettype none

module tb;

    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    reg clk, rst_n;

    tt_um_addon user_project (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(),
        .uio_oe(),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk; // Clock toggles every 5 ns (100 MHz)

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        ui_in = 0;
        uio_in = 0;
        #10 rst_n = 1;

        // Test 1: x=3, y=4 (Expected result = 5)
        #10 ui_in = 3; uio_in = 4;
        #50;

        // Test 2: x=6, y=8 (Expected result = 10)
        #10 ui_in = 6; uio_in = 8;
        #50;

        // Test 3: x=20, y=99 (Expected result = 101)
        #10 ui_in = 20; uio_in = 99;
        #50;

        // Test 4: x=5, y=12 (Expected result = 13)
        #10 ui_in = 5; uio_in = 12;
        #50;

        $finish;
    end

endmodule
