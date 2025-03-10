`timescale 1ns / 1ps

module tb;

    reg clk;
    reg reset;
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] r;
    wire [3:0] theta;

    // Instantiate the module
    tt_um_cartesian_to_cylindrical uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .r(r),
        .theta(theta)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        
        clk = 0;
        reset = 1;
        #10;
        
        reset = 0;
        
        // Test cases
        x = 4'd1; y = 4'd0; #10;
        x = 4'd1; y = 4'd1; #10;
        x = 4'd2; y = 4'd1; #10;
        x = 4'd3; y = 4'd2; #10;
        x = 4'd4; y = 4'd3; #10;
        x = 4'd0; y = 4'd4; #10;

        $finish;
    end

endmodule
