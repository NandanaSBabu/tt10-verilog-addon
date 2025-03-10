module tt_um_cartesian_to_cylindrical (
    input clk,
    input rst_n,  // Active-low reset
    input ena,
    input [3:0] x,
    input [3:0] y,
    output reg [3:0] r,
    output reg [3:0] theta
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset values when rst_n is LOW
            r <= 0;
            theta <= 0;
        end else if (ena) begin
            // Your computation logic here
            r <= x + y;  // Example logic, replace with actual calculation
            theta <= x - y;  // Example logic
        end
    end

endmodule
