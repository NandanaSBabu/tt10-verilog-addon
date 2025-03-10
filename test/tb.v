`timescale 1ns / 1ps
module tb;

  reg [7:0] x, y, z;
  wire [7:0] r, theta, z_out;
  reg clk, rst;

  // Instantiate DUT (Design Under Test)
  tt_um_cartesian_to_cylindrical dut (
      .x0(x[0]), .x1(x[1]), .x2(x[2]), .x3(x[3]), .x4(x[4]), .x5(x[5]), .x6(x[6]), .x7(x[7]),
      .y0(y[0]), .y1(y[1]), .y2(y[2]), .y3(y[3]), .y4(y[4]), .y5(y[5]), .y6(y[6]), .y7(y[7]),
      .z0(z[0]), .z1(z[1]), .z2(z[2]), .z3(z[3]), .z4(z[4]), .z5(z[5]), .z6(z[6]), .z7(z[7]),
      .r0(r[0]), .r1(r[1]), .r2(r[2]), .r3(r[3]), .r4(r[4]), .r5(r[5]), .r6(r[6]), .r7(r[7]),
      .theta0(theta[0]), .theta1(theta[1]), .theta2(theta[2]), .theta3(theta[3]), .theta4(theta[4]),
      .theta5(theta[5]), .theta6(theta[6]), .theta7(theta[7]),
      .z_out0(z_out[0]), .z_out1(z_out[1]), .z_out2(z_out[2]), .z_out3(z_out[3]),
      .z_out4(z_out[4]), .z_out5(z_out[5]), .z_out6(z_out[6]), .z_out7(z_out[7])
  );

  initial begin
    clk = 0;
    rst = 1;
    x = 8'd10;
    y = 8'd20;
    z = 8'd30;
    
    #10 rst = 0;
    #10 x = 8'd15; y = 8'd25; z = 8'd35;
    #10 x = 8'd30; y = 8'd40; z = 8'd50;
    
    #50 $finish;
  end

  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

endmodule
