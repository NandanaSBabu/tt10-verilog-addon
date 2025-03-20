`timescale 1ns/1ps
`default_nettype none

module tb;

    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    reg clk;
    reg rst_n;
    reg ena;

    // Instantiate the module
    tt_um_addon uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns period

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        #10 rst_n = 1; // Release reset
        #10 ena = 1;

        // Test case: x=3, y=4 (expect sqrt(9+16) = 5)
        ui_in = 8'd3;
        uio_in = 8'd4;
        #20;

        // Test case: x=6, y=8 (expect sqrt(36+64) = 10)
        ui_in = 8'd6;
        uio_in = 8'd8;
        #20;

        // Test case: x=0, y=0 (expect sqrt(0) = 0)
        ui_in = 8'd0;
        uio_in = 8'd0;
        #20;

        $finish;
    end

endmodule
