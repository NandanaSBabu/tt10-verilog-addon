`default_nettype none
`timescale 1ns / 1ps

module project_tb ();

  // Dump the signals to a VCD file for waveform debugging
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, project_tb);
    #1;
  end

  // Declare testbench signals
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;   // X input
  reg [7:0] uio_in;  // Y input
  reg [7:0] z_in;    // Z input
  wire [7:0] uo_out;   // R output
  wire [7:0] uio_out;  // Theta output
  wire [7:0] uio_oe;   // Output enable
  wire [7:0] z_out;    // Z output

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the Cartesian-to-Cylindrical module
  project uut (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // X input
      .uo_out (uo_out),   // R output
      .uio_in (uio_in),   // Y input
      .uio_out(uio_out),  // Theta output
      .uio_oe (uio_oe),   // Output enable
      .z_in   (z_in),     // Z input
      .z_out  (z_out),    // Z output
      .ena    (ena),      // Enable signal
      .clk    (clk),      // Clock
      .rst_n  (rst_n)     // Active-low reset
  );

endmodule
