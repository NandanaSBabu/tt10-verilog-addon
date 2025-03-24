`default_nettype none
`timescale 1ns / 1ps

/* Testbench for tt_um_addon module */
module tb ();

  // Dump signals for waveform analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and output
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

  // Instantiate DUT (Device Under Test)
  tt_um_addon user_project (
`ifdef GL_TEST
    .VPWR(VPWR),
    .VGND(VGND),
`endif
    .ui_in  (ui_in),   // X input
    .uo_out (uo_out),  // Square root output
    .uio_in (uio_in),  // Y input
    .uio_out(uio_out), // Unused
    .uio_oe (uio_oe),  // Output Enable
    .ena    (ena),     // Enable
    .clk    (clk),     // Clock
    .rst_n  (rst_n)    // Active-low reset
  );

  // Clock Generation: 10 ns period (100 MHz)
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 0;
    uio_in = 0;

    // Reset for a longer time
    #50 rst_n = 1;
    #10;

    // Test cases
    test_case(3, 4, 5);   // sqrt(3^2 + 4^2) = 5
    test_case(5, 12, 13); // sqrt(5^2 + 12^2) = 13
    test_case(6, 8, 10);  // sqrt(6^2 + 8^2) = 10
    test_case(7, 24, 25); // sqrt(7^2 + 24^2) = 25
    test_case(0, 0, 0);   // sqrt(0^2 + 0^2) = 0
    test_case(1, 1, 1);   // sqrt(1^2 + 1^2) ≈ 1

    #100;
    $finish;
  end

  // Task to apply inputs, wait, and check output
  task test_case(input [7:0] x, input [7:0] y, input [7:0] expected);
    begin
      ui_in = x;
      uio_in = y;
      ena = 1;

      @(posedge clk); // Synchronize with clock
      #100; // Allow module time to compute

      $display("Time = %t | x = %d | y = %d | sqrt_out = %d (Expected: %d)", 
                $time, x, y, uo_out, expected);

      if (uo_out !== expected) begin
        $display("ERROR: sqrt(%d^2 + %d^2) failed! Got %d, expected %d", x, y, uo_out, expected);
      end
    end
  endtask

endmodule
