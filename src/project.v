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

    reg [15:0] ss_temp;
    reg [15:0] est_temp;
    reg [15:0] b_temp;
    reg [3:0]  step; // max 15 iterations

    reg [7:0]  out_reg;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ss_temp   <= 0;
            est_temp  <= 0;
            b_temp    <= 16'h4000;
            step      <= 0;
            out_reg   <= 0;
            busy      <= 0;
        end else if (ena && !busy) begin
            // Start square root approximation
            ss_temp   <= (ui_in * ui_in) + (uio_in * uio_in);
            est_temp  <= 0;
            b_temp    <= 16'h4000;
            step      <= 0;
            busy      <= 1;
        end else if (busy) begin
            if (step < 15) begin
                if (ss_temp >= (est_temp + b_temp)) begin
                    ss_temp  <= ss_temp - (est_temp + b_temp);
                    est_temp <= (est_temp >> 1) + b_temp;
                end else begin
                    est_temp <= est_temp >> 1;
                end
                b_temp <= b_temp >> 2;
                step   <= step + 1;
            end else begin
                out_reg <= est_temp[7:0]; // Output 8-bit approx sqrt
                busy    <= 0;
            end
        end
    end

    assign uo_out = out_reg;

    wire _unused = &{ena, 1'b0};

endmodule
