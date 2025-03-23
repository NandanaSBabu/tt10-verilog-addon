`default_nettype none
`timescale 1ns / 1ps

/* Testbench for Pythagorean Theorem Calculator (Tiny Tapeout) */
module tb ();

  // Generate VCD file for waveform analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Define input and output registers/wires
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;   // Input: side a
  reg [7:0] uio_in;  // Input: side b
  wire [7:0] uo_out; // Output: hypotenuse
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Power connections for Gate-Level Simulation
  `ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
  `endif

  // Generate Clock (100ns period -> 10MHz frequency)
  always #50 clk = ~clk;

  // Instantiate Design Under Test (DUT)
  tt_um_addon user_project (
      `ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
      `endif
      .ui_in  (ui_in),    // Side a
      .uio_in (uio_in),   // Side b
      .uo_out (uo_out),   // Hypotenuse output
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Initialize signals and test cases
  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // Apply Reset (Hold low for 5 clock cycles)
    repeat (5) @(posedge clk);
    rst_n = 1;  // Release reset

    // Apply Test Cases
    repeat (5) @(posedge clk);
    ui_in = 8'd3; uio_in = 8'd4;  // sqrt(3² + 4²) = 5
    repeat (10) @(posedge clk);
    $display("Time=%0t | a=%d, b=%d, sqrt(a² + b²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (5) @(posedge clk);
    ui_in = 8'd6; uio_in = 8'd8;  // sqrt(6² + 8²) = 10
    repeat (10) @(posedge clk);
    $display("Time=%0t | a=%d, b=%d, sqrt(a² + b²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (5) @(posedge clk);
    ui_in = 8'd5; uio_in = 8'd12; // sqrt(5² + 12²) = 13
    repeat (10) @(posedge clk);
    $display("Time=%0t | a=%d, b=%d, sqrt(a² + b²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (5) @(posedge clk);
    ui_in = 8'd8; uio_in = 8'd15; // sqrt(8² + 15²) = 17
    repeat (10) @(posedge clk);
    $display("Time=%0t | a=%d, b=%d, sqrt(a² + b²)=%d", $time, ui_in, uio_in, uo_out);

    repeat (5) @(posedge clk);
    ui_in = 8'd12; uio_in = 8'd16; // sqrt(12² + 16²) = 20
    repeat (10) @(posedge clk);
    $display("Time=%0t | a=%d, b=%d, sqrt(a² + b²)=%d", $time, ui_in, uio_in, uo_out);

    // End simulation
    #50;
    $finish;
  end

endmodule
