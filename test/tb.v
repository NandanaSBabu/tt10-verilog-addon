// tb.v

`default_nettype none
`timescale 1ns / 1ps

module tb ();

    // Dump signals to a VCD file for waveform debugging
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

    // Declare signals
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    reg ena;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the DUT (Device Under Test)
    tt_um_addon user_project (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .clk    (clk),
        .rst_n  (rst_n),
        .ena    (ena)
    );

    // Clock generation: 10ns period (100MHz)
    always #10 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ui_in = 8'd0;
        uio_in = 8'd0;
        ena = 0;

        // Apply reset
        #20 rst_n = 1;

        // Enable calculations
        #30 ena = 1;

        // Apply test cases with delays for stabilization
        #50 ui_in = 8'd3; uio_in = 8'd4; #100;
        $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #50 ui_in = 8'd7; uio_in = 8'd24; #100;
        $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #50 ui_in = 8'd10; uio_in = 8'd15; #100;
        $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #50 ui_in = 8'd8; uio_in = 8'd6; #100;
        $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #100 $finish;
    end

endmodule
