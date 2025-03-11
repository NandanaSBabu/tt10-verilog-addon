`timescale 1ns / 1ps

module tb;
    reg [7:0] x, y, z;
    wire [7:0] r, theta, z_out;
    
    // Instantiate the design under test (DUT)
    tt_um_project dut (
        .x(x),
        .y(y),
        .z(z),
        .r(r),
        .theta(theta),
        .z_out(z_out)
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Test cases
        x = 8'd10; y = 8'd0; z = 8'd5; #10; // Expect r=10, theta=0, z=5
        x = 8'd0; y = 8'd10; z = 8'd5; #10; // Expect r=10, theta=90, z=5
        x = 8'd7; y = 8'd7; z = 8'd8; #10; // Expect r≈9, theta≈45, z=8
        x = 8'd5; y = 8'd12; z = 8'd3; #10; // Expect r≈13, theta≈67, z=3
        x = 8'd15; y = 8'd15; z = 8'd1; #10; // Expect r≈21, theta≈45, z=1
        x = 8'd0; y = 8'd0; z = 8'd9; #10; // Expect r=0, theta=0, z=9

        // Additional edge cases
        x = 8'd255; y = 8'd255; z = 8'd255; #10; // Max values
        x = 8'd1; y = 8'd1; z = 8'd1; #10; // Smallest non-zero values
        
        $finish;
    end
endmodule
