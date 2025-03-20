`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;   // x input
  reg [7:0] uio_in;  // y input
  wire [7:0] uo_out; // sqrt_out output
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the module under test
  tt_um_addon user_project (
  
      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // x input
      .uio_in (uio_in),   // y input
      .uo_out (uo_out),   // sqrt_out output
      .uio_out(uio_out),  // IOs: Output path (unused)
      .uio_oe (uio_oe),   // IOs: Enable path (unused)
      .ena    (ena),      // enable - always 1
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // active-low reset
  );

endmodule
