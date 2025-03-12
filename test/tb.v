`timescale 1ns / 1ps
module tb;

    reg [7:0] ui_in;   // x input
    reg [7:0] uio_in;  // y input
    wire [7:0] uio_out; // theta output
    wire [7:0] uo_out;  // r output
    wire [7:0] uio_oe;  // IO enable
    reg ena, clk, rst_n;

    // Instantiate the design under test (DUT)
    tt_um_rect_cyl dut (
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
    always #5 clk = ~clk; // Generate a clock with 10ns period

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;
        #10 rst_n = 1; // Release reset

        // Test case 1: (3,4) => should output r ≈ 5, θ ≈ 36
        ena = 1;
        ui_in = 8'd3;
        uio_in = 8'd4;
        #20;

        // Test case 2: (6,8) => should output r ≈ 10, θ ≈ 36
        ui_in = 8'd6;
        uio_in = 8'd8;
        #20;

        // Test case 3: Edge case (0,5)
        ui_in = 8'd0;
        uio_in = 8'd5;
        #20;

        // Test case 4: Edge case (5,0)
        ui_in = 8'd5;
        uio_in = 8'd0;
        #20;

        // Test case 5: (10,10)
        ui_in = 8'd10;
        uio_in = 8'd10;
        #20;

        $finish;
    end
endmodule
