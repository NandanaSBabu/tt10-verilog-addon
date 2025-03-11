module sqrt (
    input [15:0] in,  // Input squared sum (x² + y²)
    output reg [7:0] out  // Approximate sqrt output
);
    integer n;
    reg [15:0] temp;

    always @(*) begin
        out = 0;
        temp = 0;
        for (n = 7; n >= 0; n = n - 1) begin
            temp = (out | (1 << n)) * (out | (1 << n));
            if (temp <= in)
                out = out | (1 << n);
        end
    end
endmodule
