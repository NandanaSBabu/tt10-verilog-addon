`timescale 1ns / 1ps
`default_nettype none

module tb_tt_um_addon;
    reg [7:0] ui_in, uio_in;
    reg clk, rst_n;
    wire [7:0] uo_out;

    // Instantiate the DUT
    tt_um_addon dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .clk(clk),
        .rst_n(rst_n),
        .uo_out(uo_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ui_in = 0;
        uio_in = 0;

        // Reset sequence
        #10 rst_n = 1;

        // Test cases
        #10 ui_in = 20; uio_in = 99;
        #50 $display("Input: ui_in=%d, uio_in=%d | Output uo_out=%d (Expected: 101)", ui_in, uio_in, uo_out);

        #10 ui_in = 6; uio_in = 8;
        #50 $display("Input: ui_in=%d, uio_in=%d | Output uo_out=%d (Expected: 10)", ui_in, uio_in, uo_out);

        #10 ui_in = 15; uio_in = 112;
        #50 $display("Input: ui_in=%d, uio_in=%d | Output uo_out=%d (Expected: 113)", ui_in, uio_in, uo_out);

        #10 ui_in = 8; uio_in = 15;
        #50 $display("Input: ui_in=%d, uio_in=%d | Output uo_out=%d (Expected: 17)", ui_in, uio_in, uo_out);

        #10 ui_in = 20; uio_in = 21;
        #50 $display("Input: ui_in=%d, uio_in=%d | Output uo_out=%d (Expected: 29)", ui_in, uio_in, uo_out);

        // Stop simulation
        #50 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
      $dumpvars(0, tb_tt_um_addon);
    end
endmodule
