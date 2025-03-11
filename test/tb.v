`timescale 1ns / 1ps
module tb;
    reg [7:0] x, y, z;
    wire [7:0] r, theta, z_out;

    tt_um_rect_to_cyl dut (  // Change module name
        .x(x),
        .y(y),
        .z(z),
        .r(r),
        .theta(theta),
        .z_out(z_out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
endmodule
