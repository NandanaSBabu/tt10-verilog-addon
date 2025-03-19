`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file for waveform analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Define testbench signals
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

  // Instantiate the module under test
  tt_um_rect_to_cyl user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),    // Input: Encoded x, y, z values
      .uo_out (uo_out),   // Output: Encoded r, theta, z_out
      .uio_in (uio_in),   // IO inputs
      .uio_out (uio_out), // IO outputs
      .uio_oe  (uio_oe),  // IO enable signals
      .ena    (ena),      // Enable signal
      .clk    (clk),      // Clock signal
      .rst_n  (rst_n)     // Active-low reset
  );

  // Generate a clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 8'b0;
    uio_in = 8'b0;
    
    // Reset the system
    #10 rst_n = 1;
    
    // Test Case 1: x = 3, y = 4, z = 50
    #10 ui_in = 8'd3; uio_in = 8'd4; ena = 1;
    #10 ena = 0;
    #50;
    $display("Test 1: r=%d, theta=%d, z_out=%d", uo_out[7:4], uo_out[3:0], uio_out);
    
    // Test Case 2: x = 50, y = 100, z = 20
    #10 ui_in = 8'd50; uio_in = 8'd100; ena = 1;
    #10 ena = 0;
    #50;
    $display("Test 2: r=%d, theta=%d, z_out=%d", uo_out[7:4], uo_out[3:0], uio_out);
    
    // Test Case 3: x = -12, y = 35, z = 30
    #10 ui_in = -8'd12; uio_in = 8'd35; ena = 1;
    #10 ena = 0;
    #50;
    $display("Test 3: r=%d, theta=%d, z_out=%d", uo_out[7:4], uo_out[3:0], uio_out);
    
    // Finish simulation
    #50;
    $finish;
  end

endmodule
