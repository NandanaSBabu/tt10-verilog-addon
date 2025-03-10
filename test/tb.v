`timescale 1ns / 1ps

module tb;

    reg clk;
    reg ena;
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] r;
    wire [3:0] theta;

    // Instantiate the DUT (Design Under Test)
    tt_um_cartesian_to_cylindrical uut (
        .clk(clk),
        .ena(ena),
        .x(x),
        .y(y),
        .r(r),
        .theta(theta)
    );

    // Clock generation (10 ns period => 100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        ena = 1;  // Enable the module
        x = 0;
        y = 0;

        // Apply test cases
        #10 x = 4'd1; y = 4'd0;  // Case 1
        #10 x = 4'd1; y = 4'd1;  // Case 2
        #10 x = 4'd2; y = 4'd1;  // Case 3
        #10 x = 4'd4; y = 4'd2;  // Case 4
        #10 x = 4'd8; y = 4'd8;  // Case 5
        #10 $finish;
    end

endmodule
