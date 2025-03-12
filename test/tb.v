`timescale 1ns / 1ps
`default_nettype none

module tb;

    reg  [7:0] ui_in;     // x input
    reg  [7:0] uio_in;    // y input
    reg  [7:0] uio_extra; // z input
    reg        ena;       // Enable
    reg        clk;       // Clock
    reg        rst_n;     // Reset (Active Low)

    wire [7:0] uio_out;       // Theta output
    wire [7:0] uo_out;        // r output
    wire [7:0] uo_extra_out;  // Phi output
    wire [7:0] uio_oe;        // IO enable

    // Instantiate the module
    tt_um_rect_cyl uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uo_out(uo_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period (50 MHz)

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;
        uio_extra = 0;
        
        // Reset sequence
        #10 rst_n = 1;
        #10 ena = 1;

        // Test cases
        #10 ui_in = 8'd10; uio_in = 8'd10; uio_extra = 8'd5; // Example: x=10, y=10, z=5
        #10 ui_in = 8'd20; uio_in = 8'd15; uio_extra = 8'd7; // Example: x=20, y=15, z=7
        #10 ui_in = 8'd30; uio_in = 8'd25; uio_extra = 8'd10; // Example: x=30, y=25, z=10
        #10 ui_in = 8'd0; uio_in = 8'd0; uio_extra = 8'd0;  // Edge case: all inputs zero

        // Finish simulation
        #50 $finish;
    end

    // Monitor output values
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        $monitor("Time=%0t | x=%d y=%d z=%d | r=%d theta=%d phi=%d",
                  $time, ui_in, uio_in, uio_extra, uo_out, uio_out, uo_extra_out);
    end

endmodule
