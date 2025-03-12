`timescale 1ns/1ps

module tb;
    reg [7:0] x, y;
    wire [7:0] r, theta;

    // Instantiate your design
    tt_um_rect_cyl uut (
        .ui_in({x, y}),
        .uo_out({r, theta})
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Apply test inputs
        x = 8'd10;
        y = 8'd20;
        #10;  // Wait 10ns

        // Debug output
        $display("Inputs: x=%d, y=%d -> Outputs: r=%d, theta=%d", x, y, r, theta);

        // Wait longer before stopping simulation
        #100;  // Extended delay for stable output
        $finish;
    end
endmodule
