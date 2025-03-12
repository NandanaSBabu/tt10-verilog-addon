`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  reg clk;
  always #5 clk = ~clk;  

  reg rst_n, ena;
  reg [7:0] ui_in, uio_in;
  wire [7:0] uo_out, uio_out, uio_oe;

  tt_um_rect_cyl uut (
      .ui_in  (ui_in),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uo_out (uo_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  initial begin
    clk = 0; rst_n = 0; ena = 0; ui_in = 0; uio_in = 0;
    #20 rst_n = 1; ena = 1;
    #10 ui_in = 8'd3; uio_in = 8'd4;
    #20 ui_in = 8'd6; uio_in = 8'd8;
    #20 ui_in = 8'd10; uio_in = 8'd0;
    #20 ui_in = 8'd0; uio_in = 8'd10;
    #20;
    $finish;
  end

endmodule
