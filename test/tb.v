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
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  reg ena;  // enable signal

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
      .clk    (clk),      // clock
      .rst_n  (rst_n),    // active-low reset
      .ena    (ena)       // enable signal
  );

  // Reset and test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    ui_in = 0;
    uio_in = 0;
    ena = 0; // Initially disable

    // Reset and then apply test cases
    #10 rst_n = 1;  // Release reset
    #10 ena = 1;    // Enable the calculation

    // Test case 1: Check sqrt(0^2 + 0^2) = 0
    ui_in = 0;
    uio_in = 0;
    await ClockCycles(clk, 1);
    assert uo_out == 0 : "Expected 0, got " + uo_out;

    // Test case 2: Check sqrt(3^2 + 4^2) = 5
    ui_in = 3;
    uio_in = 4;
    await ClockCycles(clk, 1);
    assert uo_out == 5 : "Expected 5, got " + uo_out;

    // Test case 3: Check sqrt(6^2 + 8^2) = 10
    ui_in = 6;
    uio_in = 8;
    await ClockCycles(clk, 1);
    assert uo_out == 10 : "Expected 10, got " + uo_out;

    // Test case 4: Check sqrt(5^2 + 12^2) = 13
    ui_in = 5;
    uio_in = 12;
    await ClockCycles(clk, 1);
    assert uo_out == 13 : "Expected 13, got " + uo_out;

    $finish; // End the simulation after the test cases
  end

endmodule
