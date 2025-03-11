`timescale 1ns / 1ps

module tb;

    reg [7:0] ui_in, uio_in;
    wire [7:0] uio_out, uo_out;
    reg clk, rst_n, ena;

    // Instantiate DUT (Device Under Test)
    tt_um_project dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uio_out(uio_out),
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

        // Reset the system
        #10 rst_n = 1;
        #10 ena = 1;

        // Apply test cases
        ui_in = 8'd10;
        uio_in = 8'd20;
        #20;

        ui_in = 8'd30;
        uio_in = 8'd40;
        #20;

        ui_in = 8'd0;
        uio_in = 8'd1;
        #20;

        ui_in = 8'd100;
        uio_in = 8'd100;
        #20;

        // Finish simulation
        $finish;
    end

endmodule
