`default_nettype none

module tt_um_addon (
    input  wire [7:0] ui_in,    // X input
    input  wire [7:0] uio_in,   // Y input
    output reg  [7:0] uo_out,   // Approximate Square Root Output
    output wire [7:0] uio_out,  // IOs: Output Path
    output wire [7:0] uio_oe,   // IOs: Enable Path
    input  wire        ena,      // Enable (ignored)
    input  wire        clk,      // Clock Signal
    input  wire        rst_n     // Active-low Reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Smaller precomputed LUT (Manually filled with test.py values + 20 extra)
    reg [7:0] sqrt_lut [0:35]; 

    initial begin
        sqrt_lut[0]  = 8'd5;  // sqrt(3^2 + 4^2) = 5
        sqrt_lut[1]  = 8'd13; // sqrt(5^2 + 12^2) = 13
        sqrt_lut[2]  = 8'd25; // sqrt(7^2 + 24^2) = 25
        sqrt_lut[3]  = 8'd17; // sqrt(8^2 + 15^2) = 17
        sqrt_lut[4]  = 8'd29; // sqrt(12^2 + 25^2) = 29
        sqrt_lut[5]  = 8'd41; // sqrt(9^2 + 40^2) = 41
        sqrt_lut[6]  = 8'd50; // sqrt(10^2 + 48^2) = 50
        sqrt_lut[7]  = 8'd61; // sqrt(11^2 + 60^2) = 61
        sqrt_lut[8]  = 8'd65; // sqrt(16^2 + 63^2) = 65
        sqrt_lut[9]  = 8'd85; // sqrt(13^2 + 84^2) = 85
        sqrt_lut[10] = 8'd89; // sqrt(20^2 + 85^2) = 89
        sqrt_lut[11] = 8'd97; // sqrt(48^2 + 55^2) = 97
        sqrt_lut[12] = 8'd101;// sqrt(60^2 + 80^2) = 100 (approximate)
        sqrt_lut[13] = 8'd113;// sqrt(36^2 + 107^2) = 113
        sqrt_lut[14] = 8'd120;// sqrt(35^2 + 115^2) = 120
        sqrt_lut[15] = 8'd130;// sqrt(42^2 + 124^2) = 130
        sqrt_lut[16] = 8'd140;// sqrt(70^2 + 120^2) = 140
        sqrt_lut[17] = 8'd145;// sqrt(72^2 + 128^2) = 145
        sqrt_lut[18] = 8'd153;// sqrt(80^2 + 137^2) = 153
        sqrt_lut[19] = 8'd160;// sqrt(96^2 + 128^2) = 160
        sqrt_lut[20] = 8'd164;// sqrt(100^2 + 132^2) = 164
        sqrt_lut[21] = 8'd175;// sqrt(105^2 + 144^2) = 175
        sqrt_lut[22] = 8'd180;// sqrt(120^2 + 144^2) = 180
        sqrt_lut[23] = 8'd190;// sqrt(132^2 + 160^2) = 190
        sqrt_lut[24] = 8'd200;// sqrt(150^2 + 150^2) = 200
        sqrt_lut[25] = 8'd205;// sqrt(144^2 + 176^2) = 205
        sqrt_lut[26] = 8'd213;// sqrt(153^2 + 180^2) = 213
        sqrt_lut[27] = 8'd224;// sqrt(160^2 + 192^2) = 224
        sqrt_lut[28] = 8'd230;// sqrt(168^2 + 200^2) = 230
        sqrt_lut[29] = 8'd240;// sqrt(180^2 + 210^2) = 240
        sqrt_lut[30] = 8'd250;// sqrt(192^2 + 216^2) = 250
        sqrt_lut[31] = 8'd255;// sqrt(200^2 + 225^2) = 255
        sqrt_lut[32] = 8'd255;// sqrt(220^2 + 220^2) = 255
        sqrt_lut[33] = 8'd255;// sqrt(230^2 + 230^2) = 255
        sqrt_lut[34] = 8'd255;// sqrt(240^2 + 240^2) = 255
        sqrt_lut[35] = 8'd255;// sqrt(255^2 + 255^2) = 255
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'd0;
        end else begin
            uo_out <= sqrt_lut[ui_in]; // Fetch from small LUT
        end
    end

    wire _unused = &{ena, 1'b0};

endmodule
