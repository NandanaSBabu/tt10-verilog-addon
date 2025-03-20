`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump signals to VCD for waveform analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Testbench signals
  reg clk;
  reg rst_n;
  reg [7:0] x;
  reg [7:0] y;
  wire [7:0] sqrt_out;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the sqrt_pythagoras module
  sqrt_pythagoras uut (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .x      (x),       // Input x
      .y      (y),       // Input y
      .clk    (clk),     // Clock
      .rst_n  (rst_n),   // Reset (active low)
      .sqrt_out (sqrt_out) // Output sqrt(x^2 + y^2)
  );

endmodule
