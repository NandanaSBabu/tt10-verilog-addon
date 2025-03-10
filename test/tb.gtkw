`timescale 1ns / 1ps

module tb;
    reg signed [7:0] x, y;
    wire signed [7:0] r, theta;

    // Instantiate the project module
    project uut (
        .x(x),
        .y(y),
        .r(r),
        .theta(theta)
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Test cases
        x = 8'd3; y = 8'd4; #10;
        x = -8'd6; y = -8'd8; #10;
        x = 8'd0; y = 8'd5; #10;
        x = 8'd7; y = 8'd0; #10;
        x = -8'd5; y = 8'd5; #10;

        $finish;
    end
endmodule
