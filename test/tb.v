`default_nettype none
`timescale 1ns / 1ps

/* Testbench to instantiate the user project for cocotb testing */

module tb ();

  // Clock and reset signals
  reg clk;
  reg rst_n;
  reg ena;

  // Input and output signals
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // VCD Dump for waveform generation (gtkwave or similar)
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Clock generation: 100MHz (10ns period)
  always #5 clk = ~clk;

  // Instantiate the device under test (DUT)
  tt_um_addon user_project (
      .ui_in   (ui_in),    // Dedicated inputs
      .uo_out  (uo_out),   // Dedicated outputs
      .uio_in  (uio_in),   // IOs: Input path
      .uio_out (uio_out),  // IOs: Output path
      .uio_oe  (uio_oe),   // IOs: Enable path
      .ena     (ena),      // Enable signal
      .clk     (clk),      // Clock signal
      .rst_n   (rst_n)     // Active-low reset
  );

endmodule
