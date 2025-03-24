module tt_um_addon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Instance of sqrt_lookup module
  sqrt_lookup sqrt_inst (
      .x(ui_in),
      .y(uio_in),
      .clk(clk),
      .rst(~rst_n),
      .sqrt_out(uo_out),
      .valid(uio_out[0])
  );

  assign uio_oe  = 8'b00000001; // Enable output on uio_out[0]
  wire _unused = &{ena, 1'b0};

endmodule

module sqrt_lookup (
    input [7:0] x,
    input [7:0] y,
    input clk,
    input rst,
    output reg [7:0] sqrt_out,
    output reg valid
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sqrt_out <= 8'd0;
            valid <= 1'b0;
        end else begin
            case ({x, y})
                {8'd3, 8'd4}: sqrt_out <= 8'd5;
                {8'd5, 8'd12}: sqrt_out <= 8'd13;
                {8'd7, 8'd24}: sqrt_out <= 8'd25;
                {8'd8, 8'd15}: sqrt_out <= 8'd17;
                {8'd9, 8'd40}: sqrt_out <= 8'd41;
                {8'd11, 8'd60}: sqrt_out <= 8'd61;
                {8'd16, 8'd63}: sqrt_out <= 8'd65;
                {8'd13, 8'd84}: sqrt_out <= 8'd85;
                {8'd60, 8'd80}: sqrt_out <= 8'd100;
                {8'd42, 8'd124}: sqrt_out <= 8'd130;
                default: sqrt_out <= 8'd0;
            endcase
            valid <= 1'b1;
        end
    end

endmodule
