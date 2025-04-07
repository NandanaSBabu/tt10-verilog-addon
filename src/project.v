`default_nettype none

module tt_um_mag_calctr (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    reg [15:0] sum_squares;
    reg [15:0] estimate;
    reg [15:0] b;
    reg [7:0]  sqrt_approx;
    reg [7:0]  out_reg;

    // Temporary values for combinational update
    reg [15:0] ss_temp, est_temp, b_temp;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_squares <= 0;
            estimate    <= 0;
            b           <= 0;
            sqrt_approx <= 0;
            out_reg     <= 0;
        end else begin
            ss_temp  = (ui_in * ui_in) + (uio_in * uio_in);
            est_temp = 0;
            b_temp   = 16'h4000;

            // Adjust b to a valid range
            for (i = 0; i < 15; i = i + 1) begin
                if (b_temp > ss_temp)
                    b_temp = b_temp >> 2;
            end

            // Approximate square root
            for (i = 0; i < 15; i = i + 1) begin
                if (b_temp != 0) begin
                    if (ss_temp >= (est_temp + b_temp)) begin
                        ss_temp  = ss_temp - (est_temp + b_temp);
                        est_temp = (est_temp >> 1) + b_temp;
                    end else begin
                        est_temp = est_temp >> 1;
                    end
                    b_temp = b_temp >> 2;
                end
            end

            sum_squares <= ss_temp;
            estimate    <= est_temp;
            b           <= b_temp;
            sqrt_approx <= est_temp[7:0];
            out_reg     <= est_temp[7:0];
        end
    end

    assign uo_out = out_reg;

    wire _unused = &{ena, 1'b0};

endmodule
