`timescale 1ns / 1ps

module tb;

    reg [7:0] ui_in;    // x input
    reg [7:0] uio_in;   // y input
    wire [7:0] uio_out; // theta output
    wire [7:0] uo_out;  // r output
    reg ena, clk, rst_n;
    wire [7:0] uio_oe;

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
    always #5 clk = ~clk; // 10ns period, 100MHz clock

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 8'd0;
        uio_in = 8'd0;
        
        // Reset
        #10 rst_n = 1;

        // Test case 1: (3,4) -> Expect r ≈ 5, theta ≈ 53°
        #10 ena = 1; ui_in = 8'd3; uio_in = 8'd4;
        #20 ena = 0;

        // Test case 2: (6,8) -> Expect r ≈ 10, theta ≈ 53°
        #10 ena = 1; ui_in = 8'd6; uio_in = 8'd8;
        #20 ena = 0;

        // Test case 3: (0, 7) -> Expect r ≈ 7, theta ≈ 90°
        #10 ena = 1; ui_in = 8'd0; uio_in = 8'd7;
        #20 ena = 0;

        // Stop Simulation
        #50 $finish;
    end

    // Dump waveforms
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);
    end

endmodule
