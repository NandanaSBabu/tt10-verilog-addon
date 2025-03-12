`timescale 1ns/1ps

module tb;

    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uo_out;
    reg clk, rst_n, ena;
    
    tt_um_rect_cyl uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uo_out(uo_out),
        .uio_oe(),  // Ignored in test
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Reset
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;
        #20;
        rst_n = 1;

        // Test 1: (0,0) should give r=0, theta=0
        ena = 1;
        #50;

        // Test 2: (3,4) should give r ≈ 5
        ui_in = 8'd3;
        uio_in = 8'd4;
        #50;

        // Test 3: (5,0) should give theta=0
        ui_in = 8'd5;
        uio_in = 8'd0;
        #50;

        // Test 4: (0,5) should give theta=90
        ui_in = 8'd0;
        uio_in = 8'd5;
        #50;

        // Test 5: (8,6) different case
        ui_in = 8'd8;
        uio_in = 8'd6;
        #50;

        $finish;
    end
endmodule
