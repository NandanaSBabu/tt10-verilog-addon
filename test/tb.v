`timescale 1ns / 1ps

module tb;

    reg [7:0] ui_in, uio_in;
    wire [7:0] uio_out, uo_out;
    wire [7:0] uio_oe; // Output Enable
    reg clk, rst_n, ena;

    // Instantiate DUT (Device Under Test)
    tt_um_project dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uo_out(uo_out),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100MHz)

    initial begin
        // Dump waveform file
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 8'd0;
        uio_in = 8'd0;

        // Reset sequence
        #20 rst_n = 1;  // Release reset

        // Enable processing
        #10 ena = 1;

        // Apply test cases
        #10 ui_in = 8'd10; uio_in = 8'd20; #20;
        #10 ui_in = 8'd30; uio_in = 8'd40; #20;
        #10 ui_in = 8'd0;  uio_in = 8'd0;  #20;  // Zero division case
        #10 ui_in = 8'd100; uio_in = 8'd100; #20;

        // Finish simulation
        #10 $finish;
    end

endmodule
