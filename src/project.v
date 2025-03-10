module tt_um_cartesian_to_cylindrical (
    input logic clk,
    input logic rst,
    input logic [15:0] x,  // 16-bit input for x-coordinate
    input logic [15:0] y,  // 16-bit input for y-coordinate
    output logic [15:0] r, // Output radius
    output logic [15:0] theta // Output angle (approx)
);

    logic [31:0] x_sq, y_sq, sum;
    logic [15:0] r_temp;
    logic [15:0] theta_temp;

    // Squaring x and y
    assign x_sq = x * x;
    assign y_sq = y * y;
    assign sum = x_sq + y_sq;

    // Approximate Square Root using Newton-Raphson Iteration
    function automatic [15:0] sqrt_approx(input [31:0] num);
        integer i;
        reg [15:0] x;
        x = num[31:16]; // Initial guess
        for (i = 0; i < 5; i = i + 1) begin
            x = (x + num / x) >> 1;
        end
        return x;
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            r <= 16'd0;
            theta <= 16'd0;
        end else begin
            r_temp = sqrt_approx(sum); // Compute radius
            theta_temp = (y > 0) ? (x << 8) / r_temp : ((x << 8) / r_temp) + 16'd180;
            r <= r_temp;
            theta <= theta_temp;
        end
    end
endmodule
