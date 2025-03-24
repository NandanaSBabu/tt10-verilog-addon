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
  tt_um_addon uut (
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
    ui_in = 0;
    uio_in = 0;
    ena = 0;

    // Apply reset for at least 2 clock cycles
    #40 rst_n = 1;
    
    // Enable calculations after reset
    #20 ena = 1;

    // Apply test cases with increased wait time
    #20 ui_in = 3; uio_in = 4;
    #100 $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

    #20 ui_in = 7; uio_in = 24;
    #100 $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

    #20 ui_in = 10; uio_in = 15;
    #100 $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

    #20 ui_in = 8; uio_in = 6;
    #100 $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, ui_in, uio_in, uo_out);

    // End simulation
    #200 $finish;
  end

endmodule
