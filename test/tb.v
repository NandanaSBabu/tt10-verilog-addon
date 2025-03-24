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

  // Replace tt_um_example with your module name:
  tt_um_addon user_project (

    // Include power ports for the Gate Level test:
`ifdef GL_TEST
    .VPWR(VPWR),
    .VGND(VGND),
`endif

    .ui_in  (ui_in),    // Dedicated inputs
    .uo_out (uo_out),    // Dedicated outputs
    .uio_in (uio_in),    // IOs: Input path
    .uio_out(uio_out),  // IOs: Output path
    .uio_oe (uio_oe),    // IOs: Enable path (active high: 0=input, 1=output)
    .ena    (ena),      // enable - goes high when design is selected
    .clk    (clk),      // clock
    .rst_n  (rst_n)      // not reset
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

    // Reset
    #10 rst_n = 1;
    #10;

    // Test cases
    test_case(3, 4);  // sqrt(3^2 + 4^2) = 5
    test_case(5, 12); // sqrt(5^2 + 12^2) = 13
    test_case(6, 8);  // sqrt(6^2 + 8^2) = 10
    test_case(7, 24); // sqrt(7^2 + 24^2) = 25
    test_case(0, 0);  // sqrt(0^2 + 0^2) = 0
    test_case(1, 1);  // sqrt(1^2 + 1^2) ≈ 1

    #50;
    $finish;
  end

  // Task to apply inputs and display results
  task test_case(input [7:0] x, input [7:0] y);
    begin
      ui_in = x;
      uio_in = y;
      ena = 1;
      #10;
      $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, x, y, uo_out);
    end
  endtask

endmodule
