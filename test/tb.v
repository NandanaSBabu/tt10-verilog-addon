`timescale 1ns / 1ps
`default_nettype none

module tb ()
    reg [7:0] ui_in;     // x input
    reg [7:0] uio_in;    // y input
    wire [7:0] uo_out;   // sqrt_out output
    reg clk;
    reg rst_n;

    // Instantiate the DUT (Device Under Test)
    tt_um_addon uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out(),
        .uio_oe(),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation: 10ns period (100MHz)
    always #10 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ui_in = 0;
        uio_in = 0;

        // Apply reset
        #20 rst_n = 1;

        // Apply test cases
        #20 ui_in = 3; uio_in = 4;  // sqrt(3^2 + 4^2) = 5
        #30 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #20 ui_in = 7; uio_in = 24; // sqrt(7^2 + 24^2) = 25
        #30 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #20 ui_in = 10; uio_in = 15; // sqrt(10^2 + 15^2) = 18
        #30 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        #20 ui_in = 8; uio_in = 6;  // sqrt(8^2 + 6^2) = 10
        #30 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out);

        // End simulation
        #50 $finish;
    end
endmodule
