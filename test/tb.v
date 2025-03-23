`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file for debugging
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Define test signals
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

  // Instantiate the DUT
  tt_um_addon user_project (
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
      .rst_n  (rst_n)     // not reset
  );

  // Clock generation (50MHz)
  always #10 clk = ~clk;  // 20ns period, 10ns per phase

  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    
    #50 rst_n = 1;  // Release reset after 50ns

    // Wait a few clock cycles
    #50;

    // Test case 1: ui_in = 20, uio_in = 99
    ui_in = 20; 
    uio_in = 99;
    #50;
    $display("Test 1 - Input: %d, %d | Output: %d", ui_in, uio_in, uo_out);

    // Test case 2: ui_in = 50, uio_in = 50
    ui_in = 50; 
    uio_in = 50;
    #50;
    $display("Test 2 - Input: %d, %d | Output: %d", ui_in, uio_in, uo_out);

    // Test case 3: ui_in = 6, uio_in = 8
    ui_in = 6;
    uio_in = 8;
    #50;
    $display("Test 3 - Input: %d, %d | Output: %d", ui_in, uio_in, uo_out);

    // Test case 4: ui_in = 15, uio_in = 112
    ui_in = 15;
    uio_in = 112;
    #50;
    $display("Test 4 - Input: %d, %d | Output: %d", ui_in, uio_in, uo_out);

    // End simulation
    #200 $finish;
  end

endmodule
