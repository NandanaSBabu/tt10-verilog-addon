`timescale 1ns / 1ps
`default_nettype none

module tb;

    reg [7:0] ui_in;   // x input
    reg [7:0] uio_in;  // y input
    wire [7:0] uo_out; // sqrt_out output
    reg clk;           // clock
    reg rst_n;         // active-low reset
    reg ena;           // enable signal

    // Instantiate the module under test (MUT)
    tt_um_addon uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out(),
        .uio_oe(),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Generate clock (10ns period, 50MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        #10 rst_n = 1;  // Release reset
        #10 ena = 1;     // Enable computation

        // Test case 1: sqrt(3^2 + 4^2) = 5
        ui_in = 8'd3;
        uio_in = 8'd4;
        #20;

        // Test case 2: sqrt(6^2 + 8^2) = 10
        ui_in = 8'd6;
        uio_in = 8'd8;
        #20;

        // Test case 3: sqrt(5^2 + 12^2) = 13
        ui_in = 8'd5;
        uio_in = 8'd12;
        #20;

        // End simulation
        #50;
        $finish;
    end

endmodule
