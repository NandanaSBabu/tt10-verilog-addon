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
  reg ena;  // ✅ Added enable signal
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the DUT (Device Under Test)
  tt_um_addon uut (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .clk    (clk),
      .rst_n  (rst_n),
      .ena    (ena)  // ✅ Connected ena
  );

  // Clock generation: 10ns period (100MHz)
  always #10 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ui_in = 0;
    uio_in = 0;
    ena = 0;  // ✅ Ensure ena is initially 0

    // Apply reset
    #20 rst_n = 1;
    
    // Enable calculations
    #10 ena = 1;

    // Apply test cases
    #20 ui_in = 3; uio_in = 4;  
    #50 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out); // ✅ Increased delay

    #20 ui_in = 7; uio_in = 24;
    #50 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out); // ✅ Increased delay

    #20 ui_in = 10; uio_in = 15;
    #50 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out); // ✅ Increased delay

    #20 ui_in = 8; uio_in = 6;
    #50 $display("Time = %t, x = %d, y = %d, sqrt_out = %d", $time, ui_in, uio_in, uo_out); // ✅ Increased delay

    // End simulation
    #100 $finish;
  end

endmodule
