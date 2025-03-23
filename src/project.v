`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (Active Low)
);

    reg [15:0] square_x, square_y;
    reg [15:0] sum_squares;
    reg [7:0] result;
    reg [15:0] temp_sqrt;
    reg [3:0] sqrt_state;
    
    // Squaring function
    function [15:0] square;
        input [7:0] value;
        begin
            square = value * value;
        end
    endfunction

    // Compute squares separately to avoid incorrect sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            square_x <= 16'b0;
            square_y <= 16'b0;
        end else if (ena) begin
            square_x <= square(ui_in);
            square_y <= square(uio_in);
        end
    end

    // Compute sum of squares
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 16'b0;
        end else if (ena) begin
            sum_squares <= square_x + square_y;
        end
    end

    // Integer square root calculation using a multi-cycle approach
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_sqrt <= 16'b0;
            result <= 8'b0;
            sqrt_state <= 4'd8; // Start from bit 7 (for 8-bit input)
        end else if (ena) begin
            if (sqrt_state > 0) begin
                sqrt_state <= sqrt_state - 1;
                if ((temp_sqrt | (1 << sqrt_state)) * (temp_sqrt | (1 << sqrt_state)) <= sum_squares)
                    temp_sqrt <= temp_sqrt | (1 << sqrt_state);
            end else begin
                result <= temp_sqrt[7:0];
            end
        end
    end

    assign uo_out = result;  // Output the computed sqrt value
    assign uio_out = 8'b0;   // No output on uio_out
    assign uio_oe = 8'b0;    // All uio pins are set as inputs

    // Prevent warnings for unused inputs
    wire _unused = &{ena, 1'b0};

endmodule
