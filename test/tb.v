`timescale 1ns/1ps
module tb;

    reg [7:0] ui_in, uio_in;
    wire [7:0] uio_out, uo_out;
    reg ena, clk, rst_n;
    
    tt_um_rect_cyl dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uo_out(uo_out),
        .uio_oe(), 
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        ena = 1;
        rst_n = 0;
        #50 rst_n = 1;

        #20 ui_in = 10; uio_in = 20;
        #20 ui_in = 30; uio_in = 40;
        #20 ui_in = 50; uio_in = 60;
        #20 ui_in = 70; uio_in = 80;

        #100;
        $finish;
    end
endmodule
