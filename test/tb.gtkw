`timescale 1ns / 1ps

module project_tb;
    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;   // X input
    reg [7:0] uio_in;  // Y input
    reg [7:0] z_in;    // Z input
    wire [7:0] uo_out;   // R output
    wire [7:0] uio_out;  // Theta output
    wire [7:0] uio_oe;   // Output enable
    wire [7:0] z_out;    // Z output
    
    // Instantiate the project module
    project uut (
        .ui_in  (ui_in),    // X input
        .uo_out (uo_out),   // R output
        .uio_in (uio_in),   // Y input
        .uio_out(uio_out),  // Theta output
        .uio_oe (uio_oe),   // Output enable
        .z_in   (z_in),     // Z input
        .z_out  (z_out),    // Z output
        .ena    (ena),      // Enable signal
        .clk    (clk),      // Clock
        .rst_n  (rst_n)     // Active-low reset
    );
    
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 8'd10; uio_in = 8'd10; z_in = 8'd5;
        #10;
        
        rst_n = 1;
        ena = 1;
        ui_in = -8'd15; uio_in = 8'd20; z_in = 8'd8;
        #10;
        
        ui_in = 8'd30; uio_in = -8'd25; z_in = 8'd12;
        #10;
        
        ui_in = 8'd0; uio_in = 8'd0; z_in = 8'd10;
        #10;
        
        $finish;
    end
    
    always #5 clk = ~clk; // Clock generation
    
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, project_tb);
    end
    
endmodule
