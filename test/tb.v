`timescale 1ns/1ps

module tb_tt_um_addon;

    // Testbench signals
    reg [7:0] ui_in;       // x input
    reg [7:0] uio_in;      // y input
    wire [7:0] uo_out;     // sqrt_out output
    wire [7:0] uio_out;    // IOs: Output path (unused)
    wire [7:0] uio_oe;     // IOs: Enable path (unused)
    reg clk;               // clock
    reg rst_n;             // active-low reset
    reg ena;               // Enable signal

    // Instantiate the Device Under Test (DUT)
    tt_um_addon uut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Clock period 10ns (100MHz)
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        // Apply reset
        #10 rst_n = 1;  // Assert reset for 10ns
        #10 rst_n = 0;  // Deassert reset

        // Enable the DUT and provide test inputs
        #10 ena = 1;
        ui_in = 8'd3;  // x input = 3
        uio_in = 8'd4; // y input = 4

        // Wait for a few clock cycles for the output to stabilize
        #20;

        // Check the output (sqrt(3^2 + 4^2) = sqrt(9 + 16) = sqrt(25) = 5)
        if (uo_out !== 8'd5) begin
            $display("Test failed! Expected 5, got %d", uo_out);
        end else begin
            $display("Test passed! Output is %d", uo_out);
        end

        // End simulation
        $finish;
    end

endmodule
