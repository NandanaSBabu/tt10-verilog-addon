`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file for waveform analysis.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Clock generation
  reg clk;
  always #5 clk = ~clk;  // 10ns clock period (100MHz)

  // Declare inputs and outputs
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

  // Instantiate the module under test
  tt_um_rect_cyl user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),    // x input
      .uio_in (uio_in),   // y input
      .uio_out(uio_out),  // theta output
      .uo_out (uo_out),   // r output
      .uio_oe (uio_oe),   // IO enable (all set to 0 for input mode)
      .ena    (ena),      // enable signal
      .clk    (clk),      // clock signal
      .rst_n  (rst_n)     // active-low reset
  );

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 0;
    uio_in = 0;
    #20;
    
    rst_n = 1;  // Release reset
    ena = 1;    // Enable module
    
    // Apply test inputs
    #10 ui_in = 8'd3; uio_in = 8'd4;  // Expect r ≈ 5, theta ≈ atan(4/3)
    #20 ui_in = 8'd6; uio_in = 8'd8;  // Expect r ≈ 10, theta ≈ atan(8/6)
    #20 ui_in = 8'd10; uio_in = 8'd0; // Expect r ≈ 10, theta ≈ 90
    #20 ui_in = 8'd0; uio_in = 8'd10; // Expect r ≈ 10, theta ≈ 0
    #20;
    
    $finish;
  end

endmodule
