`timescale 1ns / 1ps

module tb;

    // DUT signals
    reg [7:0] ui_in;      // X input
    reg [7:0] uio_in;     // Y input
    wire [7:0] uo_out;    // Output (sqrt result)
    reg ena;              // Enable signal
    reg clk;              // Clock
    reg rst_n;            // Active-low reset

    // Instantiate DUT (Device Under Test)
    tt_um_addon dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out(),   // Not used
        .uio_oe(),    // Not used
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock Generation: 10 ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        // Reset
        #10 rst_n = 1;
        #10;

        // Test cases
        test_case(3, 4);  // sqrt(3^2 + 4^2) = 5
        test_case(5, 12); // sqrt(5^2 + 12^2) = 13
        test_case(6, 8);  // sqrt(6^2 + 8^2) = 10
        test_case(7, 24); // sqrt(7^2 + 24^2) = 25
        test_case(0, 0);  // sqrt(0^2 + 0^2) = 0
        test_case(1, 1);  // sqrt(1^2 + 1^2) ≈ 1

        #50;
        $finish;
    end

    // Task to apply inputs and display results
    task test_case(input [7:0] x, input [7:0] y);
        begin
            ui_in = x;
            uio_in = y;
            ena = 1;
            #10;
            $display("Time = %t | x = %d | y = %d | sqrt_out = %d", $time, x, y, uo_out);
        end
    endtask

endmodule
