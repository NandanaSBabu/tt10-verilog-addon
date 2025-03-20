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
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Clock generation
  always #5 clk = ~clk; // 100MHz clock (10ns period)

  // Instantiate the module under test (MUT)
  tt_um_addon user_project (
      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // active-low reset
  );

  // Reset and test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // Reset and then apply test cases
    #10 rst_n = 1;  // Release reset
    #10 ui_in = 8'd3; uio_in = 8'd4; // Test with 3,4 (expect 5)
    #20 ui_in = 8'd6; uio_in = 8'd8; // Test with 6,8 (expect 10)
    #20 ui_in = 8'd5; uio_in = 8'd12; // Test with 5,12 (expect 13)
    #30 $finish;  // End the simulation after the test cases
  end

endmodule
