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
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the sqrt_pythagoras module
  tt_um_addon user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
    .ui_in      (ui_in),       // Input x
    .uio_in      (uio_in),       // Input y
      .clk    (clk),     // Clock
      .rst_n  (rst_n),   // Reset (active low)
    .uo_out (ou_out) // Output sqrt(x^2 + y^2)
  );

endmodule
